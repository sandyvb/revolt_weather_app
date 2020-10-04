import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:flutter/material.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'controller.dart';

class ControllerGlance extends GetxController {
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();

  // RETURNS CONTAINER ONLY IF RAIN
  dynamic getRainContainer() {
    // IF THERE HAS BEEN RAIN
    if (cf.currentRain.value > 0) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          boxShadow: kBoxShadowDD,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          gradient: kBlueGradientHorizontal,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RAIN:'),
                // RAIN IN LAST HOUR
                Obx(() => Text('Last hour:  ${cf.currentRain.value.toStringAsFixed(2)} ${c.precipUnits.value}')),
              ],
            ),
            Container(
              width: Get.width * 0.25,
              child: FAProgressBar(
                size: 10,
                currentValue: cf.currentRain.value.ceil(),
                maxValue: c.isMetric.value ? 6 : 3,
                animatedDuration: const Duration(milliseconds: 1000),
                direction: Axis.horizontal,
                backgroundColor: Colors.white38,
                progressColor: Colors.deepPurpleAccent,
                changeColorValue: c.isMetric.value ? 4 : 2,
                changeProgressColor: Colors.deepPurple,
                // displayText: '${cf.currentRain.value.ceil()}',
              ),
            ),
            Container(
              height: 40.0,
              padding: EdgeInsets.only(bottom: 15.0),
              child: Obx(() => getIconInt(cf.currentWeatherId.value, size: 25.0, color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  // RETURNS CONTAINER ONLY IF SNOW
  Container getSnowContainer() {
    // IF THERE HAS BEEN SNOW
    if (cf.currentSnow.value > 0) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          boxShadow: kBoxShadowDD,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          gradient: kBlueGradientHorizontal,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SNOW:'),
                // SNOW IN LAST HOUR
                Obx(() => Text('Last hour:  ${cf.currentSnow.value.toStringAsFixed(2)} ${c.precipUnits.value}')),
              ],
            ),
            Container(
              width: Get.width * 0.25,
              child: FAProgressBar(
                size: 10,
                currentValue: cf.currentSnow.value.ceil(),
                maxValue: c.isMetric.value ? 6 : 3,
                animatedDuration: const Duration(milliseconds: 1000),
                direction: Axis.horizontal,
                backgroundColor: Colors.white38,
                progressColor: Colors.deepPurpleAccent,
                changeColorValue: c.isMetric.value ? 4 : 2,
                changeProgressColor: Colors.deepPurple,
                // displayText: '${cf.currentSnow.value.ceil()}',
              ),
            ),
            Container(
              height: 40.0,
              padding: EdgeInsets.only(bottom: 15.0),
              child: Obx(() => getIconInt(cf.currentWeatherId.value, size: 25.0, color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
