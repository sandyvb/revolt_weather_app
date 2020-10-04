import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/services/weather.dart';

class ControllerLocation extends GetxController {
  final ControllerForecast cf = Get.find();

  void refresh() async {
    await WeatherModel().getLocationWeather();
  }
}
