import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/services/calculator.dart';
import 'controller.dart';

//TODO: GET DAY - https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
//TODO: GET HOUR - from datetime (var hour = DateTime.now().hour;) don't duplicate from get_icon.dart

class ControllerUpdate extends GetxController {
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();

  // VAR USED FOR GETX VARIABLES THAT CHANGE WITHIN UPDATE DATA METHOD
  var day = 'Tuesday'.obs;
  var date = 'today'.obs;
  var greeting = 'hello'.obs;
  var lastUpdate = 'now'.obs;
  var sunrise = 'now'.obs;
  var sunset = 'later'.obs;
  var temperature = 0.0.obs;
  var feelsLike = 0.0.obs;
  var main = 'nice'.obs;
  var description = 'very nice'.obs;
  var id = 100.obs;
  var pressure = 0.0.obs;
  var pressureHg = '0.0'.obs;
  var humidity = 0.0.obs;
  var clouds = 110;
  var rain1hr = 10.0.obs;
  var rain3hr = 10.0.obs;
  var snow1hr = 10.0.obs;
  var snow3hr = 10.0.obs;
  var visibility = 0.0.obs;
  var dewpoint = 0.0.obs;
  var windSpeed = 0.0.obs;
  var angle = 0.obs;
  var windDirection = 'n'.obs;
  var gust = 0.0.obs;
  var city = 'home'.obs;
  var initialCity = 'my city'.obs;
  var currentCity = 'current city'.obs;
  var country = 'anywhere but here'.obs;
  var userInput = 'userInput'.obs;
  var lat = 0.0.obs;
  var lon = 0.0.obs;
  var power = 200.0.obs;
  var airDensity = 'thick'.obs;
  var watt = 'wattage'.obs;
  var revoltText = 'something'.obs;
  var revoltScreenText = 'something else'.obs;

  void updateData(dynamic weatherData) async {
    //UPDATE LOCAL TIME VARIABLES ////////////////////////////////////////////////////////
    DateTime _now = DateTime.now();
    day.value = DateFormat.EEEE().format(_now); //weekday
    String _hourNow = DateFormat.H().format(_now); //hour
    date.value = DateFormat.yMMMd('en_US').format(_now);
    int _testTime = int.parse(_hourNow);
    if (_testTime >= 18) {
      greeting.value = 'Good Evening!';
    } else if (_testTime >= 12) {
      greeting.value = 'Good Afternoon!';
    } else {
      greeting.value = 'Good Morning!';
    }

    // COLLECT AND CONVERT MISC TIME VARIABLES FROM WEATHER.DART //////////////////////////
    int _getLastUpdated = weatherData['dt']; // INT
    lastUpdate.value = cf.getReadableTime(_getLastUpdated);
    int _getSunrise = weatherData['sys']['sunrise'];
    sunrise.value = cf.getReadableTime(_getSunrise);
    int _getSunset = weatherData['sys']['sunset'];
    sunset.value = cf.getReadableTime(_getSunset);

    // UPDATE CONDITION VARIABLES FROM WEATHER.DART /////////////////////////////////////////
    temperature.value = weatherData['main']['temp']; // DOUBLE
    feelsLike.value = weatherData['main']['feels_like']; // VAR
    main.value = weatherData['weather'][0]['main']; // ONE WORD DESCRIPTION
    description.value = weatherData['weather'][0]['description']; // MORE THAN ONE WORD
    id.value = weatherData['weather'][0]['id']; // CONDITION CODE
    pressure.value = weatherData['main']['pressure'].toDouble(); // hPa
    pressureHg.value = (pressure.value * 0.02953).toStringAsFixed(2); // inHg
    humidity.value = weatherData['main']['humidity'].toDouble(); // % humidity
    clouds = weatherData['clouds']['all']; // % cloudiness

    // UPDATE PRECIPITATION VARIABLES /////////////////////////////////////////////////////////
    try {
      rain1hr.value = weatherData['rain']['1h'];
    } catch (e) {
      rain1hr.value = 0;
    }
    try {
      rain3hr.value = weatherData['rain']['3h'];
    } catch (e) {
      rain3hr.value = 0;
    }
    try {
      snow1hr.value = weatherData['snow']['1h'];
    } catch (e) {
      snow1hr.value = 0;
    }
    try {
      snow3hr.value = weatherData['snow']['3h'];
    } catch (e) {
      snow3hr.value = 0;
    }

    // VISIBILITY & DEWPOINT //////////////////////////////////////////////////////////////////
    visibility.value = weatherData['visibility'].toDouble(); // in meters - INT or DOUBLE
    if (c.isMetric.value) {
      visibility.value /= 1000; // KM
      dewpoint.value = (temperature.value - ((100 - humidity.value) / 5)); // C
    } else {
      visibility.value = visibility.value / 1.609344 / 1000; // MILES
      dewpoint.value = (temperature.value - 9 / 25 * (100 - humidity.value)); // F
    }

    // UPDATE WIND VARIABLES FROM WEATHER.DART //////////////////////////////////////////////
    windSpeed.value = weatherData['wind']['speed'];
    angle.value = weatherData['wind']['deg'];
    windDirection.value = getWindDirection(angle.value);
    try {
      gust.value = weatherData['wind']['gust'].toInt();
    } catch (e) {
      gust.value = 0;
    }

    // UPDATE LOCATION VARIABLES FROM WEATHER.DART //////////////////////////////////////////
    city.value = weatherData['name'];
    var _getCountry = weatherData['sys']['country'];
    country.value = _getCountry == 'US' ? '' : ', $_getCountry';
    lon.value = weatherData['coord']['lon'].toDouble();
    lat.value = weatherData['coord']['lat'].toDouble();

    // UPDATE VARIABLES IN CALCULATOR.DART //////////////////////////////////////////////////
    // CALCULATE POWER
    Calculator calculator = Calculator();
    power.value = calculator.calculate();

    // CALCULATE DENSITY
    airDensity.value = (calculator.getDensity()).toStringAsFixed(2);

    // UPDATE REVOLT MESSAGE ////////////////////////////////////////////////////////////////
    watt.value = power.value.round() == 1 ? 'Watt' : 'Watts';
    revoltText.value =
        'A REVOLT Hanging Wind Turbine would be producing ${power.value.round()} ${watt.value} of power in ${city.value} with a wind speed of ${windSpeed.value.toInt()} ${c.speedUnits.value}. Tap for more info!';
    revoltScreenText.value =
        'A REVOLT Hanging Wind Turbine would be producing ${power.value.round()} ${watt.value} of power in ${city.value} with a wind speed of ${windSpeed.value.toInt()} ${c.speedUnits.value}.';
  }

// MISC FUNCTIONS CAN BE CALLED FROM ANYWHERE /////////////////////////////////////////////

// CONVERTS ANGLE IN RADIANS TO TEXT DIRECTION
  String getWindDirection(int angle) {
    if (angle < 15 || angle > 340) {
      return 'N';
    } else if (angle >= 15 && angle <= 30) {
      return 'N/NE';
    } else if (angle > 30 && angle < 50) {
      return 'NE';
    } else if (angle >= 50 && angle <= 70) {
      return 'E/NE';
    } else if (angle > 70 && angle < 100) {
      return 'E';
    } else if (angle >= 100 && angle <= 120) {
      return 'E/SE';
    } else if (angle > 120 && angle < 140) {
      return 'SE';
    } else if (angle >= 140 && angle <= 170) {
      return 'S/SE';
    } else if (angle > 170 && angle < 190) {
      return 'S';
    } else if (angle >= 190 && angle <= 210) {
      return 'S/SW';
    } else if (angle > 210 && angle < 230) {
      return 'SW';
    } else if (angle >= 230 && angle <= 250) {
      return 'W/SW';
    } else if (angle > 250 && angle < 280) {
      return 'W';
    } else if (angle >= 280 && angle <= 300) {
      return 'W/NW';
    } else if (angle > 300 && angle < 320) {
      return 'NW';
    } else if (angle >= 320 && angle <= 340) {
      return 'N/NW';
    } else {
      return 'problem locating wind direction';
    }
  }

// RETURNS REVOLT MESSAGE
  String getRevoltMessage() {
    return revoltText.value;
  }

// RETURNS SUNRISE / SUNSET MESSAGE
  String getSunriseMessage() {
    if (initialCity.value == city.value) {
      return 'Sunrise and sunset will occur at:';
    } else {
      return 'In ${initialCity.value} time, sunrise and sunset will occur in ${city.value} at:';
    }
  }

// RETURNS STRING FOR GUSTING WIND
  String gustingWind() {
    if (gust.value != 0) {
      return 'Wind gusting to ${gust.value} ${c.speedUnits.value}';
    } else {
      return 'No gusting wind';
    }
  }

// RETURNS CONTAINER ONLY IF RAIN
  dynamic getRainContainer() {
    // JIC
    rain1hr.value == null ? rain1hr.value = 0 : rain1hr.value = rain1hr.value;
    rain3hr.value == null ? rain3hr.value = 0 : rain3hr.value = rain3hr.value;
    // IF THERE HAS BEEN NO RAIN IN THE LAST THREE HOURS
    if (rain1hr.value != 0 && rain3hr.value != 0) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFF5F6380),
              Color(0xFF383B4F),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            tileMode: TileMode.clamp,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RAIN:'),
                  // RAIN IN LAST HOUR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Last hour:  ${rain1hr.value.toStringAsFixed(2)} mm'),
                      getIconInt(id.value),
                    ],
                  ),
                  // RAIN IN THE LAST 3 HOURS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Last 3 hours:  ${(rain3hr.value + rain1hr.value).toStringAsFixed(2)} mm'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

// RETURNS CONTAINER ONLY IF SNOW
  dynamic getSnowContainer() {
    // JIC
    snow1hr.value == null ? snow1hr.value = 0 : snow1hr.value = snow1hr.value;
    snow3hr.value == null ? snow3hr.value = 0 : snow3hr.value = snow3hr.value;
    // IF THERE HAS BEEN NO SNOW IN THE LAST THREE HOURS
    if (snow1hr.value != 0 && snow3hr.value != 0) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFF5F6380),
              Color(0xFF383B4F),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            tileMode: TileMode.clamp,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SNOW:'),
                  // SNOW IN LAST HOUR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Last hour:  ${snow1hr.value.toStringAsFixed(2)} mm'),
                      getIconInt(id.value),
                    ],
                  ),
                  // SNOW IN THE LAST 3 HOURS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Last 3 hours:  ${(snow3hr.value + snow1hr.value).toStringAsFixed(2)} mm'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
