import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/city_screen.dart';
import 'package:revolt_weather_app/screens/glance_screen.dart';
import 'package:revolt_weather_app/screens/location_screen.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

// HORIZONTAL SCROLL - https://stackoverflow.com/questions/49153087/flutter-scrolling-to-a-widget-in-listview

class ForecastScreen extends StatelessWidget {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerForecast cf = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: Obx(() => cf.isWeatherEvent(EdgeInsets.only(top: 170.0))),
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
                color: Color(0xFF3B3C4E),
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
                      Obx(
                        () => Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: FittedBox(
                              child: Text(
                                '${cf.greetingSelectedForecast.value}',
                                style: kGreetingText,
                              ),
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
                        fillColor: kLightestBlue,
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
                            cf.selectedForecast.value = 'current';
                          } else if (index == 1) {
                            cf.selectedForecast.value = 'daily';
                          } else if (index == 2) {
                            cf.selectedForecast.value = 'hourly';
                          } else {
                            cf.selectedForecast.value = 'minutely';
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
                  // CITY / LAST UPDATED / HOME / CITY / GLANCE BUTTONS
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // CITY / LAST UPDATED
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // CITY
                              Obx(
                                () => FittedBox(
                                  child: Text(
                                    '${cu.city.value.toUpperCase()}${cu.country.value}',
                                    style: kHeadingTextLarge,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // LAST UPDATED
                              Obx(
                                () => FittedBox(
                                  child: Text(
                                    'last update: ${cf.lastUpdate.value}',
                                    style: kSubHeadingText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // HOME BUTTON
                        IconButton(
                          icon: getIconString('home', size: 25.0),
                          onPressed: () => Get.off(LocationScreen()),
                        ),
                        // CITY BUTTON
                        IconButton(
                          icon: getIconString('city'),
                          onPressed: () {
                            c.prevScreen.value = 'forecast';
                            Get.off(CityScreen());
                          },
                        ),
                        // FORECAST BUTTON
                        IconButton(
                          icon: getIconString('glance'),
                          onPressed: () => Get.off(GlanceScreen()),
                        ),
                      ],
                    ),
                  ),
                  // DIVIDER
                  gradientDivider(padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0)),
                  Obx(() => cf.returnSelectedForecast()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
