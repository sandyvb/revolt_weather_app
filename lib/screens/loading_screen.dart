import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'location_screen.dart';

class LoadingScreen extends StatelessWidget {
  final Controller c = Get.put(Controller());
  final ControllerUpdate cu = Get.put(ControllerUpdate());
  final ControllerForecast cf = Get.put(ControllerForecast());

  // GET USER'S LOCATION FROM DEVICE
  void getLocationData() async {
    await WeatherModel().getLocationWeather();
    Get.off(LocationScreen());
  }

  // SHOW SLIDER WHILE GETTING DATA THEN GO TO LOCATION SCREEN
  @override
  Widget build(BuildContext context) {
    getLocationData();
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: kGradientBackgroundDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                spinnerMode: true,
                size: 110.0,
                customColors: CustomSliderColors(
                  dotColor: Colors.transparent,
                  hideShadow: true,
                ),
                customWidths: CustomSliderWidths(
                  trackWidth: 4.5,
                  progressBarWidth: 4.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text('Retrieving Data...', style: TextStyle(fontSize: 20.0)),
            ),
          ],
        ),
      ),
    );
  }
}
