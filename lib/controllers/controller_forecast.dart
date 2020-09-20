import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_current.dart';
import 'package:revolt_weather_app/components/get_daily.dart';
import 'package:revolt_weather_app/components/get_hourly.dart';
import 'package:revolt_weather_app/components/get_minutely.dart';
import 'controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ControllerForecast extends GetxController {
  final Controller c = Get.find();

  // https://openweathermap.org/api/one-call-api
  // CURRENT DATA - LENGTH = 14
  var day = 'today'.obs;
  var greeting = 'hello'.obs;
  var sunriseSunsetMessage = 'here and now'.obs;
  var date = 'this day'.obs;
  var currentGetDt = 0.obs;
  var getSunrise = 0.obs;
  var getSunset = 0.obs;
  var currentSunrise = 'soon'.obs;
  var currentSunset = 'later'.obs;
  var currentTemp = 0.0.obs;
  var currentFeelsLike = 0.0.obs;
  var currentPressure = 0.0.obs;
  var currentHumidity = 0.obs;
  var currentDewpoint = 0.0.obs;
  var currentUvi = 0.obs;
  var currentClouds = 0.obs;
  var currentVisibility = 0.0.obs;
  var currentWindSpeed = 0.0.obs;
  var currentWindGust = 0.0.obs;
  var currentWindDeg = 0.obs;
  var currentRain = 0.0.obs;
  var currentSnow = 0.0.obs;
  var currentWeatherId = 0.obs;
  var currentWeatherMain = 'pleasant'.obs;
  var currentWeatherDescription = 'very pleasant'.obs;

  // MINUTELY - LENGTH = 61
  final minutely = <dynamic>[].obs;
  // HOURLY - LENGTH = 48
  final hourly = <dynamic>[].obs;
  // DAILY = LENGTH = 8
  final daily = <dynamic>[].obs;

  void updateForecast(dynamic weatherData) async {
    // GET LISTS
    minutely.value = weatherData['minutely'];
    hourly.value = weatherData['hourly'];
    daily.value = weatherData['daily'];
    // CURRENT TIME / DAY / DATE
    DateTime now = DateTime.now();
    day.value = DateFormat.EEEE().format(now); //weekday
    date.value = DateFormat.yMMMd('en_US').format(now);

    // GATHER ALL DATA
    currentGetDt.value = weatherData['current']['dt']; // INT
    getSunrise.value = weatherData['current']['sunrise']; // INT
    currentSunrise.value = getReadableTime(getSunrise.value); // STRING
    getSunset.value = weatherData['current']['sunset']; // INT
    currentSunset.value = getReadableTime(getSunset.value); // STRING
    currentTemp.value = weatherData['current']['temp']; // VAR - INT or DOUBLE
    currentFeelsLike.value = weatherData['current']['feels_like']; // VAR - INT or DOUBLE
    currentPressure.value = weatherData['current']['pressure']; // INT
    currentHumidity.value = weatherData['current']['humidity']; // INT
    currentDewpoint.value = weatherData['current']['dew_point']; // DOUBLE
    currentUvi.value = weatherData['current']['uvi']; // DOUBLE - MIDDAY UV INDEX
    currentClouds.value = weatherData['current']['clouds']; // INT %
    currentVisibility.value = weatherData['current']['visibility']; // METERS
    if (c.isMetric.value) {
      currentVisibility.value /= 1000; // KM
    } else {
      currentVisibility.value = currentVisibility.value / 1.609344 / 1000; // MILES
    }
    currentWindSpeed.value = weatherData['current']['wind_speed']; // VAR - INT or DOUBLE
    currentWindGust.value = weatherData['current']['wind_gust']; // VAR - INT or DOUBLE
    currentWindDeg.value = weatherData['current']['wind_deg']; // INT
    // MAY BE NULL
    try {
      currentRain.value = weatherData['current']['rain']['1h']; // DOUBLE mm
    } catch (e) {
      currentRain.value = 0;
    }
    try {
      currentSnow.value = weatherData['current']['snow']['1hr']; // DOUBLE mm
    } catch (e) {
      currentSnow.value = 0;
    }
    currentWeatherId.value = weatherData['current']['weather'][0]['id']; // INT
    currentWeatherMain.value = weatherData['current']['weather'][0]['main']; // ONE WORD DESC
    currentWeatherDescription.value = weatherData['current']['weather'][0]['description']; // DESCRIPTION
    minutely.value = weatherData['minutely']; // 61 ITEMS
    hourly.value = weatherData['hourly']; // 48 ITEMS
    daily.value = weatherData['daily']; // 8 ITEMS
  }

  // MISC FUNCTIONS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  String returnUviIndex(var uviIndex) {
    var uvi = uviIndex.toInt();
    if (uvi >= 0 && uvi <= 2) {
      return 'Low ($uvi)';
    } else if (uvi >= 3 && uvi <= 5) {
      return 'Moderate ($uvi)';
    } else if (uvi >= 6 && uvi <= 7) {
      return 'High ($uvi)';
    } else if (uvi >= 8 && uvi <= 10) {
      return 'Very High ($uvi)';
    } else {
      return 'Extreme ($uvi)';
    }
  }

// Example: 12:42 PM
  String getReadableTime(var time) {
    var result = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return DateFormat.jm().format(result);
  }

// Example: 12 (24-hr)
  String getHour(var time) {
    var result = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return DateFormat.H().format(result);
  }

// Example: 8.667 minutes
  dynamic getHoursUntilSunset() {
    var currentTime = currentGetDt; // UNIX INT
    var sunsetTime = getSunset; // UNIX INT
    var sunriseTime = getSunrise;
    var convertCurrentTime = DateTime.fromMillisecondsSinceEpoch(currentTime.value * 1000); // DATETIME
    var convertSunsetTime = DateTime.fromMillisecondsSinceEpoch(sunsetTime.value * 1000); // DATETIME
    var convertSunriseTime = DateTime.fromMillisecondsSinceEpoch(sunriseTime.value * 1000); // DATETIME
    var sunsetDifference = convertSunsetTime.difference(convertCurrentTime).inMinutes / 60; // HOURS
    var sunriseDifference = convertSunriseTime.difference(convertCurrentTime).inMinutes / 60; // HOURS
    if (sunriseDifference > 0) {
      sunriseSunsetMessage.value = sunriseDifference < 1 ? 'min \'til sunrise' : 'hrs \'til sunrise';
      return sunriseDifference;
    } else {
      sunriseSunsetMessage.value = sunsetDifference < 1 ? 'min \'til sunset' : 'hrs \'til sunset';
      return sunsetDifference;
    }
  }

// Example: 12 PM
  String getReadableHour(var time) {
    var result = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return DateFormat.j().format(result);
  }

// Example: Tuesday
  String getWeekDay(var time) {
    var result = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    var weekday = DateFormat.EEEE().format(result).toUpperCase();
    return '$weekday';
  }

// Example: Tuesday, September 15
  String getDayForHourly(var time) {
    var result = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    var weekday = DateFormat.EEEE().format(result);
    var month = DateFormat.MMMM().format(result);
    var numMonthDay = DateFormat.d().format(result);
    return '$weekday, $month $numMonthDay';
  }

// Example: Tuesday Sep 15 | Day
  String getDay(var time) {
    var result = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    var weekday = DateFormat.EEEE().format(result);
    var month = DateFormat.MMM().format(result);
    var numMonthDay = DateFormat.d().format(result);
    return '$weekday $month $numMonthDay  |  Day';
  }

// Example: Tuesday Sep 15 | Night
  String getNight(var time) {
    var result = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    var weekday = DateFormat.EEEE().format(result);
    var month = DateFormat.MMM().format(result);
    var numMonthDay = DateFormat.d().format(result);
    return '$weekday $month $numMonthDay  |  Night';
  }

// Example: Tues 15
  String getAbbrDay(var time) {
    var result = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    var weekday = DateFormat.E().format(result);
    var numMonthDay = DateFormat.d().format(result);
    return '$weekday $numMonthDay';
  }

// RETURN CURRENT / MINUTELY / HOURLY / DAILY COMPONENTS & GREETING \\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  dynamic returnSelectedForecast(String selectedForecast) {
    switch (selectedForecast) {
      case 'current':
        {
          greeting.value = 'Today\'s Forecast';
          return GetCurrent();
        }
      // MINUTELY \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
      case 'minutely':
        {
          greeting.value = '60 Min Forecast';
          return GetMinutely();
        }
      case 'hourly':
        {
          greeting.value = '48 Hr Forecast';
          return GetHourly();
        }
      case 'daily':
        {
          greeting.value = '7 Day Forecast';
          return GetDaily();
        }
        break;
    }
    return Text('OOPS! Could not update screen.');
  }
}
