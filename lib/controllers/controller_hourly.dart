import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/blue_box.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';

import 'controller.dart';

class ControllerHourly extends GetxController {
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();

  var hourlyPrecip = 0.0.obs;
  var typeOfPrecip = 'PRECIPITATION'.obs;

  var data = <Item>[].obs;

  @override
  void onInit() {
    data(generateItems(48));
    super.onInit();
  }

  // RETURN ROW IF THERE IS PRECIPITATION
  Row getPrecipInfo(int i) {
    try {
      hourlyPrecip.value = cf.hourly[i]['rain']['1h'];
      typeOfPrecip.value = 'RAIN';
    } catch (e) {
      hourlyPrecip.value = 0;
    }
    try {
      hourlyPrecip.value = cf.hourly[i]['snow']['1h'];
      typeOfPrecip.value = 'SNOW';
    } catch (e) {
      hourlyPrecip.value = 0;
    }
    if (hourlyPrecip.value != 0 && (cf.hourly[i]['pop'] * 100) != 0) {
      c.isMetric.value ? hourlyPrecip.value : hourlyPrecip.value /= 25.4;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // BLUE BOX - POP
          blueBox(
            margin: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // BLUE BOX / POP
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: getIconString('raindrop'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CHANCE'),
                    Obx(() => Text('${(cf.hourly[i]['pop'] * 100).toStringAsFixed(1)}%')),
                  ],
                ),
              ],
            ),
          ),
          // BLUE BOX - PRECIPITATION
          blueBox(
            margin: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // BLUE BOX / PRECIPITATION
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: getIconString('raindrops'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text('${typeOfPrecip.value}')),
                    Obx(() => Text('${hourlyPrecip.value} ${c.precipUnits.value}')),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Row();
  }
}

// STORES EXPANSION PANEL STATE INFORMATION
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
    this.index,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
  int index;
}

// GENERATE LIST FOR EXPANSION PANEL
List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
      index: index,
    );
  });
}
