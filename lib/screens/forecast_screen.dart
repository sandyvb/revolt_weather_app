import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_current.dart';
import 'package:revolt_weather_app/components/get_daily.dart';
import 'package:revolt_weather_app/components/get_hourly.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/components/get_minutely.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/components/mini_nav.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class ForecastScreen extends StatefulWidget {
  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerForecast cf = Get.find();
  final ScrollController _scrollController = ScrollController();

  Widget selectedForecast = GetCurrent();
  String greetingSelectedForecast = 'TODAY\'S FORECAST';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: Obx(() => cf.isWeatherEvent(EdgeInsets.only(top: 165.0))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: kGradientBackgroundDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // HEADER
            Container(
              padding: EdgeInsets.only(top: 35.0),
              decoration: BoxDecoration(
                color: kHeaderBlue,
                boxShadow: kBoxShadowDown,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // BACK / GREETING / UNITS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => Get.back(),
                        child: getIconString('back', color: Colors.white),
                      ),
                      // GREETING
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: FittedBox(
                            child: Text(
                              greetingSelectedForecast,
                              style: kGreetingText,
                            ),
                          ),
                        ),
                      ),
                      // UNITS
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Obx(
                              () => Switch(
                                inactiveThumbColor: Colors.white,
                                activeColor: kSwitchColor,
                                value: c.isMetric.value,
                                onChanged: (value) async {
                                  c.isMetric.value = value;
                                  await c.updateUnits();
                                  await WeatherModel().getForecast();
                                },
                              ),
                            ),
                            Text('C°'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  // DATE & TIME
                  cf.getDayDate(),
                  // DIVIDER
                  gradientDivider(padding: EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 0)),
                  // SELECT FORECAST - CURRENT / MINUTELY / HOURLY / DAILY BUTTONS
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Obx(
                      () => ToggleButtons(
                        constraints: BoxConstraints.expand(
                          width: Get.width / 4.4,
                          height: 40.0,
                        ),
                        fillColor: Colors.white12,
                        selectedColor: Colors.white,
                        color: Colors.white54,
                        highlightColor: kHr,
                        borderColor: kLighterBlue.withOpacity(0.5),
                        selectedBorderColor: kLighterBlue.withOpacity(0.5),
                        borderWidth: 2.0,
                        borderRadius: BorderRadius.circular(25),
                        textStyle: kLighterBlueText,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: FittedBox(child: Text('CURRENT', style: TextStyle(fontSize: 14.0))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: FittedBox(child: Text('DAILY', style: TextStyle(fontSize: 14.0))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: FittedBox(child: Text('HOURLY', style: TextStyle(fontSize: 14.0))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: FittedBox(child: Text('MINUTE', style: TextStyle(fontSize: 14.0))),
                          ),
                        ],
                        onPressed: (int index) {
                          _scrollController.animateTo(
                            0.0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                          for (int i = 0; i < cf.isSelected.length; i++) {
                            if (i == index) {
                              cf.isSelected[i] = !cf.isSelected[i];
                            } else {
                              cf.isSelected[i] = false;
                            }
                          }
                          if (index == 0) {
                            setState(() {
                              greetingSelectedForecast = 'TODAY\'S FORECAST';
                              selectedForecast = GetCurrent();
                            });
                          } else if (index == 1) {
                            setState(() {
                              greetingSelectedForecast = '7 DAY FORECAST';
                              selectedForecast = GetDaily();
                            });
                          } else if (index == 2) {
                            setState(() {
                              greetingSelectedForecast = '48 HR FORECAST';
                              selectedForecast = GetHourly();
                            });
                          } else {
                            setState(() {
                              greetingSelectedForecast = '60 MIN FORECAST';
                              selectedForecast = GetMinutely();
                            });
                          }
                        },
                        isSelected: cf.isSelected,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // DISPLAY SELECTED FORECAST
            Expanded(
              child: ListView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  miniNav(),
                  // DIVIDER
                  gradientDivider(padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0)),
                  selectedForecast,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
