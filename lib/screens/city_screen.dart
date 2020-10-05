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
          : c.prevScreen.value == 'forecast' ? Get.off(ForecastScreen()) : c.prevScreen.value == 'glance' ? Get.off(GlanceScreen()) : Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          padding: EdgeInsets.only(top: 45),
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/city_background4.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // HEADER
              Row(
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
                          style: kGreetingText,
                        ),
                      ),
                    ),
                  ),
                ],
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
                    cu.userInput.value = value;
                  },
                ),
              ),
              // INSTRUCTIONS
              Text(
                'Use one or more comma separated values:',
                style: TextStyle(fontSize: 15.0, height: 1.5),
                textAlign: TextAlign.center,
              ),
              Text(
                'CITY, STATE, COUNTRY, ZIP CODE',
                style: TextStyle(fontSize: 16.0, height: 1.5),
                textAlign: TextAlign.center,
              ),
              // GET WEATHER BUTTON
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  color: kLightBlue.withOpacity(0.70),
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  onPressed: () {
                    changeCity();
                  },
                  child: Text(
                    'Get Weather',
                    style: TextStyle(fontSize: 25.0),
                  ),
                ),
              ),
              Container(
                height: 250.0,
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
                child: CityMapComponent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
