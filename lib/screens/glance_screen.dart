import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/blue_box.dart';
import 'package:revolt_weather_app/components/footer.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/components/glance_box.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/components/map_component.dart';
import 'package:revolt_weather_app/components/mini_nav.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_glance.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class GlanceScreen extends StatelessWidget {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerForecast cf = Get.find();
  final ControllerGlance cg = Get.put(ControllerGlance());

  @override
  Widget build(BuildContext context) {
    // SCAFFOLD IN CONTROLLER GLANCE
    return Scaffold(
      floatingActionButton: Obx(() => cf.isWeatherEvent(EdgeInsets.only(top: 65.0))),
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
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text(
                            'At a Glance',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 22.0,
                              letterSpacing: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
                                    await c.updateUnits();
                                    await WeatherModel().getForecast();
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
                  ],
                )),
            // START SCROLLABLE DATA
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  miniNav(),
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
                            Container(
                              height: 40.0,
                              child: getIconString('thermometer', color: Colors.white),
                            ),
                            Obx(
                              () => FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${cf.currentTemp.value.toInt()}${c.temperatureUnits.value}',
                                  style: kOxygenWhite,
                                ),
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
                              Container(
                                height: 40.0,
                                padding: const EdgeInsets.only(right: 5.0),
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
                              Container(
                                height: 40.0,
                                padding: const EdgeInsets.only(right: 8.0),
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
                  cg.getRainContainer(),
                  // SNOW CONTAINER (ONLY IF THERE IS SNOW)
                  cg.getSnowContainer(),
                  // REVOLT POWER
                  GestureDetector(
                    onTap: () => Get.to(RevoltScreen()),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                      child: Row(
                        children: [
                          ImageIcon(AssetImage('images/greenBolt.webp'), size: 50.0, color: kSwitchColor),
                          SizedBox(width: 20.0),
                          Flexible(
                            child: Obx(() => Text(
                                  '${cf.revoltText.value} Tap here for more information!',
                                  maxLines: 5,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // DIVIDER
                  gradientDivider(padding: EdgeInsets.fromLTRB(25.0, 0, 20.0, 10.0)),
                  // TODAY / TOMORROW / NEXT DAY
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       // TODAY
                  //       Obx(
                  //         () => glanceBox(
                  //           day: 'TODAY',
                  //           highTemp: cf.daily[0]['temp']['max'],
                  //           lowTemp: cf.daily[0]['temp']['min'],
                  //           iconId: cf.currentWeatherId.value,
                  //           main: cf.currentWeatherMain.value,
                  //           pop: (cf.daily[0]['pop'] * 100).toInt(),
                  //           windAngle: cf.currentWindDeg.value,
                  //           windSpeed: cf.currentWindSpeed.value.round(),
                  //         ),
                  //       ),
                  //       // TOMORROW
                  //       Obx(
                  //         () => glanceBox(
                  //           day: '${cf.getWeekDay(cf.daily[1]['dt'])}',
                  //           highTemp: cf.daily[1]['temp']['max'],
                  //           lowTemp: cf.daily[1]['temp']['min'],
                  //           iconId: cf.daily[1]['weather'][0]['id'],
                  //           main: cf.daily[1]['weather'][0]['main'],
                  //           pop: (cf.daily[1]['pop'] * 100).toInt(),
                  //           windAngle: cf.daily[1]['wind_deg'],
                  //           windSpeed: cf.daily[1]['wind_speed'],
                  //         ),
                  //       ),
                  //       // THE NEXT DAY
                  //       Obx(
                  //         () => glanceBox(
                  //           day: '${cf.getWeekDay(cf.daily[2]['dt'])}',
                  //           highTemp: cf.daily[2]['temp']['max'],
                  //           lowTemp: cf.daily[2]['temp']['min'],
                  //           iconId: cf.daily[2]['weather'][0]['id'],
                  //           main: cf.daily[2]['weather'][0]['main'],
                  //           pop: (cf.daily[2]['pop'] * 100).toInt(),
                  //           windAngle: cf.daily[2]['wind_deg'],
                  //           windSpeed: cf.daily[2]['wind_speed'],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // MAP
                  Container(
                    height: 400.0,
                    margin: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 35.0),
                    child: MapComponent(),
                  ),
                  footer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
