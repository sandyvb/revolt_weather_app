import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'location_screen.dart';

class LoadingScreen extends StatelessWidget {
  final Controller c = Get.find();
  final ControllerUpdate cc = Get.find();
  final ControllerForecast cf = Get.find();

  // GET USER'S LOCATION FROM DEVICE
  void getLocationData() async {
    await WeatherModel().getLocationWeather();
    Get.to(LocationScreen());
  }

  // SHOW SLIDER WHILE GETTING DATA THEN GO TO LOCATION SCREEN
  @override
  Widget build(BuildContext context) {
    getLocationData();
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          gradient: LinearGradient(
            colors: [
              Color(0xFF37394B),
              Color(0xFF292B38),
              Color(0xFF222536),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            tileMode: TileMode.clamp,
          ),
        ),
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
          ],
        ),
      ),
    );
  }
}
