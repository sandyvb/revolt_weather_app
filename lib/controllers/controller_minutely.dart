import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'controller.dart';
import 'package:flutter/material.dart';

class ControllerMinutely extends GetxController {
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();
  final ControllerUpdate cu = Get.find();

// GET READABLE TIME & USE HOUR / AM OR PM FOR OTHER FUNCTIONS
  String getTime(int i) {
    String time = cf.getReadableTime(cf.minutely[i]['dt']);
    return time;
  }

  // RETURN 0 IF NULL / RETURN METRIC (int) OR IMPERIAL (double) PRECIP AMT
  Widget getPrecip(int i) {
    var _mmPrecip;
    try {
      _mmPrecip = cf.minutely[i]['precipitation'];
    } catch (e) {
      _mmPrecip = 0;
    }
    return Obx(
      () => Text(
        '${c.isMetric.value ? _mmPrecip.toStringAsFixed(2) : (_mmPrecip / 25.4).toStringAsFixed(2)} ${c.precipUnits.value}',
        style: kOxygenWhite,
      ),
    );
  }

  // RETURN APPROPRIATE WEATHER ICON
  Widget getIcon(int i) {
    String isDayOrNight = cf.getDayOrNight(cf.minutely[i]['dt']);
    return getIconInt(cf.currentWeatherId.value, size: 16.0, dayOrNight: isDayOrNight, color: Colors.white);
  }
}
