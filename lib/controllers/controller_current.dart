import 'dart:async';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:flutter/material.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class ControllerCurrent extends GetxController {
  final ControllerForecast cf = Get.find();

  var timeDifference = 0.0.obs;
  Timer _sunsetTimer;

  void startSunsetTimer() {
    _sunsetTimer = Timer.periodic(
      Duration(minutes: 1),
      (Timer t) {
        getHoursUntilSunset();
      },
    );
  }

  void stopSunsetTimer() {
    _sunsetTimer.cancel();
    print('stop sunset timer');
  }

  // HOURS OR MINUTES UNTIL SUNRISE OR SUNSET
  double getHoursUntilSunset() {
    timeDifference.value = 0;
    cf.sunriseSunsetMessage.value = 'Calculating...';
    if (cf.getSunrise.value == 0 && cf.getSunset.value == 0) {
      cf.sunriseSunsetMessage.value = 'No Data...';
      return 0;
    }
    DateTime now = DateTime.now();
    DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(cf.getSunrise.value * 1000); // DATETIME
    DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(cf.getSunset.value * 1000); // DATETIME
    DateTime sunriseTomorrow = DateTime.fromMillisecondsSinceEpoch(cf.getSunriseTomorrow.value * 1000); // DATETIME

    double sunsetDifference = sunsetTime.difference(now).inMinutes / 60; // HOURS
    double sunriseDifference = sunriseTime.difference(now).inMinutes / 60; // HOURS
    double sunriseTomorrowDifference = sunriseTomorrow.difference(now).inMinutes / 60; // HOURS

    if (sunriseDifference < sunsetDifference && sunriseDifference > 0 && sunsetDifference > 0) {
      // it is before sunrise
      cf.sunriseSunsetMessage.value = sunriseDifference < 1 ? 'min \'til sunrise' : 'hrs \'til sunrise';
      timeDifference.value = sunriseDifference;
    } else if (sunriseDifference < 0 && sunsetDifference > 0) {
      // it is after sunrise and before sunset
      cf.sunriseSunsetMessage.value = sunsetDifference < 1 ? 'min \'til sunset' : 'hrs \'til sunset';
      timeDifference.value = sunsetDifference;
    } else if (sunriseDifference < 0 && sunsetDifference < 0) {
      // it is after sunrise and sunset but before midnight
      cf.sunriseSunsetMessage.value = sunriseTomorrowDifference < 1 ? 'min \'til sunrise' : 'hrs \'til sunrise';
      timeDifference.value = sunriseTomorrowDifference;
    }
    return timeDifference.value;
  }

  Container borderedText({String text}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
      padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 3.0),
      decoration: BoxDecoration(
        border: Border.all(color: kLighterBlue, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Text(text, style: kOxygen.copyWith(height: 1.4)),
    );
  }
}
