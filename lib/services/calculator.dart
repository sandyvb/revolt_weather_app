import 'dart:math';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';

class Calculator {
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();

  // VARIABLES
  double temp;
  double dew;
  double ws;
  double ps;
  double exponent;
  double ps0;
  double st;
  double st0;
  double rh;
  double ro;

  // RETURNS REVOLT POWER
  double calculate() {
    // CONVERSIONS
    if (c.isMetric.value) {
      temp = cf.currentTemp.value.toDouble(); // C (error if I remove toDouble() ???)
      dew = cf.currentDewpoint.value; // C
      ws = cf.currentWindSpeed.value; // m/s
    } else {
      temp = (cf.currentTemp.value - 32) * 5 / 9; // F to C
      dew = (cf.currentDewpoint.value - 32) * 5 / 9; // F to C
      ws = cf.currentWindSpeed.value / 2.237;
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
