import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:revolt_weather_app/components/blue_box.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/components/progress_bar.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_hourly.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class GetHourly extends StatefulWidget {
  @override
  _GetHourlyState createState() => _GetHourlyState();
}

class _GetHourlyState extends State<GetHourly> {
  final ControllerHourly ch = Get.put(ControllerHourly());
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerForecast cf = Get.find();

  final ProgressBar progressBar = ProgressBar();

  // CALL TO INITIALIZE A LIST
  List<Item> _data = generateItems(48);

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TEMPERATURE', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
        Obx(() => progressBar.getSpotlight(type: 'tempHourly')),
        Obx(() => progressBar.getSpotlightTextHourly()),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Text('WIND', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
        Obx(() => progressBar.getSpotlight(type: 'windHourly')),
        Obx(() => progressBar.getSpotlightTextHourly()),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getIconString('revolt', size: 15.0, color: Colors.white),
            Text('  REVOLT POWER', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
          ],
        ),
        Obx(() => progressBar.getSpotlight(type: 'powerHourly')),
        Obx(() => progressBar.getSpotlightTextHourly()),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Text('PRECIPITATION', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
        Obx(() => progressBar.getSpotlight(type: 'precipHourly')),
        Obx(() => progressBar.getSpotlightTextHourly()),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 15.0, top: 8.0),
              child: Text('${cu.initialCity.value.toUpperCase()} TIME', style: kTimePrecipHeadings),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: kBoxShadowUp,
          ),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _data[index].isExpanded = !isExpanded;
              });
            },
            // POPULATE LIST ITEMS WITH DATA
            children: _data.map<ExpansionPanel>((Item item) {
              int dt = cf.hourly[item.index]['dt'];
              String readableHour = cf.getReadableHour(dt);
              String readableWeekday = cf.getWeekDayAbbr(dt);
              String time = '$readableHour $readableWeekday';
              return ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  // UNEXPANDED DATA
                  return ListTile(
                    // DATE / HIGH TEMP / LOW TEMP / ICON ID / ICON RAINDROP / POP
                    title: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // HOUR
                          Text(
                            time,
                            style: TextStyle(fontFamily: 'Oxygen', fontSize: 20.0, color: kLighterBlue, height: 1.5),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // TEMP
                              Text(
                                '${cf.hourly[item.index]['temp'].toInt()}${c.temperatureUnits.value}',
                                style: kOxygenWhite,
                                textAlign: TextAlign.center,
                              ),
                              // WEATHER ICON
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: getIconInt(cf.hourly[item.index]['weather'][0]['id'], size: 20.0, color: Colors.white, dayOrNight: cf.getDayOrNight(dt)),
                              ),
                              // POP
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: getIconString('raindrop', size: 17.0, color: Colors.white),
                                  ),
                                  Text(
                                    ' ${(cf.hourly[item.index]['pop'] * 100).toInt()}%',
                                    style: kOxygenWhite,
                                  ),
                                ],
                              ),
                              // WIND
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  getWindIcon(cf.hourly[item.index]['wind_deg'], size: 16.0, color: Colors.white),
                                  Text(' ${cf.hourly[item.index]['wind_speed'].toInt()}', style: kOxygenWhite),
                                  Text(' ${c.speedUnits.value}', style: TextStyle(fontSize: 12.0, fontFamily: 'Oxygen')),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                // EXPANDED DATA
                body: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DESCRIPTION / FEELS LIKE / WIND / HUMIDITY / UVI
                      gradientDivider(padding: EdgeInsets.only(bottom: 15.0)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            child: getIconInt(cf.hourly[item.index]['weather'][0]['id']),
                          ),
                          Obx(
                            () => Text(
                              '${toBeginningOfSentenceCase(cf.hourly[item.index]['weather'][0]['description'])}  ',
                              style: kDataText,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Get.to(RevoltScreen()),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0, top: 8.0, right: 8.0),
                              child: getIconString('revolt', size: 23.0),
                            ),
                            Obx(() => Text(
                                  'Revolt Power: ${cf.getRevoltPower(item.index, type: 'hourly')} ${cf.watt.value}',
                                  style: kDataText,
                                )),
                          ],
                        ),
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
                                              '${cf.hourly[item.index]['feels_like'].toInt()}${c.temperatureUnits}',
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
                                        cf.hourly[item.index]['wind_deg'],
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
                                              '${getWindDirection(cf.hourly[item.index]['wind_deg'])} ${cf.hourly[item.index]['wind_speed'].toInt()} ${c.speedUnits}',
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
                                              '${cf.hourly[item.index]['humidity']}%',
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
                                              '${cf.hourly[item.index]['clouds']}%',
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
                      ch.getPrecipInfo(item.index),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
                isExpanded: item.isExpanded,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
