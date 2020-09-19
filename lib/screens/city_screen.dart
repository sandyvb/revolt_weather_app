import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/forecast_screen.dart';
import 'package:revolt_weather_app/screens/location_screen.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'package:revolt_weather_app/screens/glance_screen.dart';

class CityScreen extends StatelessWidget {
  final Controller c = Get.find();
  final ControllerUpdate cc = Get.find();

  final focusNode = FocusNode(); // TAP OUTSIDE TEXT FIELD TO CLOSE KEYBOARD

  // CHECK VALIDITY OF getCityWeather() THEN UPDATE weatherData THEN GO BACK TO PREV SCREEN \\\\\\\
  void changeCity() async {
    await WeatherModel().getCityWeather();
    if (c.prevScreen.value == 'locationScreen') {
      Get.to(LocationScreen());
    } else if (c.prevScreen.value == 'glanceScreen') {
      Get.to(GlanceScreen());
    } else if (c.prevScreen.value == 'revoltScreen') {
      Get.to(RevoltScreen());
    } else if (c.prevScreen.value == 'forecastScreen') {
      Get.to(ForecastScreen());
    } else {
      Get.back();
    }
  }

// TODO: get city coords and make method in weather.dart
// TODO: CANT HAVE BOTH NAME AND COORDS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Choose a New City'),
        centerTitle: true,
        toolbarHeight: 100.0,
      ),
      // DISPLAY BACKGROUND IMAGE / SET UP FOCUS NODE / TEXT INPUT / INSTRUCTIONS / GET WEATHER BUTTON
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          children: [
            // BACKGROUND IMAGE
            Positioned(
              top: 50.0,
              right: 0.0,
              child: Image.asset(
                'images/city_background2.jpg',
                filterQuality: FilterQuality.low,
              ),
            ),
            Container(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // TEXT FIELD CHANGES CURRENT CITY
                  Container(
                    padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 15.0),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: kInputDecoration,
                      onChanged: (value) {
                        cc.userInput.value = value;
                      },
                    ),
                  ),
                  // INSTRUCTIONS
                  Text('Use one or more of the following separated by commas:'),
                  Text('CITY, STATE, COUNTRY, ZIP CODE'),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
