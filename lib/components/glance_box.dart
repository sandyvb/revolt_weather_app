import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'get_icon.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

Widget glanceBox({
  String day,
  var highTemp,
  var lowTemp,
  var iconId,
  String main,
  var pop,
  var windAngle,
  var windSpeed,
}) {
  final Controller c = Get.find();
  return Container(
    width: Get.width / 3.8,
    height: Get.height / 1.2,
    // margin: EdgeInsets.symmetric(horizontal: 5.0),
    padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
    decoration: BoxDecoration(
      boxShadow: kBoxShadowDD,
      borderRadius: BorderRadius.all(
        Radius.circular(15.0),
      ),
      gradient: kBlueGradientVertical,
    ),
    child: Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // DAY
          Text(day, maxLines: 1),
          // DIVIDER
          gradientDividerTransparentEnds(padding: EdgeInsets.symmetric(vertical: 8.0)),
          // HIGH TEMP
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${highTemp.toInt()}${c.temperatureUnits.value}',
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: 'Oxygen',
              ),
            ),
          ),
          // STATUS BAR
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            height: 100,
            width: 25,
            // https://pub.dev/packages/flutter_animation_progress_bar
            child: FAProgressBar(
              currentValue: highTemp.toInt(),
              maxValue: c.isMetric.value ? 66 : 150,
              animatedDuration: const Duration(milliseconds: 1000),
              verticalDirection: VerticalDirection.up,
              direction: Axis.vertical,
              backgroundColor: Colors.white38,
              progressColor: Colors.blue,
              changeColorValue: c.isMetric.value ? 28 : 83,
              changeProgressColor: Colors.red,
              // displayText: '${c.temperatureUnits.value}',
            ),
          ),
          // LOW TEMP
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${lowTemp.toInt()}${c.temperatureUnits.value}',
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: 'Oxygen',
              ),
            ),
          ),
          gradientDividerTransparentEnds(padding: EdgeInsets.symmetric(vertical: 8.0)),
          // WEATHER ICON
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: getIconInt(iconId, size: 45.0, color: Colors.white),
          ),
          // MAIN DESCRIPTION
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$main',
              style: TextStyle(fontSize: 20.0, height: 1.2),
            ),
          ),
          gradientDividerTransparentEnds(padding: EdgeInsets.symmetric(vertical: 8.0)),
          // RAINDROP ICON & POP
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
                  child: getIconString('raindrop', size: 18.0, color: Colors.white),
                ),
                Text('$pop%', style: TextStyle(fontSize: 20.0, fontFamily: 'Oxygen', height: 1.5)),
              ],
            ),
          ),
          gradientDividerTransparentEnds(padding: EdgeInsets.symmetric(vertical: 8.0)),
          // WIND ICON & WIND SPEED
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0, top: 2.0),
            child: getWindIcon(windAngle, color: Colors.white, size: 30.0),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${windSpeed.toInt()} ${c.speedUnits.value}',
              style: TextStyle(fontSize: 20.0, fontFamily: 'Oxygen', height: 1.5),
            ),
          ),
          FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${getWindDirection(windAngle)}',
                style: TextStyle(fontSize: 18.0, fontFamily: 'Oxygen', height: 1.5),
              )),
        ],
      ),
    ),
  );
}
