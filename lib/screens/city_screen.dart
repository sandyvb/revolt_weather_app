import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/city_map_component.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'dart:ui';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/glance_screen.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'package:revolt_weather_app/screens/location_screen.dart';
import 'package:revolt_weather_app/screens/forecast_screen.dart';

class CityScreen extends StatelessWidget {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();

  final focusNode = FocusNode(); // TAP OUTSIDE TEXT FIELD TO CLOSE KEYBOARD

  // IF NO DATA, SHOW SNACKBAR (WEATHER.DART) AND STAY ON SCREEN
  // OTHERWISE, GO TO PREVIOUS SCREEN AND REMOVE CITY SCREEN FROM STACK
  void changeCity() async {
    var confirm = await WeatherModel().getCityWeather();
    if (confirm) {
      c.prevScreen.value == 'location'
          ? Get.off(LocationScreen())
          : c.prevScreen.value == 'forecast'
              ? Get.off(ForecastScreen())
              : c.prevScreen.value == 'glance'
                  ? Get.off(GlanceScreen())
                  : Get.back();
      if (cu.city.value == '') {
        cu.city.value = 'No City Name';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: kBlueGradientHorizontal,
            boxShadow: kBoxShadowDD,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: FloatingActionButton.extended(
            elevation: 0,
            onPressed: changeCity,
            icon: getIconString('location', color: Colors.white),
            label: Text(
              'Get Weather',
              style: TextStyle(fontSize: 25.0),
            ),
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: kGradientBackgroundDecoration,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // HEADER
                Container(
                  padding: EdgeInsets.fromLTRB(0, 35.0, 0, 17.0),
                  decoration: BoxDecoration(
                    boxShadow: kBoxShadowDown,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    gradient: kBlueGradientDiagonal,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // GO BACK
                      FlatButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: getIconString('back', color: Colors.white),
                      ),
                      //  CHOOSE A NEW CITY TEXT
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: Get.width * 0.22),
                          child: FittedBox(
                            child: Text(
                              'Choose a New City',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 25.0,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // TEXT INPUT
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    Get.width * 0.10,
                    Get.height * 0.05,
                    Get.width * 0.10,
                    10.0,
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: kInputDecoration,
                    onChanged: (value) {
                      cu.userInput.value = 'q=$value';
                    },
                  ),
                ),
                // INSTRUCTIONS
                Container(
                  width: Get.width * 0.9,
                  child: Column(
                    children: [
                      FittedBox(
                        child: Text(
                          'Use one or more comma separated values',
                          style: TextStyle(fontSize: 15.0, height: 1.5, letterSpacing: 0.7),
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          'CITY, STATE, COUNTRY, ZIP CODE',
                          style: TextStyle(fontSize: 16.0, height: 1.5, letterSpacing: 0.7),
                        ),
                      ),
                      Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        'Tap on a map location',
                        style: TextStyle(fontSize: 16.0, height: 1.5, letterSpacing: 0.7),
                      ),
                    ],
                  ),
                ),

                // GOOGLE MAP PICKER
                Container(
                  height: 250.0,
                  margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
                  child: CityMapComponent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
