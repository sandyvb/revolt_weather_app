import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'controller.dart';
import 'package:flutter/material.dart';

class ControllerMinutely extends GetxController {
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();

// GET READABLE TIME & USE HOUR / AM OR PM FOR OTHER FUNCTIONS
  String getTime(int i) {
    String _time;
    try {
      _time = cf.getReadableTime(cf.minutely[i]['dt']);
    } catch (e) {
      _time = 'N/A';
    }
    return _time;
  }

  // RETURN 0 IF NULL / RETURN METRIC (int) OR IMPERIAL (double) PRECIP AMT
  Widget getPrecip(int i) {
    try {
      var _mmPrecip = cf.minutely[i]['precipitation'];
      return Obx(
        () => Text(
          '${c.isMetric.value ? _mmPrecip.toStringAsFixed(2) : (_mmPrecip / 25.4).toStringAsFixed(2)} ${c.precipUnits.value}',
          style: kOxygenWhite,
        ),
      );
    } catch (e) {
      return Text('N/A');
    }
  }

  // RETURN APPROPRIATE WEATHER ICON
  Widget getIcon(int i) {
    try {
      String _isDayOrNight = cf.getDayOrNight(cf.minutely[i]['dt']);
      return getIconInt(cf.currentWeatherId.value, size: 16.0, dayOrNight: _isDayOrNight, color: Colors.white);
    } catch (e) {
      return getIconInt(cf.currentWeatherId.value, size: 16.0, color: Colors.white);
    }
  }
}
