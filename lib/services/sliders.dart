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
String temperatureTextModifier(double value) {
  final newValue = value.toInt().toString();
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

// RETURNS INIT VALUE FOR LARGE SLEEK CIRCULAR SLIDER
double getLargeSliderInitValue() {
  var min = c.isMetric.value ? -23.3333 : -10.0;
  var max = c.isMetric.value ? 65.5556 : 150.0;
  if (cf.currentTemp.value < min || cf.currentTemp.value > max || cf.currentTemp.value == null) {
    return max / 2;
  } else {
    return cf.currentTemp.value.toDouble();
  }
}

// RETURN SLEEK CIRCULAR SLIDER \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SleekCircularSlider circularSlider({
  double min: -20.0,
  double max = 1000,
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
  // BUG FIX FOR SLIDER
  if (initialValue < -20.0 || initialValue > max || initialValue == null) {
    initialValue = max / 2;
  }
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
