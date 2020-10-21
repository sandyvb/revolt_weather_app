import 'dart:async';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';

class ControllerCurrent extends GetxController {
  final ControllerForecast cf = Get.find();

  // TIMER KEEPS CURRENT TIME
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

  @override
  void onInit() {
    getHoursUntilSunset();
    startSunsetTimer();
    super.onInit();
  }

  @override
  void onClose() {
    _sunsetTimer.cancel();
    print('close sunset timer');
    super.onClose();
  }

  // HOURS OR MINUTES UNTIL SUNRISE OR SUNSET
  void getHoursUntilSunset() {
    cf.timeDifference.value = 0;
    cf.sunriseSunsetMessage.value = 'Calculating...';
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
      cf.timeDifference.value = sunriseDifference;
    } else if (sunriseDifference < 0 && sunsetDifference > 0) {
      // it is after sunrise and before sunset
      cf.sunriseSunsetMessage.value = sunsetDifference < 1 ? 'min \'til sunset' : 'hrs \'til sunset';
      cf.timeDifference.value = sunsetDifference;
    } else if (sunriseDifference < 0 && sunsetDifference < 0) {
      // it is after sunrise and sunset but before midnight
      cf.sunriseSunsetMessage.value = sunriseTomorrowDifference < 1 ? 'min \'til sunrise' : 'hrs \'til sunrise';
      cf.timeDifference.value = sunriseTomorrowDifference;
    }
  }
}
