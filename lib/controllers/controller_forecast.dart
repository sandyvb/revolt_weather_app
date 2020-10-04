import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_current.dart';
import 'package:revolt_weather_app/components/get_daily.dart';
import 'package:revolt_weather_app/components/get_hourly.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/components/get_minutely.dart';
import 'package:revolt_weather_app/screens/alert_screen.dart';
import 'package:revolt_weather_app/services/calculator.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ControllerForecast extends GetxController {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();

  // https://openweathermap.org/api/one-call-api
  // CURRENT DATA - LENGTH = 14
  var day = 'today'.obs;
  var lastUpdate = 'now'.obs;
  var greetingLocationScreen = 'hello'.obs;
  var greetingSelectedForecast = 'forecast'.obs;
  var date = 'this day'.obs;
  var currentDt = 0.obs;
  var getSunrise = 0.obs;
  var getSunset = 0.obs;
  var getSunriseTomorrow = 0.obs;
  var getSunsetTomorrow = 0.obs;
  var currentSunrise = 'soon'.obs;
  var currentSunset = 'later'.obs;
  var currentTemp = 0.0.obs;
  var currentFeelsLike = 0.0.obs;
  var currentPressure = 0.0.obs;
  var currentPressureHg = 'pressureHg'.obs;
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
  var selectedForecast = 'current'.obs;
  var isSelected = [true, false, false, false].obs;
  var sunriseSunsetMessage = 'Calculating...'.obs;
  var timeDifference = 0.0.obs;
  var senderName = 'weather service'.obs;
  var event = 'weather event'.obs;
  var eventDescription = 'weather event description'.obs;
  var isEvent = false.obs;
  var power = 200.0.obs;
  var airDensity = 'thick'.obs;
  var watt = 'wattage'.obs;
  var revoltText = 'cool windmill'.obs;

  // MINUTELY - LENGTH = 61
  final minutely = <dynamic>[].obs;

  // HOURLY - LENGTH = 48
  final hourly = <dynamic>[].obs;

  // DAILY - LENGTH = 8
  final daily = <dynamic>[].obs;

  // ALERTS - LENGTH = 1
  // ['sender_name', 'event', 'start', 'end', 'description']
  final alerts = <dynamic>[].obs;

  void updateForecast(dynamic weatherData) async {
    //UPDATE LOCAL TIME VARIABLES ////////////////////////////////////////////////////////
    DateTime _now = DateTime.now();
    getDayOrNight();
    day.value = DateFormat.EEEE().format(_now); //weekday
    String _hourNow = DateFormat.H().format(_now); //hour
    date.value = DateFormat.yMMMd('en_US').format(_now);
    int _testTime = int.parse(_hourNow);
    if (_testTime >= 18) {
      greetingLocationScreen.value = 'Good Evening!';
    } else if (_testTime >= 12) {
      greetingLocationScreen.value = 'Good Afternoon!';
    } else {
      greetingLocationScreen.value = 'Good Morning!';
    }

    // GATHER ALL DATA
    currentDt.value = weatherData['current']['dt']; // INT
    lastUpdate.value = getReadableTime(currentDt.value);
    getSunrise.value = weatherData['current']['sunrise']; // INT
    currentSunrise.value = getReadableTime(getSunrise.value); // STRING
    getSunset.value = weatherData['current']['sunset']; // INT
    getSunriseTomorrow.value = weatherData['daily'][1]['sunrise']; // INT
    getSunsetTomorrow.value = weatherData['daily'][1]['sunset']; // INT
    currentSunset.value = getReadableTime(getSunset.value); // STRING
    currentTemp.value = weatherData['current']['temp']; // VAR - INT or DOUBLE
    currentFeelsLike.value = weatherData['current']['feels_like']; // VAR - INT or DOUBLE
    currentPressure.value = weatherData['current']['pressure']; // INT
    currentPressureHg.value = (currentPressure.value * 0.02953).toStringAsFixed(2);
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
    try {
      currentWindGust.value = weatherData['wind']['gust'].toInt();
    } catch (e) {
      currentWindGust.value = 0;
    }
    currentWindDeg.value = weatherData['current']['wind_deg']; // INT
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
    c.isMetric.value ? currentRain.value : currentRain.value /= 25.4;
    c.isMetric.value ? currentSnow.value : currentSnow.value /= 25.4;
    currentWeatherId.value = weatherData['current']['weather'][0]['id']; // INT
    currentWeatherMain.value = weatherData['current']['weather'][0]['main']; // ONE WORD DESC
    currentWeatherDescription.value = weatherData['current']['weather'][0]['description']; // DESCRIPTION
    // GET LISTS
    minutely.value = weatherData['minutely']; // 61 ITEMS
    hourly.value = weatherData['hourly']; // 48 ITEMS
    daily.value = weatherData['daily']; // 8 ITEMS

    try {
      alerts.value = weatherData['alerts']; // 1 ITEM
      senderName.value = alerts[0]['sender_name'];
      event.value = alerts[0]['event'];
      String desc = alerts[0]['description'];
      desc = desc.replaceAll('\n', ' ');
      desc = desc.replaceFirst('...', '');
      desc = desc.replaceAll('...', '\n\n');
      desc = desc.replaceFirst('*', '•');
      desc = desc.replaceAll('*', '\n\n•');
      desc = desc.replaceAll('.', '.  ');
      eventDescription.value = desc;
      isEvent.value = true;
    } catch (e) {
      isEvent.value = false;
    }

    // UPDATE VARIABLES IN CALCULATOR.DART //////////////////////////////////////////////////
    // CALCULATE POWER
    Calculator calculator = Calculator();
    power.value = calculator.calculate();

    // CALCULATE DENSITY
    airDensity.value = (calculator.getDensity()).toStringAsFixed(2);

    // UPDATE REVOLT MESSAGE ////////////////////////////////////////////////////////////////
    watt.value = power.value.round() == 1 ? 'Watt' : 'Watts';
    revoltText.value =
        'A REVOLT Hanging Wind Turbine would be producing ${power.value.round()} ${watt.value} of power in ${cu.city.value} with a wind speed of ${currentWindSpeed.value.toInt()} ${c.speedUnits.value}.';
  }

  // MISC FUNCTIONS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  String gustingWind() {
    if (currentWindGust.value > 0) {
      return 'gusting to ${currentWindGust.value} ${c.speedUnits.value}';
    }
    return '';
  }

// Example: Moderate (6)
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

// Example: 12 PM
  String getReadableHour(var time) {
    var result = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return DateFormat.j().format(result);
  }

// Example: Tuesday
  String getWeekDay(var time) {
    var result = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return DateFormat.EEEE().format(result).toUpperCase();
  }

  // Example: Tue
  String getWeekDayAbbr(var time) {
    var result = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return DateFormat.E().format(result);
  }

// Example: Tuesday, September 15 - NOT USED
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

// RETURN CURRENT / MINUTELY / HOURLY / DAILY COMPONENTS & GREETING
  dynamic returnSelectedForecast() {
    switch (selectedForecast.value) {
      case 'current':
        {
          greetingSelectedForecast.value = 'Today\'s Forecast';
          return GetCurrent();
        }
      case 'minutely':
        {
          greetingSelectedForecast.value = '60 Min Forecast';
          return GetMinutely();
        }
      case 'hourly':
        {
          greetingSelectedForecast.value = '48 Hr Forecast';
          return GetHourly();
        }
      case 'daily':
        {
          greetingSelectedForecast.value = '7 Day Forecast';
          return GetDaily();
        }
        break;
    }
    return Text('OOPS! Could not update screen.');
  }

  // FLOATING ACTION BUTTON FOR ALL SCREENS EXCEPT LOCATION SCREEN
  Container isWeatherEvent(dynamic margin) {
    return isEvent.value
        ? Container(
            margin: margin,
            child: FloatingActionButton(
              onPressed: () => Get.to(AlertScreen()),
              child: getIconString('alert', color: Colors.white),
              backgroundColor: Color(0xFFC42E2C),
              mini: true,
            ),
          )
        : Container();
  }

  // FLOATING ACTION BUTTON EXTENDED FOR ALL SCREENS EXCEPT LOCATION SCREEN
  Container isWeatherEventExtended(dynamic margin) {
    return isEvent.value
        ? Container(
            margin: margin,
            child: FloatingActionButton.extended(
              onPressed: () => Get.to(AlertScreen()),
              icon: getIconString('alert', color: Colors.white),
              label: Text(
                '${event.value.toUpperCase()}!',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xFFC42E2C),
            ),
          )
        : Container();
  }

  String getDayOrNight([int time]) {
    String isDayOrNight;
    if (cu.initialCity.value == cu.city.value) {
      DateTime now = time == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(time * 1000);
      DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(getSunrise.value * 1000); // DATETIME
      DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(getSunset.value * 1000); // DATETIME
      DateTime sunriseTomorrow = DateTime.fromMillisecondsSinceEpoch(getSunriseTomorrow.value * 1000); // DATETIME
      DateTime sunsetTomorrow = DateTime.fromMillisecondsSinceEpoch(getSunsetTomorrow.value * 1000); // DATETIME

      double sunsetDifference = sunsetTime.difference(now).inMinutes / 60; // HOURS
      double sunriseDifference = sunriseTime.difference(now).inMinutes / 60; // HOURS
      double sunriseTomorrowDifference = sunriseTomorrow.difference(now).inMinutes / 60; // HOURS
      double sunsetTomorrowDifference = sunsetTomorrow.difference(now).inMinutes / 60;

      if (sunriseDifference < sunsetDifference && sunriseDifference > 0 && sunsetDifference > 0) {
        // it is before sunrise
        isDayOrNight = 'night';
      } else if (sunriseDifference < 0 && sunsetDifference > 0) {
        // it is after sunrise and before sunset
        isDayOrNight = 'day';
      } else if (sunriseDifference < 0 && sunsetDifference < 0) {
        // it is after sunrise and sunset today
        // check to see if it's before sunrise tomorrow
        if (sunriseTomorrowDifference > 0) {
          isDayOrNight = 'night';
        } else if (sunriseTomorrowDifference < 0 && sunsetTomorrowDifference > 0) {
          isDayOrNight = 'day';
        } else if (sunriseTomorrowDifference < 0 && sunsetTomorrowDifference < 0) {
          isDayOrNight = 'night';
        }
      }
    } else {
      isDayOrNight = 'neither';
    }
    return isDayOrNight;
  }
}
