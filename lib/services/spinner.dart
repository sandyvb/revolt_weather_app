import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// https://pub.dev/packages/sleek_circular_slider

final Controller c = Get.find();
final ControllerUpdate cc = Get.find();

// TEXT MODIFIERS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
String temperatureTextModifier(double value) {
  final newValue = value.toInt().toString();
  return '$newValue${c.temperatureUnits}';
}

String revoltTextModifier(double value) {
  final newValue = value.toInt().toString();
  return '$newValue';
}

String iconTextModifier(double value) {
  final newValue = '${getIconInt(cc.id.value)}';
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

// MISC HELPER FUNCTIONS
String getWatt() {
  return cc.watt.value;
}

// NOT USED
double getMaxWindSpeed() {
  if (c.isMetric.value) {
    if (cc.windSpeed.value > 44.704) {
      return 67.056;
    } else if (cc.windSpeed.value > 22.352) {
      return 44.704;
    } else if (cc.windSpeed.value > 11.176) {
      return 22.352;
    } else if (cc.windSpeed.value > 5.588) {
      return 11.176;
    } else {
      return 5.588;
    }
  } else {
    if (cc.windSpeed.value > 100) {
      return 150.0;
    } else if (cc.windSpeed.value > 50) {
      return 100.0;
    } else if (cc.windSpeed.value > 25) {
      return 50.0;
    } else if (cc.windSpeed.value > 12.5) {
      return 25.0;
    } else {
      return 12.5;
    }
  }
}

// NOT USED
double getMaxPower() {
  if (cc.power.value == 200) {
    return 200;
  }
  return cc.power.value + 5.0;
}

// SMALL SLEEK CIRCULAR SLIDER \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SleekCircularSlider smallSleekCircularSlider({
  double min: -20.0,
  double max = 1000,
  double initialValue = 0,
  var modifier,
  var colors,
  String bottomLabelText,
  double size = 50.0,
  var mainLabelStyle,
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
      startAngle: 0.0,
      angleRange: 360.0,
      customColors: CustomSliderColors(
        trackColor: kHr,
        progressBarColors: colors,
        dotColor: Colors.transparent,
        shadowColor: kBlack.withOpacity(0.2),
        shadowMaxOpacity: 0.01,
      ),
      customWidths: CustomSliderWidths(
        trackWidth: 3.5,
        progressBarWidth: 3.5,
        shadowWidth: 55.0,
      ),
      infoProperties: InfoProperties(
        modifier: modifier,
        mainLabelStyle: mainLabelStyle,
        bottomLabelText: bottomLabelText,
        bottomLabelStyle: kBottomLabelStyle,
      ),
    ),
  );
}
