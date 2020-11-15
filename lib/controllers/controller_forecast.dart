import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/alert_screen.dart';
import 'package:revolt_weather_app/services/calculator.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class ControllerForecast extends GetxController {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();

  // https://openweathermap.org/api/one-call-api
  // CURRENT DATA - LENGTH = 14
  var day = 'today'.obs;
  var lastUpdate = 'now'.obs;
  var greetingLocationScreen = 'hello'.obs;
  var date = 'this day'.obs;
  var currentDt = 0.obs;
  var getSunrise = 0.obs;
  var getSunset = 0.obs;
  var getSunriseTomorrow = 0.obs;
  var getSunsetTomorrow = 0.obs;
  var getSunriseTheNextDay = 0.obs;
  var currentSunrise = 'soon'.obs;
  var currentSunset = 'later'.obs;
  var currentTemp = 0.0.obs;
  var currentFeelsLike = 0.0.obs;
  var currentPressure = 0.0.obs;
  var currentPressureHg = 'pressureHg'.obs;
  var currentHumidity = 0.obs;
  var currentDewpoint = 0.0.obs;
  var currentUvi = 0.0.obs;
  var currentClouds = 0.obs;
  var currentVisibility = 0.0.obs;
  var currentWindSpeed = 0.0.obs;
  var currentWindGust = 0.0.obs;
  var currentWindDeg = 0.obs;
  var currentRain = 0.0.obs;
  var currentRain1h = 0.0.obs;
  var currentSnow = 0.0.obs;
  var currentSnow1h = 0.0.obs;
  var currentWeatherId = 0.obs;
  var currentWeatherMain = 'pleasant'.obs;
  var currentWeatherDescription = 'very pleasant'.obs;
  var isSelected = [true, false, false, false].obs;
  var sunriseSunsetMessage = 'Calculating...'.obs;
  var senderName = 'weather service'.obs;
  var event = 'weather event'.obs;
  var eventDescription = 'weather event description'.obs;
  var isEvent = false.obs;
  var power = 200.0.obs;
  var airDensity = 'thick'.obs;
  var watt = 'wattage'.obs;
  var revoltText = 'cool windmill'.obs;

  // CURRENT
  var current = <dynamic>[].obs;

  // MINUTELY - LENGTH = 61
  var minutely = <dynamic>[].obs;

  // HOURLY - LENGTH = 48
  var hourly = <dynamic>[].obs;

  // DAILY - LENGTH = 8
  var daily = <dynamic>[].obs;

  // ALERTS - LENGTH = 1
  var alerts = <dynamic>[].obs;

  void updateForecast(dynamic weatherData) async {
    final Calculator calculator = Calculator();

    //UPDATE LOCAL TIME VARIABLES ////////////////////////////////////////////////////////
    DateTime _now = DateTime.now();
    getDayOrNight();
    day.value = DateFormat.EEEE().format(_now); //weekday
    String _hourNow = DateFormat.H().format(_now); //hour
    date.value = DateFormat.yMMMMd('en_US').format(_now);
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

    // REMOTE LOCATIONS SOMETIMES DON'T PROVIDE SUNRISE/SUNSET OR MINUTELY DATA
    try {
      getSunrise.value = weatherData['current']['sunrise']; // INT
      currentSunrise.value = getReadableTime(getSunrise.value); // STRING
    } catch (e) {
      getSunrise.value = 0;
      currentSunrise.value = 'N/A';
    }
    try {
      getSunset.value = weatherData['current']['sunset']; // INT
      currentSunset.value = getReadableTime(getSunset.value); // STRING

    } catch (e) {
      getSunset.value = 0;
      currentSunset.value = 'N/A';
    }
    getSunriseTomorrow.value = weatherData['daily'][1]['sunrise']; // INT
    getSunsetTomorrow.value = weatherData['daily'][1]['sunset']; // INT
    getSunriseTheNextDay.value = weatherData['daily'][2]['sunrise']; // INT
    currentTemp.value = weatherData['current']['temp'].toDouble(); // VAR - INT or DOUBLE
    currentFeelsLike.value = weatherData['current']['feels_like'].toDouble(); // VAR - INT or DOUBLE
    currentPressure.value = weatherData['current']['pressure'].toDouble(); // INT
    currentPressureHg.value = (currentPressure.value * 0.02953).toStringAsFixed(2);
    currentHumidity.value = weatherData['current']['humidity']; // INT
    currentDewpoint.value = weatherData['current']['dew_point'].toDouble(); // DOUBLE
    currentUvi.value = weatherData['current']['uvi'].toDouble(); // DOUBLE - MIDDAY UV INDEX
    currentClouds.value = weatherData['current']['clouds']; // INT %

    // visibility
    currentVisibility.value = weatherData['current']['visibility'].toDouble(); // INT METERS
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

    // PRECIPITATION
    // currentSnow.value = weatherData['current']['snow'];
    // currentRain.value = weatherData['current']['rain'];
    try {
      currentRain1h.value = weatherData['current']['rain']['1h']; // DOUBLE mm
    } catch (e) {
      currentRain1h.value = 0;
    }
    try {
      currentSnow1h.value = weatherData['current']['snow']['1hr']; // DOUBLE mm
    } catch (e) {
      currentSnow1h.value = 0;
    }

    currentWeatherId.value = weatherData['current']['weather'][0]['id']; // INT
    currentWeatherMain.value = weatherData['current']['weather'][0]['main']; // ONE WORD DESC
    currentWeatherDescription.value = weatherData['current']['weather'][0]['description']; // DESCRIPTION
    // GET LISTS
    // minutely = weatherData['minutely']; // 61 ITEMS
    minutely(weatherData['minutely']); // 61 ITEMS
    hourly(weatherData['hourly']); // 48 ITEMS
    daily(weatherData['daily']); // 8 ITEMS

    try {
      alerts = weatherData['alerts']; // 1 ITEM
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
    power.value = calculator.calculate();

    // CALCULATE DENSITY
    airDensity.value = (calculator.getDensity()).toStringAsFixed(2);

    // UPDATE REVOLT MESSAGE ////////////////////////////////////////////////////////////////
    watt.value = power.value.ceil() == 1 ? 'Watt' : 'Watts';
    if (cu.city.value.contains('SOMEWHERE')) {
      String _newValue = cu.city.value;
      _newValue = _newValue.replaceFirst('\n', ' ');
      _newValue = _newValue.replaceFirst('SOMEWHERE AT', 'Somewhere at');
      revoltText.value =
          'A REVOLT Hanging Wind Turbine would be producing ${power.value.ceil()} ${watt.value} of power $_newValue with a wind speed of ${currentWindSpeed.value.toInt()} ${c.speedUnits.value}.';
    } else {
      revoltText.value =
          'A REVOLT Hanging Wind Turbine would be producing ${power.value.ceil()} ${watt.value} of power in ${cu.city.value} with a wind speed of ${currentWindSpeed.value.toInt()} ${c.speedUnits.value}.';
    }
  }

  // MISC FUNCTIONS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  Container getDayDate() {
    return Container(
      width: Get.width * 0.85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${day.value.toUpperCase()}',
              style: kHeadingText,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${date.value.toUpperCase()}',
              style: kHeadingText,
            ),
          ),
        ],
      ),
    );
  }

  int getRevoltPower(int i, {var type}) {
    final Calculator calculator = Calculator();

    var result;
    if (type == 'daily') {
      result = i == 0
          ? calculator.calculate().ceil()
          : calculator
              .calculate(
                temp: daily[i]['temp']['max'],
                dew: daily[i]['dew_point'],
                ws: daily[i]['wind_speed'],
              )
              .ceil();
    } else {
      result = i == 0
          ? calculator.calculate().ceil()
          : calculator
              .calculate(
                temp: hourly[i]['temp'],
                dew: hourly[i]['dew_point'],
                ws: hourly[i]['wind_speed'],
              )
              .ceil();
    }
    return result;
  }

  String gustingWind() {
    if (currentWindGust.value > 0) {
      return 'gusting to ${currentWindGust.value} ${c.speedUnits.value}';
    }
    return '';
  }

// Example: Moderate (6)
  Text returnUviIndex(var uviIndex) {
    String value;
    if (uviIndex == null) return Text('Unknown...', style: kOxygenWhite.copyWith(color: kLighterBlue, fontStyle: FontStyle.italic));
    var uvi = uviIndex.toInt();
    if (uvi >= 0 && uvi <= 2) {
      value = 'Low ($uvi)';
    } else if (uvi >= 3 && uvi <= 5) {
      value = 'Moderate ($uvi)';
    } else if (uvi >= 6 && uvi <= 7) {
      value = 'High ($uvi)';
    } else if (uvi >= 8 && uvi <= 10) {
      value = 'Very High ($uvi)';
    } else {
      value = 'Extreme ($uvi)';
    }
    return Text(value, style: kOxygenWhite);
  }

// Example: 12:42 PM
  String getReadableTime(var time) {
    DateTime result = DateTime.fromMillisecondsSinceEpoch(time * 1000);
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
  String getAbbrNight(var time) {
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
  Center isWeatherEventExtended() {
    return isEvent.value
        ? Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 20.0),
              height: 40.0,
              padding: EdgeInsets.fromLTRB(10.0, 2.0, 15.0, 2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xFFC42E2C),
              ),
              child: FittedBox(
                child: GestureDetector(
                  onTap: () => Get.to(AlertScreen()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getIconString('alert', color: Colors.white),
                      SizedBox(width: 5.0),
                      Text(
                        '${event.value.toUpperCase()}!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Center();
  }

  String getDayOrNight([int time]) {
    String isDayOrNight;
    if (cu.initialCity.value == cu.city.value) {
      DateTime now = time == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(time * 1000);
      DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(getSunrise.value * 1000); // DATETIME
      DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(getSunset.value * 1000); // DATETIME
      DateTime sunriseTomorrow = DateTime.fromMillisecondsSinceEpoch(getSunriseTomorrow.value * 1000); // DATETIME
      DateTime sunsetTomorrow = DateTime.fromMillisecondsSinceEpoch(getSunsetTomorrow.value * 1000); // DATETIME
      DateTime sunriseTheNextDay = DateTime.fromMillisecondsSinceEpoch(getSunriseTheNextDay.value * 1000); // DATETIME

      double sunsetDifference = sunsetTime.difference(now).inMinutes / 60; // HOURS
      double sunriseDifference = sunriseTime.difference(now).inMinutes / 60; // HOURS
      double sunriseTomorrowDifference = sunriseTomorrow.difference(now).inMinutes / 60; // HOURS
      double sunsetTomorrowDifference = sunsetTomorrow.difference(now).inMinutes / 60; // HOURS
      double sunriseTheNextDayDifference = sunriseTheNextDay.difference(now).inMinutes / 60; // HOURS

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
        } else if (sunriseTomorrowDifference < 0 && sunsetTomorrowDifference < 0 && sunriseTheNextDayDifference > 0) {
          isDayOrNight = 'night';
        } else if (sunriseTheNextDayDifference < 0) {
          isDayOrNight = 'day';
        }
      }
    } else {
      isDayOrNight = 'neither';
    }
    return isDayOrNight;
  }
}
