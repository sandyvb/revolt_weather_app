import 'dart:math';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';

class Calculator {
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();

  // VARIABLES
  double ps;
  double exponent;
  double ps0;
  double st;
  double st0;
  double rh;
  double ro;

  // RETURNS REVOLT POWER
  double calculate({var temp, var dew, var ws}) {
    temp = temp == null ? cf.currentTemp.value.toDouble() : temp;
    dew = dew == null ? cf.currentDewpoint.value : dew;
    ws = ws == null ? cf.currentWindSpeed.value : ws;
    // CONVERSIONS
    if (c.isMetric.value == false) {
      temp = (temp - 32) * 5 / 9; // F to C
      dew = (dew - 32) * 5 / 9; // F to C
      ws = ws / 2.237;
    }

    // CALCULATIONS
    exponent = 7.5 * temp / (temp + 237.3);
    ps = 611 * pow(10, exponent);
    exponent = 7.5 * dew / (dew + 237.3);
    ps0 = 611 * pow(10, exponent);
    st = 217 * ps / (temp + 273.15);
    st0 = 217 * ps0 / (dew + 273.15);
    rh = 100 * st0 / st;
    ro = (cf.currentPressure.value * 100 - 0.003796 * rh * ps) * 0.0034848 / (temp + 273.15); // in [kg/m^3]

    // RETURN POWER
    double power = ro * pow(ws, 3) * 0.2125; // in W
    // RETURN MAXIMUM OF 200
    return (power > 200) ? 200 : power;
  }

  // RETURNS AIR DENSITY
  double getDensity() {
    return ro;
  }
}
