import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class ProgressBar {
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();

  FAProgressBar progressBar({
    int currentValue = 5,
    int maxValue = 10,
    int changeColorValue = 5,
    String displayText,
    double size = 20.0,
    border = 'default',
  }) {
    border = border == 'default' ? Border.all(color: Color(0xFF5C47E0), width: 1) : Border.all(color: Color(0xFF5C47E0), width: 0.25);
    return FAProgressBar(
      size: size,
      currentValue: currentValue,
      maxValue: maxValue,
      animatedDuration: const Duration(milliseconds: 1000),
      verticalDirection: VerticalDirection.up,
      direction: Axis.vertical,
      backgroundColor: Colors.transparent,
      progressColor: Color(0xFF5C47E0),
      displayText: displayText,
      border: border,
    );
  }

  Widget getSpotlight({String type}) {
    var displayText;
    var currentValue;
    var maxValue;
    var width;
    var height;
    var length;
    var border;

    if (type == 'tempDaily') {
      displayText = '';
      maxValue = c.isMetric.value ? 43 : 110;
      width = Get.width / 10;
      height = 75.0;
      length = 8;
      border = 'default';
    } else if (type == 'windDaily') {
      displayText = '';
      maxValue = c.isMetric.value ? 9 : 20;
      width = Get.width / 10;
      height = 60.0;
      length = 8;
      border = 'default';
    } else if (type == 'powerDaily') {
      displayText = '';
      maxValue = 40;
      width = Get.width / 10;
      height = 60.0;
      length = 8;
      border = 'default';
    } else if (type == 'popDaily') {
      displayText = '';
      maxValue = 100;
      width = Get.width / 10;
      height = 60.0;
      length = 8;
      border = 'default';
    } else if (type == 'humidityDaily') {
      displayText = '';
      maxValue = 100;
      width = Get.width / 10;
      height = 60.0;
      length = 8;
      border = 'default';
    } else if (type == 'uviDaily') {
      displayText = '';
      maxValue = 10;
      width = Get.width / 10;
      height = 60.0;
      length = 8;
      border = 'default';
    } else if (type == 'tempHourly') {
      maxValue = c.isMetric.value ? 43 : 110;
      width = Get.width / 60;
      height = 75.0;
      length = 48;
      border = null;
    } else if (type == 'windHourly') {
      maxValue = c.isMetric.value ? 9 : 20;
      width = Get.width / 60;
      height = 60.0;
      length = 48;
      border = null;
    } else if (type == 'powerHourly') {
      maxValue = 50;
      width = Get.width / 60;
      height = 60.0;
      length = 48;
      border = null;
    } else if (type == 'precipHourly') {
      maxValue = 600;
      width = Get.width / 60;
      height = 60.0;
      length = 48;
      border = null;
    } else if (type == 'popHourly') {
      maxValue = 100;
      width = Get.width / 60;
      height = 60.0;
      length = 48;
      border = null;
    } else if (type == 'humidityHourly') {
      maxValue = 100;
      width = Get.width / 60;
      height = 60.0;
      length = 48;
      border = null;
    } else if (type == 'cloudsHourly') {
      maxValue = 100;
      width = Get.width / 60;
      height = 60.0;
      length = 48;
      border = null;
    } else {
      // MINUTELY
      maxValue = 600;
      width = Get.width / 80;
      height = 60.0;
      length = 61;
      border = null;
    }

    List<Widget> list = new List<Widget>();
    for (int i = 0; i < length; i++) {
      if (type == 'tempDaily') {
        currentValue = cf.daily[i]['temp']['max'].toInt();
      } else if (type == 'windDaily') {
        currentValue = i == 0 ? cf.currentWindSpeed.value.toInt() : cf.daily[i]['wind_speed'].toInt();
      } else if (type == 'powerDaily') {
        currentValue = cf.getRevoltPower(i, type: 'daily').toInt();
      } else if (type == 'popDaily') {
        currentValue = (cf.daily[i]['pop'] * 100).toInt();
      } else if (type == 'humidityDaily') {
        currentValue = cf.daily[i]['humidity'].toInt();
      } else if (type == 'uviDaily') {
        currentValue = cf.daily[i]['uvi'].toInt();
      } else if (type == 'powerHourly') {
        currentValue = cf.getRevoltPower(i, type: 'hourly').toInt();
      } else if (type == 'tempHourly') {
        currentValue = cf.hourly[i]['temp'].toInt();
      } else if (type == 'windHourly') {
        currentValue = cf.hourly[i]['wind_speed'].toInt();
      } else if (type == 'precipHourly') {
        currentValue = (cf.hourly[i]['pop'] * 100).toInt() + 20;
      } else if (type == 'popHourly') {
        currentValue = (cf.hourly[i]['pop'] * 100).toInt();
      } else if (type == 'humidityHourly') {
        currentValue = cf.hourly[i]['humidity'].toInt();
      } else if (type == 'cloudsHourly') {
        currentValue = cf.hourly[i]['clouds'].toInt();
      } else {
        try {
          currentValue = (cf.minutely[i]['precipitation'] * 100).toInt() + 20;
        } catch (e) {
          currentValue = 20;
        }
      }

      list.add(
        Container(
          width: width,
          child: Center(
            child: progressBar(
              size: width,
              displayText: displayText,
              currentValue: currentValue,
              maxValue: maxValue,
              border: border,
            ),
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: list,
      ),
    );
  }

  Widget getSpotlightText() {
    var width = Get.width / 10;
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < 8; i++) {
      var text = i == 0 ? 'Today' : cf.getWeekDayAbbr(cf.daily[i]['dt']);
      list.add(
        Container(
          width: width,
          child: Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                text,
                style: TextStyle(
                  color: kLighterBlue,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: list,
      ),
    );
  }

  Widget getSpotlightTextHourly() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${cf.getReadableHour(cf.hourly[0]['dt'])} TODAY',
              style: TextStyle(
                fontSize: 12.0,
                letterSpacing: 0.7,
                color: kLighterBlue,
              )),
          Text('${cf.getReadableHour(cf.hourly[47]['dt'])} ${cf.getWeekDay(cf.hourly[47]['dt'])}',
              style: TextStyle(
                fontSize: 12.0,
                letterSpacing: 0.7,
                color: kLighterBlue,
              )),
        ],
      ),
    );
  }
}
