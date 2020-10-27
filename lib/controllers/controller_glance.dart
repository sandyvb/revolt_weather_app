import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:flutter/material.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'controller.dart';

class ControllerGlance extends GetxController {
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();

  // RETURNS CONTAINER ONLY IF RAIN
  Container getRainContainer() {
    bool isRain = false;
    if (!cf.currentRain1h.value.isNullOrBlank && cf.currentRain1h.value > 0) isRain = true;

    return isRain
        ? Container(
            margin: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 10.0),
            padding: EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              boxShadow: kBoxShadowDD,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              gradient: kBlueGradientHorizontal,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('RAIN:', style: kHeadingTextLarge.copyWith(color: Colors.white)),
                    Transform.translate(offset: Offset(0, -10), child: Obx(() => getIconInt(cf.currentWeatherId.value, size: 30.0, color: Colors.white))),
                  ],
                ),
                gradientDividerTransparentEnds(padding: EdgeInsets.only(top: 15.0, bottom: 25.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Obx(
                        () => FittedBox(
                          child: Text(
                            isRain
                                ? c.isMetric.value
                                    ? 'Last Hour:  ${cf.currentRain1h.value.toStringAsFixed(2)} ${c.precipUnits.value}'
                                    : 'Last Hour: ${(cf.currentRain1h.value / 25.4).toStringAsFixed(2)} ${c.precipUnits.value}'
                                : 'Last Hour: 0 ${c.precipUnits.value}',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: Get.width * 0.25,
                        child: FAProgressBar(
                          size: 20,
                          currentValue: cf.currentRain1h.value.isNullOrBlank ? 0 : cf.currentRain1h.value.ceil(),
                          maxValue: c.isMetric.value ? 6 : 3,
                          animatedDuration: const Duration(milliseconds: 1000),
                          direction: Axis.horizontal,
                          backgroundColor: Colors.white38,
                          progressColor: Colors.deepPurpleAccent,
                          changeColorValue: c.isMetric.value ? 4 : 2,
                          changeProgressColor: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }

  // RETURNS CONTAINER ONLY IF SNOW
  Container getSnowContainer() {
    bool isSnow = false;
    if (!cf.currentSnow1h.value.isNullOrBlank && cf.currentSnow1h.value > 0) isSnow = true;

    return isSnow
        ? Container(
            margin: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 10.0),
            padding: EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              boxShadow: kBoxShadowDD,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              gradient: kBlueGradientHorizontal,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SNOW:', style: kHeadingTextLarge.copyWith(color: Colors.white)),
                    Transform.translate(offset: Offset(0, -10), child: Obx(() => getIconInt(cf.currentWeatherId.value, size: 30.0, color: Colors.white))),
                  ],
                ),
                gradientDividerTransparentEnds(padding: EdgeInsets.only(top: 15.0, bottom: 25.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Obx(
                        () => FittedBox(
                          child: Text(
                            isSnow
                                ? c.isMetric.value
                                    ? 'Last Hour:  ${cf.currentSnow1h.value.toStringAsFixed(2)} ${c.precipUnits.value}'
                                    : 'Last Hour: ${(cf.currentSnow1h.value / 25.4).toStringAsFixed(2)} ${c.precipUnits.value}'
                                : 'Last Hour: 0 ${c.precipUnits.value}',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: Get.width * 0.25,
                        child: FAProgressBar(
                          size: 20,
                          currentValue: cf.currentSnow1h.value.isNullOrBlank ? 0 : cf.currentSnow1h.value.ceil(),
                          maxValue: c.isMetric.value ? 6 : 3,
                          animatedDuration: const Duration(milliseconds: 1000),
                          direction: Axis.horizontal,
                          backgroundColor: Colors.white38,
                          progressColor: Colors.deepPurpleAccent,
                          changeColorValue: c.isMetric.value ? 4 : 2,
                          changeProgressColor: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }
}
