import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'controller.dart';

class ControllerMap extends GetxController {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerForecast cf = Get.find();

  var mapLayer = 'wind'.obs;
  var min = '0'.obs;
  var max = '5.5in'.obs;
  var fullscreen = false.obs;
  var legendText = 'nice day!'.obs;

  void getSnackbar() {
    Get.snackbar(
      '',
      'Please wait...',
      titleText: FittedBox(child: Text('Retrieving Data', style: TextStyle(color: kLighterBlue))),
      icon: Icon(MaterialCommunityIcons.map_search_outline),
      shouldIconPulse: false,
      isDismissible: true,
      duration: Duration(milliseconds: 800),
      colorText: kLighterBlue,
      snackPosition: SnackPosition.BOTTOM,
      maxWidth: Get.width * 0.6,
      margin: EdgeInsets.symmetric(vertical: Get.height / 3),
      padding: EdgeInsets.fromLTRB(35.0, 15.0, 0.0, 15.0),
      backgroundColor: Color(0xFF222536),
    );
  }

  // UPDATES MIN AND MAX OF LEGEND VALUED DEPENDING UPON UNITS
  void updateLegendMinMax() {
    if (mapLayer.value == 'clouds') {
      min.value = '0';
      max.value = '100%';
    } else if (mapLayer.value == 'wind') {
      min.value = '0';
      max.value = c.isMetric.value ? '200${c.speedUnits.value}' : '450${c.speedUnits.value}';
    } else if (mapLayer.value == 'precipitation') {
      min.value = '0';
      max.value = c.isMetric.value ? '140mm' : '5.5in';
    } else if (mapLayer.value == 'snow') {
      min.value = '0';
      max.value = c.isMetric.value ? '140mm' : '5.5in';
    } else if (mapLayer.value == 'pressure') {
      min.value = '27.76';
      max.value = '31.89 inHg';
    } else if (mapLayer.value == 'temp') {
      min.value = c.isMetric.value ? '-65' : '-85';
      max.value = c.isMetric.value ? '50${c.temperatureUnits.value}' : '120${c.temperatureUnits.value}';
    } else {
      min.value = 'min';
      max.value = 'max';
    }
  }

  // UPDATES COLOR STOPS DEPENDING UPON MAP LAYER
  List<double> updateLegendStops() {
    if (mapLayer.value == 'clouds') {
      return [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
    } else if (mapLayer.value == 'wind') {
      return [0.005, 0.025, 0.075, 0.08, 0.125, 0.25, 0.5, 1.0];
    } else if (mapLayer.value == 'precipitation') {
      return [0.0, 0.001, 0.002, 0.005, 0.01, 0.1, 1.0];
    } else if (mapLayer.value == 'snow') {
      return [0.0, 0.2, 0.4, 1.0];
    } else if (mapLayer.value == 'pressure') {
      return [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];
    } else if (mapLayer.value == 'temp') {
      return [0.0, 0.05, 0.08, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 1.0];
    } else {
      return [];
    }
  }

  // UPDATES COLOR GRADIENTS DEPENDING UPON MAP LAYER
  List<Color> updateLegend() {
    updateLegendMinMax();
    updateLegendText();
    if (mapLayer.value == 'clouds') {
      return [
        Color.fromRGBO(255, 255, 255, 0.0),
        Color.fromRGBO(253, 253, 255, 0.1),
        Color.fromRGBO(252, 251, 255, 0.2),
        Color.fromRGBO(250, 250, 255, 0.3),
        Color.fromRGBO(249, 248, 255, 0.4),
        Color.fromRGBO(247, 247, 255, 0.5),
        Color.fromRGBO(246, 245, 255, 0.75),
        Color.fromRGBO(244, 244, 255, 1),
        Color.fromRGBO(243, 242, 255, 1),
        Color.fromRGBO(242, 241, 255, 1),
        Color.fromRGBO(240, 240, 255, 1),
      ];
    } else if (mapLayer.value == 'wind') {
      return [
        Color.fromRGBO(255, 255, 255, 0),
        Color.fromRGBO(238, 206, 206, 0.4),
        Color.fromRGBO(179, 100, 188, 0.7),
        Color.fromRGBO(179, 100, 188, 0.7),
        Color.fromRGBO(63, 33, 59, 0.8),
        Color.fromRGBO(116, 76, 172, 0.9),
        Color.fromRGBO(70, 0, 175, 1),
        Color.fromRGBO(13, 17, 38, 1),
      ];
    } else if (mapLayer.value == 'precipitation') {
      return [
        Color.fromRGBO(225, 200, 100, 0),
        Color.fromRGBO(200, 150, 150, 0),
        Color.fromRGBO(150, 150, 170, 0),
        Color.fromRGBO(120, 120, 190, 0),
        Color.fromRGBO(110, 110, 205, 0.3),
        Color.fromRGBO(80, 80, 225, 0.7),
        Color.fromRGBO(20, 20, 255, 0.9),
      ];
    } else if (mapLayer.value == 'snow') {
      return [
        Colors.transparent,
        Color(0xFF00d8ff),
        Color(0xFF00b6ff),
        Color(0xFF9549ff),
      ];
    } else if (mapLayer.value == 'pressure') {
      return [
        Color.fromRGBO(0, 115, 255, 1),
        Color.fromRGBO(0, 170, 255, 1),
        Color.fromRGBO(75, 208, 214, 1),
        Color.fromRGBO(141, 231, 199, 1),
        Color.fromRGBO(176, 247, 32, 1),
        Color.fromRGBO(240, 184, 0, 1),
        Color.fromRGBO(251, 85, 21, 1),
        Color.fromRGBO(243, 54, 59, 1),
        Color.fromRGBO(198, 0, 0, 1),
      ];
    } else if (mapLayer.value == 'temp') {
      return [
        Color.fromRGBO(130, 22, 146, 1),
        Color.fromRGBO(130, 22, 146, 1),
        Color.fromRGBO(130, 22, 146, 1),
        Color.fromRGBO(130, 22, 146, 1),
        Color.fromRGBO(130, 87, 219, 1),
        Color.fromRGBO(32, 140, 236, 1),
        Color.fromRGBO(32, 196, 232, 1),
        Color.fromRGBO(35, 221, 221, 1),
        Color.fromRGBO(194, 255, 40, 1),
        Color.fromRGBO(255, 240, 40, 1),
        Color.fromRGBO(255, 194, 40, 1),
        Color.fromRGBO(252, 128, 20, 1),
      ];
    } else {
      return [];
    }
  }

  // UPDATE MAP LEGEND AT BOTTOM OF MAP
  void updateLegendText() {
    String city = cu.city.value == 'Somewhere' ? '${cu.city.value}' : 'In ${cu.city.value}';
    if (mapLayer.value == 'clouds') {
      legendText.value = '$city the cloud cover is ${cf.currentClouds.value}%';
    } else if (mapLayer.value == 'wind') {
      legendText.value = '$city the wind speed is ${cf.currentWindSpeed.value.toInt()} ${c.speedUnits.value}.  ${cf.gustingWind()}';
    } else if (mapLayer.value == 'precipitation') {
      legendText.value = '$city, there has been ${cf.currentRain.value.toStringAsFixed(1)} ${c.precipUnits.value} of rain in the last hour';
    } else if (mapLayer.value == 'snow') {
      legendText.value = '$city, there has been ${cf.currentSnow.value.toStringAsFixed(1)} ${c.precipUnits.value} of snow in the last hour';
    } else if (mapLayer.value == 'pressure') {
      legendText.value = '$city the pressure is ${cf.currentPressureHg.value} inHg';
    } else if (mapLayer.value == 'temp') {
      legendText.value = '$city the temperature is ${cf.currentTemp.value.toInt()}${c.temperatureUnits.value}';
    } else {
      legendText.value = 'No data available';
    }
  }
}
