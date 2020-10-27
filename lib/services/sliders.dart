import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// https://pub.dev/packages/sleek_circular_slider

final Controller c = Get.find();
final ControllerUpdate cu = Get.find();
final ControllerForecast cf = Get.find();

// TEXT MODIFIERS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
String tempTextModifierCurrent(double value) {
  final newValue = cf.currentTemp.value.toInt();
  return '$newValue${c.temperatureUnits}';
}

String tempTextModifierMorn(double value) {
  final newValue = cf.daily[0]['temp']['morn'].toInt();
  return '$newValue${c.temperatureUnits}';
}

String tempTextModifierDay(double value) {
  final newValue = cf.daily[0]['temp']['day'].toInt();
  return '$newValue${c.temperatureUnits}';
}

String tempTextModifierEve(double value) {
  final newValue = cf.daily[0]['temp']['eve'].toInt();
  return '$newValue${c.temperatureUnits}';
}

String tempTextModifierNight(double value) {
  final newValue = cf.daily[0]['temp']['night'].toInt();
  return '$newValue${c.temperatureUnits}';
}

String revoltTextModifier(double value) {
  final newValue = value.ceil().toString();
  return '$newValue';
}

String windTextModifier(double value) {
  final newValue = value.toInt().toString();
  return '$newValue';
}

String hourTillSunsetTextModifier(double value) {
  var hourValue = value.floor();
  var minDecimalValue = value - hourValue;
  var minValue = ((minDecimalValue * 60).toInt()).toString().padLeft(2, '0');
  return '$hourValue:$minValue';
}

String percentTextModifier(double value) {
  final newValue = value.toInt().toString();
  return '$newValue%';
}

String nullTextModifier(double value) {
  return '';
}

// RETURN SLEEK CIRCULAR SLIDER \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SleekCircularSlider circularSlider({
  double min: 0.0,
  double max = 100,
  double initialValue = 0,
  var modifier,
  var colors,
  shadowColor = kBlack,
  shadowMaxOpacity: 0.01,
  trackWidth: 4.0,
  progressBarWidth: 4.0,
  shadowWidth: 55.0,
  String bottomLabelText,
  double size = 50.0,
  var mainLabelStyle,
  double startAngle = 0.0,
  double angleRange = 360.0,
  bottomLabelStyle = kBottomLabelStyle,
}) {
  return SleekCircularSlider(
    min: min,
    max: max,
    initialValue: initialValue,
    appearance: CircularSliderAppearance(
      size: size,
      startAngle: startAngle,
      angleRange: angleRange,
      customColors: CustomSliderColors(
        trackColor: kHr,
        progressBarColors: colors,
        dotColor: Colors.transparent,
        shadowColor: shadowColor,
        shadowMaxOpacity: shadowMaxOpacity,
      ),
      customWidths: CustomSliderWidths(
        trackWidth: trackWidth,
        progressBarWidth: progressBarWidth,
        shadowWidth: shadowWidth,
      ),
      infoProperties: InfoProperties(
        modifier: modifier,
        mainLabelStyle: mainLabelStyle,
        bottomLabelText: bottomLabelText,
        bottomLabelStyle: bottomLabelStyle,
      ),
    ),
  );
}

SleekCircularSlider loadingSpinner() {
  return SleekCircularSlider(
    appearance: CircularSliderAppearance(
      spinnerMode: true,
      size: 110.0,
      customColors: CustomSliderColors(
        dotColor: Colors.transparent,
        hideShadow: true,
      ),
      customWidths: CustomSliderWidths(
        trackWidth: 4.5,
        progressBarWidth: 4.5,
      ),
    ),
  );
}
