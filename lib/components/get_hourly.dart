import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class GetHourly extends StatefulWidget {
  @override
  _GetHourlyState createState() => _GetHourlyState();
}

// STORES EXPANSION PANEL STATE INFORMATION
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
    this.index,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
  int index;
}

// GENERATE LIST FOR EXPANSION PANEL
List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
      index: index,
    );
  });
}

class _GetHourlyState extends State<GetHourly> {
  final Controller c = Get.find();
  final ControllerUpdate cc = Get.find();
  final ControllerForecast cf = Get.find();

  // CALL TO INITIALIZE A LIST
  List<Item> _data = generateItems(48);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DISPLAY TODAY'S DATE AND LAST UPDATED
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(cf.getDayForHourly(cf.hourly[0]['dt'])),
              Text('Last updated: ${cf.getReadableTime(cf.hourly[0]['dt'])}'),
            ],
          ),
        ),
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _data[index].isExpanded = !isExpanded;
            });
          },
          // POPULATE LIST ITEMS WITH DATA
          children: _data.map<ExpansionPanel>((Item item) {
            // DECLARE VARIABLES
            var hour = cf.getReadableHour(cf.hourly[item.index]['dt']);
            var temp = cf.hourly[item.index]['temp'].toInt();
            Icon weatherIcon = getIconInt(cf.hourly[item.index]['weather'][0]['id'], 20.0);
            Icon raindropIcon = getIconString('raindrop', 17.0);
            var pop = cf.hourly[item.index]['pop'];
            String description = toBeginningOfSentenceCase(cf.hourly[item.index]['weather'][0]['description']);
            var angle = cf.hourly[item.index]['wind_deg'];
            String windDirection = cc.getWindDirection(angle);
            var windSpeed = cf.hourly[item.index]['wind_speed'].toInt();
            var feelsLike = cf.hourly[item.index]['feels_like'].toInt();
            var humidity = cf.hourly[item.index]['humidity'];
            var clouds = cf.hourly[item.index]['clouds'];
            var precip;
            var typeOfPrecip = 'PRECIPITATION';
            try {
              precip = cf.hourly[item.index]['rain']['1h'];
              typeOfPrecip = 'RAIN';
            } catch (e) {
              precip = 0;
            }
            try {
              precip = cf.hourly[item.index]['snow']['1h'];
              typeOfPrecip = 'SNOW';
            } catch (e) {
              precip = 0;
            }

            // RETURN ROW IF THERE IS PRECIPITATION
            Row getPrecipInfo() {
              if (precip != 0 && pop != 0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // BLUE BOX - POP
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 5.0, 5.0, 20.0),
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // BLUE BOX / POP
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: getIconString('raindrops'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CHANCE'),
                                Text('$pop%'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // BLUE BOX - PRECIPITATION
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 20.0),
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // BLUE BOX / PRECIPITATION
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: getIconString('raindrop'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$typeOfPrecip'),
                                Text('$precip mm / hr'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Row();
            }

            return ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                // UNEXPANDED DATA
                return ListTile(
                  // DATE / HIGH TEMP / LOW TEMP / ICON ID / ICON RAINDROP / POP
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$hour'),
                      Text('$temp${c.temperatureUnits.value}'),
                      weatherIcon,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          raindropIcon,
                          Text(' ${pop.toInt()}%'),
                        ],
                      ),
                    ],
                  ),
                );
              },
              // EXPANDED DATA
              body: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DESCRIPTION / FEELS LIKE / WIND / HUMIDITY / UVI \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                    // DIVIDER
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
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
                    Text('$description'),
                    // FEELS LIKE / WIND
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // BLUE BOX - FEELS LIKE
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0.0, 20.0, 5.0, 5.0),
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // BLUE BOX / FEELS LIKE
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: getIconString('thermometer'),
                                ),
                                // BLUE BOX / WIND
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('FEELS LIKE'),
                                    Text('$feelsLike${c.temperatureUnits}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // BLUE BOX - WIND
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 5.0),
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // BLUE BOX / WIND
                                getWindIcon(angle, 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('WIND'),
                                    Text('$windDirection $windSpeed${c.speedUnits}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // HUMIDITY / CLOUDS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // BLUE BOX - HUMIDITY
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 5.0, 5.0, 5.0),
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // BLUE BOX / HUMIDITY
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: getIconString('humidity'),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('HUMIDITY'),
                                    Text('$humidity%'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // BLUE BOX - CLOUDS
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // BLUE BOX / CLOUDS
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: getIconInt(801),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('CLOUDS'),
                                    Text('$clouds%'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // POP / RAIN 1HR IF AVAILABLE
                    getPrecipInfo(),
                    // DIVIDER
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
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
              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ],
    );
  }
}
