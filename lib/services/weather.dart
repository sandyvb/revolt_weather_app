import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/services/location.dart';
import 'networking.dart';

// API KEY FOR OWM
const apiKey = '217da33042b65b3c9e4bd01ab0bdd02b';
// UPDATE UI URL
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';
// MAP URL
const OWMapURL = 'https://tile.openweathermap.org/map/clouds_new/4/15/15.png?appid=217da33042b65b3c9e4bd01ab0bdd02b';
// UPDATE FORECAST URL
const forecastURL = 'https://api.openweathermap.org/data/2.5/onecall';
// ALTITUDE URL
// const altitudeURL = 'https://api.opentopodata.org/v1/srtm90m?locations'; // api url
const altitudeURL = 'https://api.opentopodata.org/v1/test-dataset?locations'; // testing url

class WeatherModel {
  Controller c = Get.find();
  ControllerUpdate cu = Get.find();
  ControllerForecast cf = Get.find();

  void getSnackbar() {
    Get.snackbar(
      'There was a problem',
      'Please try again!',
      icon: getIconString('question', color: Colors.red, size: 40.0),
      shouldIconPulse: true,
      isDismissible: true,
      duration: Duration(milliseconds: 2250),
      colorText: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 50.0),
      padding: EdgeInsets.all(20.0),
      overlayBlur: 1,
      backgroundColor: Colors.yellow,
    );
  }

  // GET DEVICE LOCATION / INITIALIZE UPDATE UI / INITIALIZE INITIAL CITY VALUES / INITIALIZE FORECAST / INITIALIZE ALTITUDE
  Future<void> getLocationWeather() async {
    String units = c.isMetric.value == true ? 'metric' : 'imperial';
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper('$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=$units');
    var weatherData = await networkHelper.getData();
    weatherData == null ? getSnackbar() : cu.updateData(weatherData);
    // INIT KEY GLOBAL VARIABLES
    cu.initialCity.value = weatherData['name'];
    cu.city.value = cu.initialCity.value;
    cu.userInput.value = cu.initialCity.value;
    cu.lat.value = location.latitude;
    cu.lon.value = location.longitude;
    await getCityWeather();
    await getForecast();
    getAltitude();
  }

  // IN CITY SCREEN,
  // FALSE STAYS ON CITY SCREEN UNTIL VALID DATA IS ENTERED BY USER OR BACK BUTTON IS PRESSED
  // TRUE REDIRECTS USER TO PREVIOUS SCREEN
  Future<bool> getCityWeather() async {
    String units = c.isMetric.value == true ? 'metric' : 'imperial';
    var url = '$openWeatherMapURL?q=${cu.userInput.value}&appid=$apiKey&units=$units';
    NetworkHelper networkHelper = NetworkHelper(url);
    var weatherData = await networkHelper.getData();
    if (weatherData == null) {
      getSnackbar();
      return false;
    } else {
      cu.updateData(weatherData);
      await getForecast();
      getAltitude();
      return true;
    }
  }

  Future<void> getForecast() async {
    String units = c.isMetric.value == true ? 'metric' : 'imperial';
    var url = '$forecastURL?lat=${cu.lat.value}&lon=${cu.lon.value}&appid=$apiKey&units=$units';
    NetworkHelper networkHelper = NetworkHelper(url);
    var weatherData = await networkHelper.getData();
    weatherData == null ? getSnackbar() : cf.updateForecast(weatherData);
    getAltitude();
  }

  // https://www.opentopodata.org/
  Future<void> getAltitude() async {
    try {
      var url = '$altitudeURL=${cu.lat.value},${cu.lon.value}';
      NetworkHelper networkHelper = NetworkHelper(url);
      var altData = await networkHelper.getData();
      var altitude = altData == null ? 0 : altData['results'][0]['elevation'];
      c.altitude.value = c.isMetric.value ? altitude : altitude * 3.281;
    } catch (e) {
      print('altitude error: weather.dart: $e');
    }
  }
}
