import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/blue_box.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/components/progress_bar.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_daily.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:intl/intl.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:revolt_weather_app/services/sliders.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'footer.dart';

class GetDaily extends StatelessWidget {
  final ControllerDaily cd = Get.put(ControllerDaily());
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();

  final ProgressBar _progressBar = ProgressBar();
  final ScrollController _scrollController = ScrollController();

  Future<Column> _getDailyProgressBars() async {
    return Column(
      children: [
        Obx(() => Text('HIGH TEMPERATURES (${c.temperatureUnits.value})', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7))),
        Obx(() => _progressBar.getSpotlight(type: 'tempDaily')),
        _progressBar.getSpotlightText(),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Obx(() => Text('MAX WIND (${c.speedUnits.value})', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7))),
        Obx(() => _progressBar.getSpotlight(type: 'windDaily')),
        _progressBar.getSpotlightText(),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getIconString('revolt', size: 15.0, color: Colors.white),
            Text('  REVOLT POWER (Watts)', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
          ],
        ),
        Obx(() => _progressBar.getSpotlight(type: 'powerDaily')),
        _progressBar.getSpotlightText(),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
      ],
    );
  }

  ExpansionTile _day(int i) {
    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 20.0),
      childrenPadding: EdgeInsets.symmetric(horizontal: 18.0),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(i == 0 ? 'Today' : cf.getAbbrDay(cf.daily[i]['dt']), style: kHeadingTextLarge),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // MIN / MAX TEMPS
              Obx(
                () => Text(
                  '${cf.daily[i]['temp']['max'].toInt()}/${cf.daily[i]['temp']['min'].toInt()}${c.temperatureUnits.value}',
                  style: kOxygenWhite,
                ),
              ),
              // WEATHER ICON
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: getIconInt(
                  cf.daily[i]['weather'][0]['id'],
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
              // POP
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: getIconString('raindrop', size: 17.0, color: Colors.white),
                  ),
                  Text(
                    ' ${(cf.daily[i]['pop'] * 100).toInt()}%',
                    style: kOxygenWhite,
                  ),
                ],
              ),
              // WIND
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    getWindIcon(
                      i == 0 ? cf.currentWindDeg.value : cf.daily[i]['wind_deg'],
                      size: 16.0,
                      color: Colors.white,
                    ),
                    Text(
                      i == 0 ? ' ${cf.currentWindSpeed.value.toInt()}' : ' ${cf.daily[i]['wind_speed'].toInt()}',
                      style: kOxygenWhite,
                    ),
                    Text(
                      ' ${c.speedUnits.value}',
                      style: TextStyle(fontSize: 12.0, fontFamily: 'Oxygen', color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // EXPANDED DATA
      children: [
        kExpansionContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DAY / DATE / DAY
              Text(cf.getDay(cf.daily[i]['dt']), style: kDataText),
              // DAY TEMP / WEATHER ICON
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // DAY TEMP
                    Obx(
                      () => Text(
                        '${cf.daily[i]['temp']['day'].toInt()}${c.temperatureUnits.value}',
                        style: TextStyle(
                          fontSize: 64.0,
                          fontFamily: 'Oxygen',
                        ),
                      ),
                    ),
                    // WEATHER ICON
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: getIconInt(
                        cf.daily[i]['weather'][0]['id'],
                        size: 50.0,
                        dayOrNight: 'day',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // FEELS LIKE
              Obx(
                () => Text(
                  'Feels like ${cf.daily[i]['feels_like']['day'].toInt()}${c.temperatureUnits}.',
                  style: kDataText,
                ),
              ),
              // DESCRIPTION / HIGH TEMP
              Row(
                children: [
                  Text(
                    '${toBeginningOfSentenceCase(cf.daily[i]['weather'][0]['description'])}. ',
                    style: kDataText,
                  ),
                  Obx(
                    () => Text(
                      ' High near ${cf.daily[i]['temp']['max'].toInt()}${c.temperatureUnits.value}.',
                      style: kDataText,
                    ),
                  ),
                ],
              ),
              // CHANCE OF PRECIPITATION
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: getIconString('raindrop', size: 25.0),
                  ),
                  Text(
                    ' Chance of ${cd.rainOrSnow(i, 'day')}: ${(cf.daily[i]['pop'] * 100).toInt()}%',
                    style: TextStyle(
                      fontFamily: 'Oxygen',
                      letterSpacing: 0.7,
                      color: kLighterBlue,
                      height: 2,
                    ),
                  ),
                ],
              ),
              // WIND
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: getWindIcon(cf.daily[i]['wind_deg'], size: 22.0),
                  ),
                  Obx(
                    () => Text(
                      i == 0
                          ? '  Winds ${getWindDirection(cf.currentWindDeg.value)} ${cf.currentWindSpeed.value.toInt()} ${c.speedUnits.value}${cf.gustingWind()}'
                          : '  Winds ${getWindDirection(cf.daily[i]['wind_deg'])} ${cf.daily[i]['wind_speed'].toInt()}${cd.getGust(i)} ${c.speedUnits.value}',
                      style: TextStyle(
                        fontFamily: 'Oxygen',
                        letterSpacing: 0.7,
                        color: kLighterBlue,
                        height: 2,
                      ),
                    ),
                  ),
                ],
              ),
              // REVOLT POWER
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: getIconString('revolt', size: 22.0),
                  ),
                  Text(
                    i == 0 ? '  REVOLT power ${cf.power.value.ceil()} ${cf.watt.value}' : '  REVOLT power: ${cf.getRevoltPower(i, type: 'daily')} ${cf.watt.value}',
                    style: TextStyle(
                      fontFamily: 'Oxygen',
                      letterSpacing: 0.7,
                      color: kLighterBlue,
                      height: 2,
                    ),
                  ),
                ],
              ),
              // HUMIDITY / UVI
              gradientDivider(padding: EdgeInsets.symmetric(vertical: 15.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // BLUE BOX - HUMIDITY
                  blueBox(
                    margin: EdgeInsets.fromLTRB(0, 0, 5.0, 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BLUE BOX / HUMIDITY
                        Expanded(
                          flex: 1,
                          child: getIconString('humidity', color: Colors.white),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(child: Text('HUMIDITY')),
                              FittedBox(
                                child: Text(
                                  '${cf.daily[i]['humidity']}%',
                                  style: kOxygenWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // BLUE BOX - UVI
                  blueBox(
                    margin: EdgeInsets.fromLTRB(5.0, 0, 0, 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BLUE BOX / UVI
                        Expanded(flex: 1, child: getIconInt(800, color: Colors.white)),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(child: Text('UV INDEX')),
                              FittedBox(
                                child: Obx(() => cf.returnUviIndex(cf.daily[i]['uvi'])),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // SUNRISE / SUNSET
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // BLUE BOX - SUNRISE
                  blueBox(
                    margin: EdgeInsets.fromLTRB(0, 5.0, 5.0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BLUE BOX / SUNRISE
                        Expanded(flex: 1, child: getIconString('sunrise', color: Colors.white)),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(child: Text('SUNRISE')),
                              FittedBox(
                                child: Text(
                                  cf.getReadableTime(cf.daily[i]['sunrise']),
                                  style: kOxygenWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // BLUE BOX - SUNSET
                  blueBox(
                    margin: EdgeInsets.fromLTRB(5.0, 5.0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BLUE BOX / SUNSET
                        Expanded(flex: 1, child: getIconString('sunset', color: Colors.white)),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(child: Text('SUNSET')),
                              FittedBox(
                                child: Text(
                                  cf.getReadableTime(cf.daily[i]['sunset']),
                                  style: kOxygenWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // NIGHT / DATE /DAY \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
              // DIVIDER
              gradientDivider(padding: EdgeInsets.symmetric(vertical: 15.0)),
              Text(cf.getAbbrNight(cf.daily[i]['dt']), style: kDataText),
              // NIGHT TEMP / WEATHER ICON
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // NIGHT TEMP
                    Obx(
                      () => Text(
                        '${cf.daily[i]['temp']['night'].toInt()}${c.temperatureUnits.value}',
                        style: TextStyle(
                          fontSize: 64.0,
                          fontFamily: 'Oxygen',
                        ),
                      ),
                    ),
                    // WEATHER ICON
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: getIconInt(
                        cf.daily[i]['weather'][0]['id'],
                        size: 50.0,
                        dayOrNight: 'night',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // FEELS LIKE
              Obx(
                () => Text(
                  'Feels like ${cf.daily[i]['feels_like']['night'].toInt()}${c.temperatureUnits}.',
                  style: kDataText,
                ),
              ),
              // DESCRIPTION / LOW TEMP
              Row(
                children: [
                  Text(
                    '${toBeginningOfSentenceCase(cf.daily[i]['weather'][0]['description'])}. ',
                    style: kDataText,
                  ),
                  Obx(
                    () => Text(
                      ' Low near ${cf.daily[i]['temp']['min'].toInt()}${c.temperatureUnits.value}.',
                      style: kDataText,
                    ),
                  ),
                ],
              ),
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
      controller: _scrollController,
      itemCount: 8,
      itemBuilder: (BuildContext context, int i) {
        return Column(
          children: [
            _day(i),
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
          future: _getDailyProgressBars(),
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
                return Text('Error: ${snapshot.error}');
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
