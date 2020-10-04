import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/components/progress_bar.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_minutely.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class GetMinutely extends StatefulWidget {
  @override
  _GetMinutelyState createState() => _GetMinutelyState();
}

class _GetMinutelyState extends State<GetMinutely> {
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();
  final ControllerMinutely cm = Get.find();
  final ControllerUpdate cu = Get.find();

  List<Widget> list = List<Widget>();

  // ADD COLUMN TIME & PRECIPITATION \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  void addColumnHeadings() {
    // ADD HEADINGS
    list.add(
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        // width: Get.width * 0.89,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${cu.initialCity.value.toUpperCase()} TIME',
              style: kTimePrecipHeadings,
              overflow: TextOverflow.ellipsis,
            ),
            Text('PRECIPITATION', style: kTimePrecipHeadings),
          ],
        ),
      ),
    );
    // ADD DIVIDER
    list.add(gradientDivider(padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 20.0)));
  }

  // LOOP THROUGH MINUTELY & EXTRACT DATA \\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  void getData() {
    for (var i = 0; i < cf.minutely.length; i++) {
      // ADD LIST ITEM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
      list.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(cm.getTime(i), style: kOxygenWhite),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 8.0, right: 25.0),
                  child: Obx(() => cm.getIcon(i)),
                ),
                Obx(() => cm.getPrecip(i)),
              ],
            ),
          ],
        ),
      ));
      // DIVIDER
      list.add(gradientDivider(padding: EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 20.0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    addColumnHeadings();
    getData();
    return Column(
      children: [
        Text(
          'PRECIPITATION',
          style: TextStyle(
            fontSize: 12.0,
            letterSpacing: 0.7,
            color: kLighterBlue,
          ),
        ),
        Obx(() => ProgressBar().getSpotlight(type: 'minutely')),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0)),
        Column(
          children: list,
        ),
      ],
    );
  }
}
