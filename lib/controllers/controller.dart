import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async'; // FOR TIMER
import 'package:revolt_weather_app/services/current_time.dart';

class Controller extends GetxController {
  var isMetric = false.obs;
  var altitude = 0.0.obs; // in meters
  var altitudeUnits = 'ft'.obs;
  var speedUnits = 'mph'.obs;
  var temperatureUnits = '°F'.obs;
  var distanceUnits = 'miles'.obs;
  var prevScreen = 'previousScreen'.obs;
  var mapLayer = 'wind'.obs;
  var min = '0'.obs;
  var max = '140mm'.obs;
  var fullscreen = false.obs;
  var buyOrView = 'buy'.obs;

  // CHANGE UNITS FROM IMPERIAL TO METRIC AND BACK \\\\\\\\\\\\\\\\\\\\\\
  void updateUnits() async {
    if (isMetric.value) {
      speedUnits.value = 'm/s';
      temperatureUnits.value = '°C';
      distanceUnits.value = 'km';
      altitudeUnits.value = 'm';
    } else {
      speedUnits.value = 'mph';
      temperatureUnits.value = '°F';
      distanceUnits.value = 'miles';
      altitudeUnits.value = 'ft';
    }
  }

  // UPDATEs FOR MAP \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  // UPDATES MIN AND MAX OF LEGEND VALUED DEPENDING UPON UNITS
  void updateLegendMinMax() {
    if (mapLayer.value == 'clouds') {
      min.value = '0';
      max.value = '100%';
    } else if (mapLayer.value == 'wind') {
      min.value = '0';
      max.value = isMetric.value ? '200${speedUnits.value}' : '450${speedUnits.value}';
    } else if (mapLayer.value == 'precipitation') {
      min.value = '0';
      max.value = '140mm';
    } else if (mapLayer.value == 'snow') {
      min.value = '0';
      max.value = '140mm';
    } else if (mapLayer.value == 'pressure') {
      min.value = '27.76';
      max.value = '31.89 inHg';
    } else if (mapLayer.value == 'temp') {
      min.value = isMetric.value ? '-65' : '-85';
      max.value = isMetric.value ? '50${temperatureUnits.value}' : '120${temperatureUnits.value}';
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
}
