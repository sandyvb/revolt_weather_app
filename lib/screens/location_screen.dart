import 'dart:async'; // FOR TIMER
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/city_screen.dart';
import 'package:revolt_weather_app/screens/glance_screen.dart';
import 'package:revolt_weather_app/screens/forecast_screen.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:revolt_weather_app/services/current_time.dart';
import 'package:revolt_weather_app/services/spinner.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:revolt_weather_app/components/get_icon.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final Controller c = Get.find();
  final ControllerUpdate cc = Get.find();

  // TODO: GET WORLD TIME - https://www.bigdatacloud.com/time-zone-apis/timezone-by-location-api
  // KEEP TIME CURRENT \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
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

  // GET LOCATION WEATHER (COORDINATES) THEN UPDATE weatherData \\\\\\\\\\\\\\\\\\
  void refresh() async {
    await WeatherModel().getLocationWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      // INCL BACKGROUND GRADIENT
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
        // MAIN BODY
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // HEADER
            Container(
              padding: EdgeInsets.only(top: 35.0),
              decoration: BoxDecoration(
                color: Color(0xFF3B3C4E),
                boxShadow: [
                  BoxShadow(
                    color: kBlack.withOpacity(0.08),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              // REFRESH / GREETING / UNITS / DATE / TIME / DIVIDER
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // REFRESH / GREETING / UNITS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // REFRESH
                      FlatButton(
                        onPressed: () {
                          refresh();
                        },
                        child: getIconString('refresh'),
                      ),
                      // GREETING
                      Obx(() => Text('${cc.greeting.value}', style: kGreetingText)),
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
                                  await WeatherModel().getCityWeather();
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
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('${cc.day.value.toUpperCase()}', style: kHeadingText),
                        Text('${cc.date.value.toUpperCase()}', style: kHeadingText),
                        Text('${currentTime.getTime()}', style: kHeadingText),
                      ],
                    ),
                  ),
                  // DIVIDER
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 13, 15, 7),
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
                ],
              ),
            ),
            // MAIN DATA CONTAINER
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4D5268).withOpacity(0.5),
                    Color(0xFF34394D),
                    Color(0xFF272A3B).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.clamp,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kBlack.withOpacity(0.08),
                    spreadRadius: 15,
                    blurRadius: 17,
                    offset: Offset(5, 10), // changes position of shadow
                  ),
                ],
              ),
              // CIRCULAR SLIDER ENTIRE SECTION INCL HEADER
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Column(
                  children: [
                    // CITY / LAST UPDATED / CITY BUTTON / FORECAST BUTTON / DETAIL BUTTON
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
                                child: Obx(
                                  () => Text(
                                    '${cc.city.value.toUpperCase()}${cc.country.value}',
                                    style: kHeadingTextLarge,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // LAST UPDATED
                              Obx(() => Text('last updated: ${cc.lastUpdate.value}', style: kSubHeadingText)),
                            ],
                          ),
                          // FORECAST BUTTON / DETAILS BUTTON
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // CITY BUTTON
                              IconButton(
                                  icon: getIconString('city'),
                                  onPressed: () {
                                    c.prevScreen.value = 'locationScreen';
                                    Get.to(CityScreen());
                                  }),
                              // FORECAST BUTTON
                              IconButton(
                                icon: getIconString('forecast'),
                                onPressed: () => Get.to(ForecastScreen()),
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
                    // BEGIN SLIDERS
                    Padding(
                      padding: const EdgeInsets.only(left: 44.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SLIDERS LEFT COLUMN / TEMP /CONDITIONS / WIND
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TEMPERATURE SLIDER
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: Obx(
                                  () => SleekCircularSlider(
                                    min: -10.0,
                                    max: c.isMetric.value ? 65.5556 : 150.0,
                                    initialValue: cc.temperature.value,
                                    appearance: CircularSliderAppearance(
                                      size: 190.0,
                                      startAngle: 0.0,
                                      angleRange: 360.0,
                                      customColors: CustomSliderColors(
                                        trackColor: kHr,
                                        progressBarColors: [kHr, Color(0xFF1F7AFC)],
                                        dotColor: Color(0x00000000),
                                        shadowColor: kBlack,
                                        shadowMaxOpacity: 0.018,
                                      ),
                                      customWidths: CustomSliderWidths(
                                        trackWidth: 4.5,
                                        progressBarWidth: 4.5,
                                        shadowWidth: 95.0,
                                      ),
                                      infoProperties: InfoProperties(
                                        modifier: temperatureTextModifier,
                                        mainLabelStyle: kMainData,
                                        bottomLabelText: 'TEMPERATURE',
                                        bottomLabelStyle: kBottomLabelStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // CONDITION & WIND
                              Row(
                                children: [
                                  // CONDITION SLIDER
                                  Obx(
                                    () => Column(
                                      children: [
                                        Stack(
                                          children: [
                                            // CONDITION SLIDER
                                            smallSleekCircularSlider(
                                              max: 900.0,
                                              initialValue: cc.id.value.toDouble(),
                                              modifier: nullTextModifier,
                                              colors: [kHr, Color(0xFF9074FD), Color(0xFF3F30EB)],
                                              size: 70.0,
                                              mainLabelStyle: kData,
                                            ),
                                            // CONDITION ICON
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(22.0, 18.0, 0, 0),
                                              child: getIconInt(cc.id.value),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Text('${cc.main.value.toUpperCase()}', style: kSpinnerLabels),
                                      ],
                                    ),
                                  ),

                                  // WIND SLIDER
                                  Obx(
                                    () => Padding(
                                      padding: const EdgeInsets.only(left: 45.0),
                                      child: Column(
                                        children: [
                                          // WIND SLIDER
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: smallSleekCircularSlider(
                                              max: c.isMetric.value ? 65.5556 : 150.0,
                                              initialValue: cc.windSpeed.value.toDouble(),
                                              modifier: windTextModifier,
                                              colors: [kHr, Color(0xFF4E61EC), Color(0xFF69E1EF)],
                                              bottomLabelText: '${c.speedUnits}',
                                              size: 70.0,
                                              mainLabelStyle: kData,
                                            ),
                                          ),
                                          Text('WIND', style: kSpinnerLabels),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // RIGHT COLUMN / HUMIDITY / POWER
                          Obx(
                            () => Padding(
                              padding: EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 0.0),
                              child: Column(
                                children: [
                                  // HUMIDITY SLIDER
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: smallSleekCircularSlider(
                                      max: 100.0,
                                      initialValue: cc.humidity.value.toDouble(),
                                      modifier: percentTextModifier,
                                      colors: [kHr, Color(0xFFF1AA3B), Color(0xFFD36321)],
                                      size: 70.0,
                                      mainLabelStyle: kData,
                                    ),
                                  ),
                                  Text('HUMIDITY', style: kSpinnerLabels),
                                  //REVOLT WIND POWER
                                  Padding(
                                    padding: const EdgeInsets.only(top: 27.0),
                                    // ON TAP GOES TO REVOLT SCREEN
                                    child: GestureDetector(
                                      onTap: () => Get.to(RevoltScreen()),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: smallSleekCircularSlider(
                                              max: 200.5,
                                              initialValue: cc.power.value,
                                              modifier: revoltTextModifier,
                                              colors: [kHr, Color(0xFF83D475), Color(0xFF2EB62C)],
                                              bottomLabelText: getWatt(),
                                              size: 70.0,
                                              mainLabelStyle: kData,
                                            ),
                                          ),
                                          Text('REVOLT', style: kSpinnerLabels),
                                          Text('POWER', style: kSpinnerLabels),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // FOOTER
            Container(
              decoration: BoxDecoration(
                color: kTopColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF709EFE).withOpacity(0.5),
                    Color(0xFF5C47E0).withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.clamp,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kBlack.withOpacity(0.08),
                    spreadRadius: 15,
                    blurRadius: 17,
                    offset: Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // BOTTOM NAVIGATOR
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // NEW CITY
                        Column(
                          children: [
                            IconButton(
                              icon: getIconString('city'),
                              onPressed: () {
                                c.prevScreen.value = 'locationScreen';
                                Get.to(CityScreen());
                              },
                            ),
                            Text(
                              'NEW CITY',
                              style: kBottomIconText,
                            ),
                          ],
                        ),
                        // FORECAST
                        Column(
                          children: [
                            IconButton(
                              icon: getIconString('forecast'),
                              onPressed: () => Get.to(ForecastScreen()),
                            ),
                            Text(
                              'FORECAST',
                              style: kBottomIconText,
                            ),
                          ],
                        ),
                        // DETAILS
                        Column(
                          children: [
                            IconButton(
                              icon: getIconString('details'),
                              onPressed: () => Get.to(GlanceScreen()),
                            ),
                            Text(
                              'GLANCE',
                              style: kBottomIconText,
                            ),
                          ],
                        ),
                        // REFRESH
                        Column(
                          children: [
                            IconButton(
                              icon: getIconString('refreshBottom'),
                              onPressed: () => refresh(),
                            ),
                            Text(
                              'REFRESH',
                              style: kBottomIconText,
                            ),
                          ],
                        ),
                        // REVOLT
                        SizedBox(
                          width: 55,
                          child: Column(
                            children: [
                              FlatButton(
                                child: ImageIcon(
                                  AssetImage('images/greenBolt.png'),
                                  color: kLighterBlue,
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return RevoltScreen();
                                      },
                                    ),
                                  );
                                },
                              ),
                              Text(
                                'REVOLT',
                                style: kBottomIconText,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: kHr,
                    height: 20.0,
                    thickness: 2.0,
                    indent: 130.0,
                    endIndent: 130.0,
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
