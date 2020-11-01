import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:revolt_weather_app/components/blue_box.dart';
import 'package:revolt_weather_app/components/footer.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/components/progress_bar.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_hourly.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:revolt_weather_app/services/sliders.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class GetHourly extends StatelessWidget {
  final ControllerHourly ch = Get.put(ControllerHourly());
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerForecast cf = Get.find();

  final ProgressBar _progressBar = ProgressBar();
  final ScrollController scrollController = ScrollController();

  Future<Column> _getHourlyProgressBars() async {
    return Column(
      children: [
        Text('TEMPERATURE', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
        Obx(() => _progressBar.getSpotlight(type: 'tempHourly')),
        Obx(() => _progressBar.getSpotlightTextHourly()),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Text('WIND', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
        Obx(() => _progressBar.getSpotlight(type: 'windHourly')),
        Obx(() => _progressBar.getSpotlightTextHourly()),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getIconString('revolt', size: 15.0, color: Colors.white),
            Text('  REVOLT POWER', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
          ],
        ),
        Obx(() => _progressBar.getSpotlight(type: 'powerHourly')),
        Obx(() => _progressBar.getSpotlightTextHourly()),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Text('CHANCE OF PRECIPITATION', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
        Obx(() => _progressBar.getSpotlight(type: 'popHourly')),
        _progressBar.getSpotlightTextHourly(),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Text('PRECIPITATION', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
        Obx(() => _progressBar.getSpotlight(type: 'precipHourly')),
        Obx(() => _progressBar.getSpotlightTextHourly()),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Text('HUMIDITY (%)', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
        Obx(() => _progressBar.getSpotlight(type: 'humidityHourly')),
        Obx(() => _progressBar.getSpotlightTextHourly()),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Text('CLOUD COVER (%)', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
        Obx(() => _progressBar.getSpotlight(type: 'cloudsHourly')),
        Obx(() => _progressBar.getSpotlightTextHourly()),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 15.0, top: 8.0),
              child: Text('${cu.initialCity.value.toUpperCase()} TIME', style: kTimePrecipHeadings),
            ),
          ],
        ),
        gradientDivider(padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0)),
      ],
    );
  }

  ExpansionTile _hour(int i) {
    int dt = cf.hourly[i]['dt'];
    String readableHour = cf.getReadableHour(dt);
    String readableWeekday = cf.getWeekDayAbbr(dt);
    String time = '$readableHour $readableWeekday';
    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 20.0),
      childrenPadding: EdgeInsets.symmetric(horizontal: 18.0),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(time, style: kHeadingTextLarge),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TEMP
              Obx(
                () => Text(
                  '${cf.hourly[i]['temp'].toInt()}${c.temperatureUnits.value}',
                  style: kOxygenWhite,
                ),
              ),
              // WEATHER ICON
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Obx(
                  () => getIconInt(
                    cf.hourly[i]['weather'][0]['id'],
                    size: 20.0,
                    color: Colors.white,
                    dayOrNight: cf.getDayOrNight(dt),
                  ),
                ),
              ),
              // POP
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: getIconString('raindrop', size: 17.0, color: Colors.white),
                  ),
                  Obx(
                    () => Text(
                      ' ${(cf.hourly[i]['pop'] * 100).toInt()}%',
                      style: kOxygenWhite,
                    ),
                  ),
                ],
              ),
              // WIND
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    getWindIcon(
                      cf.hourly[i]['wind_deg'],
                      size: 16.0,
                      color: Colors.white,
                    ),
                    Text(
                      ' ${cf.hourly[i]['wind_speed'].toInt()}',
                      style: kOxygenWhite,
                    ),
                    Text(
                      ' ${c.speedUnits.value}',
                      style: TextStyle(fontSize: 12.0, fontFamily: 'Oxygen'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      children: [
        kExpansionContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DESCRIPTION / FEELS LIKE / WIND / HUMIDITY / UVI
              Row(
                children: [
                  Container(
                    width: 45.0,
                    height: 30.0,
                    child: getIconInt(cf.hourly[i]['weather'][0]['id']),
                  ),
                  Obx(
                    () => Text(
                      '${toBeginningOfSentenceCase(cf.hourly[i]['weather'][0]['description'])}  ',
                      style: kDataText,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 45.0,
                    height: 30.0,
                    child: getIconString('raindrop', size: 25.0),
                  ),
                  Text(
                    'Chance of precip: ${(cf.hourly[i]['pop'] * 100).toInt()}%',
                    style: kDataText,
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.5),
                    width: 45.0,
                    height: 30.0,
                    child: getIconString('revolt'),
                  ),
                  Obx(
                    () => Text(
                      'Revolt Power: ${cf.getRevoltPower(i, type: 'hourly')} ${cf.watt.value}',
                      style: kDataText,
                    ),
                  ),
                ],
              ),
              // FEELS LIKE / WIND
              Row(
                children: [
                  // BLUE BOX - FEELS LIKE
                  blueBox(
                    margin: EdgeInsets.fromLTRB(0.0, 20.0, 5.0, 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 1, child: getIconString('thermometer', color: Colors.white)),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(child: Text('FEELS LIKE')),
                              Obx(() => FittedBox(
                                    child: Text(
                                      '${cf.hourly[i]['feels_like'].toInt()}${c.temperatureUnits}',
                                      style: kOxygenWhite,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // BLUE BOX - WIND
                  blueBox(
                    margin: EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // BLUE BOX / WIND
                        Expanded(
                          flex: 1,
                          child: Obx(() => getWindIcon(
                                cf.hourly[i]['wind_deg'],
                                size: 30.0,
                                color: Colors.white,
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(child: Text('WIND')),
                              Obx(() => FittedBox(
                                    child: Text(
                                      '${getWindDirection(cf.hourly[i]['wind_deg'])} ${cf.hourly[i]['wind_speed'].toInt()} ${c.speedUnits}',
                                      style: kOxygenWhite,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // HUMIDITY / CLOUDS
              Row(
                children: [
                  // BLUE BOX - HUMIDITY
                  blueBox(
                    margin: EdgeInsets.fromLTRB(0, 5.0, 5.0, 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 1, child: getIconString('humidity', color: Colors.white)),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(child: Text('HUMIDITY')),
                              Obx(() => FittedBox(
                                    child: Text(
                                      '${cf.hourly[i]['humidity']}%',
                                      style: kOxygenWhite,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // BLUE BOX / CLOUDS
                  blueBox(
                    margin: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 1, child: getIconInt(801, color: Colors.white, size: 27.0)),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(child: Text('CLOUDS')),
                              Obx(() => FittedBox(
                                    child: Text(
                                      '${cf.hourly[i]['clouds']}%',
                                      style: kOxygenWhite,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // POP / RAIN 1HR IF AVAILABLE
              ch.getPrecipInfo(i),
              SizedBox(height: 15.0),
            ],
          ),
        ),
      ],
    );
  }

  ListView _buildScrollView() {
    ListView listView = ListView.builder(
      shrinkWrap: true,
      key: ValueKey<int>(Random(DateTime.now().millisecondsSinceEpoch).nextInt(4294967296)),
      cacheExtent: 0,
      controller: scrollController,
      itemCount: ch.data.length,
      itemBuilder: (BuildContext context, int i) {
        return Column(
          children: [
            _hour(i),
            gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
          ],
        );
      },
    );
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<Column>(
          future: _getHourlyProgressBars(),
          builder: (BuildContext context, AsyncSnapshot<Column> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                children: [
                  loadingSpinner(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: Text('Retrieving Data...', style: TextStyle(fontSize: 20.0)),
                  ),
                ],
              );
            } else {
              if (snapshot.hasError) {
                return Column(children: [Text('Error: ${snapshot.error}')]);
              } else
                return snapshot.data;
            }
          },
        ),
        _buildScrollView(),
        // REVOLT POWER
        GestureDetector(
          onTap: () => Get.to(RevoltScreen()),
          child: Container(
            margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 35.0),
            child: Row(
              children: [
                ImageIcon(AssetImage('images/greenBolt.png'), size: 50.0, color: kSwitchColor),
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
        footer(),
      ],
    );
  }
}
