import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/components/map_component.dart';
import 'package:revolt_weather_app/components/revolt_container.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/city_screen.dart';
import 'package:revolt_weather_app/screens/forecast_screen.dart';
import 'package:revolt_weather_app/services/current_time.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'package:revolt_weather_app/screens/location_screen.dart';
import 'dart:async'; // FOR TIMER

class GlanceScreen extends StatefulWidget {
  @override
  _GlanceScreenState createState() => _GlanceScreenState();
}

class _GlanceScreenState extends State<GlanceScreen> {
  final Controller c = Get.find();
  final ControllerUpdate cc = Get.find();
  final ControllerForecast cf = Get.find();

  CurrentTime currentTime = CurrentTime();
  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => currentTime.getTime());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // TODO: add maps - https://pub.dev/packages/flutter_webview_plugin
  // TODO: from https://openweathermap.org/api/weathermaps
  // TODO: add email, messaging, phone calls from - https://pub.dev/packages/url_launcher
  // TODO: add forecast - 5 or 7 day - https://openweathermap.org/api
  // TODO: figure out sliders - https://pub.dev/packages/flutter_animation_progress_bar
  // TODO: or - https://pub.dev/packages/flutter_rounded_progress_bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BACKGROUND GRADIENT / BODY \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          gradient: LinearGradient(
            colors: [
              Color(0xFF37394B),
              Color(0xFF292B38),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            tileMode: TileMode.clamp,
          ),
        ),
        // BODY
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // HEADER BACKGROUND GRADIENT
            Container(
              padding: EdgeInsets.fromLTRB(0, 35.0, 0, 17.0),
              decoration: BoxDecoration(
                color: kTopColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF709EFE),
                    Color(0xFF5C47E0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.clamp,
                ),
              ),
              // BODY
              child: Column(
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // BACK BUTTON
                      FlatButton(
                        onPressed: () => Get.to(LocationScreen()),
                        child: getIconString('back'),
                      ),
                      // PAGE TITLE
                      Text('At a Glance', style: kGreetingText),
                      // SWITCH UNITS
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // OBX SWITCH
                            Obx(
                              () => Switch(
                                activeColor: kActiveColor,
                                value: c.isMetric.value,
                                onChanged: (value) async {
                                  c.isMetric.value = value;
                                  c.updateUnits();
                                  await WeatherModel().getCityWeather();
                                },
                              ),
                            ),
                            // SWITCH LABEL
                            Text('C°'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.0),
                  // DATE & TIME
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('${cc.day.value.toUpperCase()}', style: kHeadingTextWhite),
                      Text('${cc.date.value.toUpperCase()}', style: kHeadingTextWhite),
                      Text('${currentTime.getTime()}', style: kHeadingTextWhite),
                    ],
                  ),
                ],
              ),
            ),
            // START SCROLLABLE DATA
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  // CITY / LAST UPDATED / HOME / CITY / FORECAST BUTTONS
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
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
                        // HOME BUTTON / NEW CITY BUTTON / FORECAST BUTTON
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
                                c.prevScreen.value = 'detailScreen';
                                Get.to(CityScreen());
                              },
                            ),
                            // FORECAST BUTTON
                            IconButton(
                              icon: getIconString('forecast'),
                              onPressed: () => Get.to(ForecastScreen()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // DIVIDER
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
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
                  // BLUE BOXES / BUTTONS
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // BLUE BOX - TEMPERATURE
                        Container(
                          width: 110,
                          decoration: BoxDecoration(
                            color: kTopColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF709EFE),
                                Color(0xFF5C47E0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // BLUE BOX / TEMPERATURE
                                getIconString('thermometer'),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Temp'),
                                    Text(
                                      '${cc.temperature.value.toInt()} ${c.temperatureUnits.value}',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // BLUE BOX - WIND
                        Container(
                          width: 110,
                          decoration: BoxDecoration(
                            color: kTopColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF709EFE),
                                Color(0xFF5C47E0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                getIconString('wind'),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Wind'),
                                    Text(
                                      '${cc.windSpeed.value.round()} ${c.speedUnits.value}',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // BLUE BOX - CONDITION
                        Container(
                          width: 110,
                          decoration: BoxDecoration(
                            color: kTopColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF709EFE),
                                Color(0xFF5C47E0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                getIconInt(cc.id.value),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Currently'),
                                    Text(
                                      '${cc.main.value}',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // REVOLT POWER
                  RevoltContainer(),
                  // DIVIDER
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
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
                  // DETAIL CARDS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

                  // RAIN CONTAINER (ONLY IF THERE IS RAIN)
                  Container(
                    child: cc.getRainContainer(),
                  ),
                  // SNOW CONTAINER (ONLY IF THERE IS SNOW)
                  Container(
                    child: cc.getSnowContainer(),
                  ),
                  // TODAY / TOMORROW / NEXT DAY
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // TODAY
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF5F6380),
                                  Color(0xFF383B4F),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text('TODAY'),
                                Text('${cf.daily[0]['temp']['max'].toInt()}${c.temperatureUnits.value}'),
                                Text('status bar'),
                                Text('${cf.daily[0]['temp']['min'].toInt()}${c.temperatureUnits.value}'),
                                getIconInt(cf.daily[0]['weather'][0]['id']),
                                Text('${cf.daily[0]['weather'][0]['main']}'),
                                Row(
                                  children: [
                                    getIconString('raindrop'),
                                    Text('${cf.daily[0]['pop']}%'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    getWindIcon(cf.daily[0]['wind_deg']),
                                    Text('${cf.daily[0]['wind_speed'].toInt()}${c.speedUnits.value}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // TOMORROW
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF5F6380),
                                  Color(0xFF383B4F),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text('TOMORROW'),
                                Text('${cf.daily[1]['temp']['max'].toInt()}${c.temperatureUnits.value}'),
                                Text('status bar'),
                                Text('${cf.daily[1]['temp']['min'].toInt()}${c.temperatureUnits.value}'),
                                getIconInt(cf.daily[1]['weather'][0]['id']),
                                Text('${cf.daily[1]['weather'][0]['main']}'),
                                Row(
                                  children: [
                                    getIconString('raindrop'),
                                    Text('${cf.daily[1]['pop']}%'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    getWindIcon(cf.daily[1]['wind_deg']),
                                    Text('${cf.daily[1]['wind_speed'].toInt()}${c.speedUnits.value}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // THE NEXT DAY
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF5F6380),
                                  Color(0xFF383B4F),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text('${cf.getWeekDay(cf.daily[2]['dt'])}'),
                                Text('${cf.daily[2]['temp']['max'].toInt()}${c.temperatureUnits.value}'),
                                Text('status bar'),
                                Text('${cf.daily[2]['temp']['min'].toInt()}${c.temperatureUnits.value}'),
                                getIconInt(cf.daily[2]['weather'][0]['id']),
                                Text('${cf.daily[2]['weather'][0]['main']}'),
                                Row(
                                  children: [
                                    getIconString('raindrop'),
                                    Text('${cf.daily[2]['pop']}%'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    getWindIcon(cf.daily[2]['wind_deg']),
                                    Text('${cf.daily[2]['wind_speed'].toInt()}${c.speedUnits.value}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // GET EXTENDED FORECAST BUTTON
                  GestureDetector(
                    onTap: () => Get.to(ForecastScreen()),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
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
                          Text('GET EXTENDED FORECAST'),
                          getIconString('forecast'),
                        ],
                      ),
                    ),
                  ),

                  // MAP
                  Container(
                    height: 400.0,
                    margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
                    child: MapComponent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
