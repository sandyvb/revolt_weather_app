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
import 'package:revolt_weather_app/utilities/constants.dart';

class GetDaily extends StatefulWidget {
  @override
  _GetDailyState createState() => _GetDailyState();
}

class _GetDailyState extends State<GetDaily> {
  final ControllerDaily cd = Get.put(ControllerDaily());
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();

  ProgressBar progressBar = ProgressBar();

  // CALL TO INITIALIZE A LIST
  List<Item> _data = generateItems(8);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Text('HIGH TEMPERATURES (${c.temperatureUnits.value})', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7))),
        Obx(() => progressBar.getSpotlight(type: 'tempDaily')),
        progressBar.getSpotlightText(),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        Obx(() => Text('MAX WIND (${c.speedUnits.value})', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7))),
        Obx(() => progressBar.getSpotlight(type: 'windDaily')),
        progressBar.getSpotlightText(),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        GestureDetector(
          onTap: () => Get.to(RevoltScreen()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getIconString('revolt', size: 15.0, color: Colors.white),
              Text('  REVOLT POWER (Watts)', style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
            ],
          ),
        ),
        Obx(() => progressBar.getSpotlight(type: 'powerDaily')),
        progressBar.getSpotlightText(),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
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
              return ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  // UNEXPANDED DATA
                  return ListTile(
                    // DATE / HIGH TEMP / LOW TEMP / ICON ID / ICON RAINDROP / POP
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // DATE
                        Text(
                          item.index == 0 ? 'Today' : '${cf.getAbbrDay(cf.daily[item.index]['dt'])}',
                          style: TextStyle(fontFamily: 'Oxygen', fontSize: 20.0, color: kLighterBlue, height: 1.5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // MIN / MAX TEMPS
                            Obx(
                              () => Text(
                                '${cf.daily[item.index]['temp']['max'].toInt()}/${cf.daily[item.index]['temp']['min'].toInt()}${c.temperatureUnits.value}',
                                style: kOxygenWhite,
                              ),
                            ),
                            // WEATHER ICON
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Obx(() => getIconInt(
                                    cf.daily[item.index]['weather'][0]['id'],
                                    size: 20.0,
                                    color: Colors.white,
                                  )),
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
                                    ' ${(cf.daily[item.index]['pop'] * 100).toStringAsFixed(1)}%',
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
                                    item.index == 0 ? cf.currentWindDeg.value : cf.daily[item.index]['wind_deg'],
                                    size: 16.0,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    item.index == 0 ? ' ${cf.currentWindSpeed.value.toInt()}' : ' ${cf.daily[item.index]['wind_speed'].toInt()}',
                                    style: kOxygenWhite,
                                  ),
                                  Text(' ${c.speedUnits.value}', style: TextStyle(fontSize: 12.0, fontFamily: 'Oxygen')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                // EXPANDED DATA
                body: ListTile(
                  title: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // DIVIDER
                        gradientDivider(padding: EdgeInsets.only(bottom: 15.0)),
                        // DAY / DATE / DAY
                        Text('${cf.getDay(cf.daily[item.index]['dt'])}', style: kDataText),
                        // DAY TEMP / WEATHER ICON
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // DAY TEMP
                              Text('${cf.daily[item.index]['temp']['day'].toInt()}${c.temperatureUnits.value}',
                                  style: TextStyle(
                                    fontSize: 64.0,
                                    fontFamily: 'Oxygen',
                                  )),
                              // WEATHER ICON
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: getIconInt(
                                  cf.daily[item.index]['weather'][0]['id'],
                                  size: 50.0,
                                  dayOrNight: 'day',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // FEELS LIKE
                        Text(
                          'Feels like ${cf.daily[item.index]['feels_like']['day'].toInt()}${c.temperatureUnits}.',
                          style: kDataText,
                        ),
                        // DESCRIPTION / HIGH TEMP
                        Row(
                          children: [
                            Text(
                              '${toBeginningOfSentenceCase(cf.daily[item.index]['weather'][0]['description'])}. ',
                              style: kDataText,
                            ),
                            Text(
                              ' High near ${cf.daily[item.index]['temp']['max'].toInt()}${c.temperatureUnits.value}.',
                              style: kDataText,
                            ),
                          ],
                        ),
                        // CHANCE OF PRECIPITATION
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: getIconString('raindrop'),
                            ),
                            Text(
                              ' Chance of ${cd.rainOrSnow(item.index, 'day')}: ${(cf.daily[item.index]['pop'] * 100).toStringAsFixed(1)}%',
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
                              child: getWindIcon(cf.daily[item.index]['wind_deg'], size: 22.0),
                            ),
                            Text(
                              item.index == 0
                                  ? '  Winds ${getWindDirection(cf.currentWindDeg.value)} ${cf.currentWindSpeed.value.toInt()} ${c.speedUnits.value}${cf.gustingWind()}'
                                  : '  Winds ${getWindDirection(cf.daily[item.index]['wind_deg'])} ${cf.daily[item.index]['wind_speed'].toInt()}${cd.getGust(item.index)} ${c.speedUnits.value}',
                              style: TextStyle(
                                fontFamily: 'Oxygen',
                                letterSpacing: 0.7,
                                color: kLighterBlue,
                                height: 2,
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
                              item.index == 0 ? '  REVOLT power ${cf.power.value.ceil()} ${cf.watt.value}' : '  REVOLT power: ${cf.getRevoltPower(item.index, type: 'daily')} ${cf.watt.value}',
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
                                  Expanded(flex: 1, child: getIconString('humidity', color: Colors.white)),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(child: Text('HUMIDITY')),
                                        FittedBox(
                                          child: Text(
                                            '${cf.daily[item.index]['humidity']}%',
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
                                          child: Text(
                                            '${cf.returnUviIndex(cf.daily[item.index]['uvi'])}',
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
                                            '${cf.getReadableTime(cf.daily[item.index]['sunrise'])}',
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
                                            '${cf.getReadableTime(cf.daily[item.index]['sunset'])}',
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
                        Text('${cf.getNight(cf.daily[item.index]['dt'])}', style: kDataText),
                        // NIGHT TEMP / WEATHER ICON
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // NIGHT TEMP
                              Text('${cf.daily[item.index]['temp']['night'].toInt()}${c.temperatureUnits.value}',
                                  style: TextStyle(
                                    fontSize: 64.0,
                                    fontFamily: 'Oxygen',
                                  )),
                              // WEATHER ICON
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: getIconInt(
                                  cf.daily[item.index]['weather'][0]['id'],
                                  size: 50.0,
                                  dayOrNight: 'night',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // FEELS LIKE
                        Text(
                          'Feels like ${cf.daily[item.index]['feels_like']['night'].toInt()}${c.temperatureUnits}.',
                          style: kDataText,
                        ),
                        // DESCRIPTION / LOW TEMP
                        Row(
                          children: [
                            Text(
                              '${toBeginningOfSentenceCase(cf.daily[item.index]['weather'][0]['description'])}. ',
                              style: kDataText,
                            ),
                            Text(
                              ' Low near ${cf.daily[item.index]['temp']['min'].toInt()}${c.temperatureUnits.value}.',
                              style: kDataText,
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                      ],
                    ),
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
