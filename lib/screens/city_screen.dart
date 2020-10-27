import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/city_map_component.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_location.dart';
import 'dart:ui';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/location_screen.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class CityScreen extends StatelessWidget {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerLocation cl = Get.find();

  // IF NO DATA, SHOW SNACKBAR (WEATHER.DART) AND STAY ON SCREEN
  void changeCity() async {
    var confirm = await WeatherModel().getCityWeather();
    if (confirm) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(width: Get.width),
        decoration: kGradientBackgroundDecoration,
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
              // BODY
              child: Column(
                children: [
                  // HEADER
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // BACK BUTTON
                      FlatButton(
                        onPressed: () => Get.back(),
                        child: getIconString('back', color: Colors.white),
                      ),
                      // PAGE TITLE
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: FittedBox(
                          child: Text(
                            'Choose a New City',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 22.0,
                              letterSpacing: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.0),
                ],
              ),
            ),
            // RETURN TO CURRENT LOCATION BUTTON
            Container(
              height: 50.0,
              margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
              decoration: BoxDecoration(
                gradient: kBlueGradientHorizontal,
                boxShadow: kBoxShadowDD,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: FittedBox(
                child: FloatingActionButton.extended(
                  heroTag: 'refresh',
                  elevation: 0,
                  onPressed: () {
                    cl.refresh();
                    Get.offAll(LocationScreen());
                  },
                  icon: getIconString('refresh', color: Colors.white),
                  label: Text(
                    'Return to your location',
                    maxLines: 2,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            // OR TAP ON A MAP LOCATION
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Or, tap on a map location',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, height: 1.5, letterSpacing: 0.7),
              ),
            ),
            // GOOGLE MAP PICKER
            Container(
              height: Get.height / 2,
              width: Get.width,
              margin: EdgeInsets.only(top: 18.0, bottom: 20.0),
              child: CityMapComponent(),
            ),
            // GET WEATHER BUTTON
            Container(
              height: 50.0,
              decoration: BoxDecoration(
                gradient: kBlueGradientHorizontal,
                boxShadow: kBoxShadowDD,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: FloatingActionButton.extended(
                heroTag: 'getWeather',
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
          ],
        ),
      ),
      // ),
    );
  }
}
