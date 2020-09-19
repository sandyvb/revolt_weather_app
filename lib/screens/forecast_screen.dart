import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/city_screen.dart';
import 'package:revolt_weather_app/screens/glance_screen.dart';
import 'package:revolt_weather_app/screens/location_screen.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'package:revolt_weather_app/services/current_time.dart';
import 'dart:async'; // FOR TIMER

// HORIZONTAL SCROLL - https://stackoverflow.com/questions/49153087/flutter-scrolling-to-a-widget-in-listview

class ForecastScreen extends StatefulWidget {
  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final ControllerUpdate cc = Get.find();
  final ControllerForecast cf = Get.find();
  final Controller c = Get.find();

  CurrentTime currentTime = CurrentTime();
  Timer _timer;
  List<bool> isSelected = [true, false, false, false];
  String selectedForecast;

  @override
  void initState() {
    selectedForecast = 'current';
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => currentTime.getTime());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void refresh() async {
    await WeatherModel().getForecast();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // TO AVOID OVER FLOW ADD RESIZE TO AVOID BOTTOM PADDING
      resizeToAvoidBottomPadding: false,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          gradient: LinearGradient(
            colors: [
              Color(0xFF37394B),
              Color(0xFF292B38),
              Color(0xFF222536),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            tileMode: TileMode.clamp,
          ),
        ),
        // HEADER / BODY
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // HEADER
            Container(
              padding: EdgeInsets.only(top: 35.0),
              decoration: BoxDecoration(
                color: Color(0xFF3B3C4E),
                boxShadow: [
                  BoxShadow(
                    color: kBlack.withOpacity(0.8),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              // BACK / REFRESH / GREETING / UNITS / DATE / TIME / DIVIDER
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
                        child: getIconString('back'),
                      ),
                      // GREETING
                      Text('${cf.greeting.value}', style: kGreetingText),
                      // UNITS
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Obx(
                              () => Switch(
                                activeColor: kActiveColor,
                                value: c.isMetric.value,
                                onChanged: (value) async {
                                  c.isMetric.value = value;
                                  c.updateUnits();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('${cf.day.value.toUpperCase()}', style: kHeadingText),
                      Text('${cf.date.value.toUpperCase()}', style: kHeadingText),
                      Text('${currentTime.getTime()}', style: kHeadingText),
                    ],
                  ),
                  // DIVIDER
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 0.0),
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
                  ),
                  // SELECT FORECAST - CURRENT / MINUTELY / HOURLY / DAILY BUTTONS
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ToggleButtons(
                      constraints: BoxConstraints.expand(width: 90.0, height: 40.0),
                      fillColor: kLightestBlue,
                      selectedColor: Colors.white,
                      color: Colors.white54,
                      highlightColor: kHr,
                      borderColor: kLightestBlue,
                      borderWidth: 2.0,
                      borderRadius: BorderRadius.circular(25),
                      textStyle: kToggleButtonText,
                      children: <Widget>[
                        // Icon(Icons.format_bold),
                        Text(' CURRENT'),
                        Text('DAILY'),
                        Text('HOURLY'),
                        Text('MINUTELY '),
                      ],
                      isSelected: isSelected,
                      onPressed: (int index) {
                        setState(() {
                          for (int indexBtn = 0; indexBtn < isSelected.length; indexBtn++) {
                            if (indexBtn == index) {
                              isSelected[indexBtn] = true;
                              switch (indexBtn) {
                                case 0:
                                  {
                                    selectedForecast = 'current';
                                    break;
                                  }
                                case 1:
                                  {
                                    selectedForecast = 'daily';
                                    break;
                                  }
                                case 2:
                                  {
                                    selectedForecast = 'hourly';
                                    break;
                                  }
                                case 3:
                                  {
                                    selectedForecast = 'minutely';
                                    break;
                                  }
                                  break;
                              }
                            } else {
                              isSelected[indexBtn] = false;
                            }
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // DISPLAY SELECTED FORECAST
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  // CITY / LAST UPDATED / NAVIGATION BUTTONS
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // CITY / LAST UPDATED
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CITY
                            SizedBox(
                              width: 185.0,
                              child: Text(
                                '${cc.city.value.toUpperCase()}${cc.country.value}',
                                style: kHeadingTextLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // LAST UPDATED
                            Text('last updated: ${cc.lastUpdate.value}', style: kSubHeadingText),
                          ],
                        ),
                        // HOME BUTTON / NEW CITY BUTTON / DETAILS BUTTON
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // HOME BUTTON
                            IconButton(
                              icon: getIconString('home', 25.0, kLighterBlue),
                              onPressed: () => Get.to(LocationScreen()),
                            ),
                            // CITY BUTTON
                            IconButton(
                              icon: getIconString('city'),
                              onPressed: () {
                                c.prevScreen.value = 'forecastScreen';
                                Get.to(CityScreen());
                              },
                            ),
                            // DETAILS BUTTON
                            IconButton(
                              icon: getIconString('details'),
                              onPressed: () => Get.to(GlanceScreen()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // DIVIDER
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
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
                  ),
                  Container(child: cf.returnSelectedForecast(selectedForecast)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
