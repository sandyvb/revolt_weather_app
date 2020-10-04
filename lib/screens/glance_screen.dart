import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/blue_box.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/components/glance_box.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/components/map_component.dart';
import 'package:revolt_weather_app/components/revolt_container.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_glance.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/city_screen.dart';
import 'package:revolt_weather_app/screens/forecast_screen.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'package:revolt_weather_app/screens/location_screen.dart';

class GlanceScreen extends StatelessWidget {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerForecast cf = Get.find();
  final ControllerGlance cg = Get.put(ControllerGlance());

  // TODO: add email, messaging, phone calls from - https://pub.dev/packages/url_launcher

  @override
  Widget build(BuildContext context) {
    // SCAFFOLD IN CONTROLLER GLANCE
    return Scaffold(
      floatingActionButton: Obx(() => cf.isWeatherEvent(EdgeInsets.only(top: 92.0))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: kGradientBackgroundDecoration,
        // BODY
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // HEADER BACKGROUND GRADIENT IN CONTROLLER GLANCE
            Container(
                padding: EdgeInsets.fromLTRB(0, 35.0, 0, 17.0),
                decoration: BoxDecoration(
                  boxShadow: kBoxShadowDown,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                  gradient: kBlueGradientDiagonal,
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
                          onPressed: () => Get.back(),
                          child: getIconString('back', color: Colors.white),
                        ),
                        // PAGE TITLE
                        Text('At a Glance',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 25.0,
                              letterSpacing: 1,
                              color: Colors.white,
                            )),
                        // SWITCH UNITS
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // OBX SWITCH
                              Obx(
                                () => Switch(
                                  inactiveThumbColor: Colors.white,
                                  activeColor: kSwitchColor,
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
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('${cf.day.value.toUpperCase()}', style: kHeadingTextWhite),
                          Text('${cf.date.value.toUpperCase()}', style: kHeadingTextWhite),
                          Text('${c.theTime.value}', style: kHeadingTextWhite),
                        ],
                      ),
                    ),
                  ],
                )),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // CITY / LAST UPDATED
                        Expanded(
                          flex: 9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // CITY
                              Obx(
                                () => Text(
                                  '${cu.city.value.toUpperCase()}${cu.country.value}',
                                  style: kHeadingTextLarge,
                                  maxLines: 3,
                                ),
                              ),
                              // LAST UPDATED
                              FittedBox(
                                fit: BoxFit.cover,
                                child: Obx(
                                  () => Text(
                                    'last update: ${cf.lastUpdate.value}',
                                    style: kSubHeadingText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // HOME BUTTON
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: getIconString('home', size: 25.0),
                            onPressed: () => Get.to(LocationScreen()),
                          ),
                        ),
                        // CITY BUTTON
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: getIconString('city'),
                            onPressed: () {
                              c.prevScreen.value = 'glance';
                              Get.to(CityScreen());
                            },
                          ),
                        ),
                        // FORECAST BUTTON
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: getIconString('forecast'),
                            onPressed: () => Get.to(ForecastScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // DIVIDER
                  gradientDivider(padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0)),
                  // BLUE BOXES / BUTTONS
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                    child: Row(
                      children: [
                        // BLUE BOX - TEMPERATURE
                        smBlueBox(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: getIconString('thermometer', color: Colors.white),
                            ),
                            Obx(
                              () => Text(
                                '${cf.currentTemp.value.toInt()}${c.temperatureUnits.value}',
                                style: kOxygenWhite,
                              ),
                            ),
                          ],
                        )),
                        // BLUE BOX - WIND
                        smBlueBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
                                child: getWindIcon(cf.currentWindDeg.value, color: Colors.white),
                              ),
                              Obx(
                                () => FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${cf.currentWindSpeed.value.round()} ${c.speedUnits.value}',
                                    style: kOxygenWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // BLUE BOX - CONDITION
                        smBlueBox(
                            child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 9.0, right: 8.0),
                                child: getIconInt(cf.currentWeatherId.value, color: Colors.white),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${cf.currentWeatherMain.value}',
                                  style: kOxygenWhite,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  // RAIN CONTAINER (ONLY IF THERE IS RAIN)
                  Obx(() => cg.getRainContainer()),
                  // SNOW CONTAINER (ONLY IF THERE IS SNOW)
                  Obx(() => cg.getSnowContainer()),
                  // REVOLT POWER
                  RevoltContainer(),
                  // DIVIDER
                  gradientDivider(padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0)),
                  // TODAY / TOMORROW / NEXT DAY
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // TODAY
                        Obx(
                          () => glanceBox(
                            day: 'TODAY',
                            highTemp: cf.daily[0]['temp']['max'],
                            lowTemp: cf.daily[0]['temp']['min'],
                            iconId: cf.currentWeatherId.value,
                            main: cf.currentWeatherMain.value,
                            pop: cf.daily[0]['pop'].toStringAsFixed(1),
                            windAngle: cf.currentWindDeg.value,
                            windSpeed: cf.currentWindSpeed.value.round(),
                          ),
                        ),
                        // TOMORROW
                        Obx(
                          () => glanceBox(
                            day: 'TOMORROW',
                            highTemp: cf.daily[1]['temp']['max'],
                            lowTemp: cf.daily[1]['temp']['min'],
                            iconId: cf.daily[1]['weather'][0]['id'],
                            main: cf.daily[1]['weather'][0]['main'],
                            pop: cf.daily[1]['pop'].toStringAsFixed(1),
                            windAngle: cf.daily[1]['wind_deg'],
                            windSpeed: cf.daily[1]['wind_speed'],
                          ),
                        ),
                        // THE NEXT DAY
                        Obx(
                          () => glanceBox(
                            day: '${cf.getWeekDay(cf.daily[2]['dt'])}',
                            highTemp: cf.daily[2]['temp']['max'],
                            lowTemp: cf.daily[2]['temp']['min'],
                            iconId: cf.daily[2]['weather'][0]['id'],
                            main: cf.daily[2]['weather'][0]['main'],
                            pop: cf.daily[2]['pop'].toStringAsFixed(1),
                            windAngle: cf.daily[2]['wind_deg'],
                            windSpeed: cf.daily[2]['wind_speed'],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // MAP
                  Container(
                    height: 400.0,
                    margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
                    child: MapComponent(),
                  ),
                  // GET EXTENDED FORECAST BUTTON
                  GestureDetector(
                    onTap: () => Get.to(ForecastScreen()),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        boxShadow: kBoxShadowDD,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                        gradient: kBlueGradientHorizontal,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('GET EXTENDED FORECAST'),
                          getIconString('forecast', color: Colors.white),
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
    );
  }
}
