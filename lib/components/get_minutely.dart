import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class GetMinutely extends StatefulWidget {
  @override
  _GetMinutelyState createState() => _GetMinutelyState();
}

class _GetMinutelyState extends State<GetMinutely> {
  final ControllerForecast cf = Get.find();

  List<Widget> list = List<Widget>();
  var precip;
  var time;
  Icon icon;

  // ADD COLUMN TIME & PRECIPITATION \\\\\\\\\\\\\\\\\\\\\\\\\\\\
  void addColumnHeadings() {
    // ADD HEADINGS
    list.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('TIME', style: kHeadingText),
          Text('PRECIPITATION', style: kHeadingText),
        ],
      ),
    ));
    // ADD DIVIDER
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 20.0),
      child: SizedBox(
        height: 2.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kHr, Color(0xFF5988F9), kHr],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      ),
    ));
  }

  // LOOP THROUGH MINUTELY & EXTRACT DATA \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  void getData() {
    for (var i = 0; i < cf.minutely.length; i++) {
      // GET READABLE TIME & PRECIPITATION \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
      time = cf.getReadableTime(cf.minutely[i]['dt']);
      precip = cf.minutely[i]['precipitation'];
      // GET HOUR & AM OR PM TO DISPLAY PROPER ICON \\\\\\\\\\\\\\\\\\\\\\
      var hour = int.parse(time.substring(0, time.indexOf(':')));
      var amPm = time.substring(time.length - 2);
      if (precip == 0 && hour >= 8 && hour <= 6 && amPm == 'PM') {
        icon = Icon(WeatherIcons.wi_night_clear, size: 16.0);
      } else if (precip == 0) {
        icon = Icon(WeatherIcons.wi_day_sunny, size: 16.0);
      } else {
        icon = Icon(WeatherIcons.wi_raindrops, size: 16.0);
      }
      // ASSEMBLE DATA \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
      list.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$time'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(margin: EdgeInsets.only(bottom: 8.0, right: 25.0), child: icon),
                Text('$precip mm'),
              ],
            ),
          ],
        ),
      ));
      // DIVIDER
      list.add(Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 20.0),
        child: SizedBox(
          height: 2.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kHr, Color(0xFF5988F9), kHr],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    addColumnHeadings();
    getData();
    return Column(
      children: list,
    );
  }
}
