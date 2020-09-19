import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class GetDaily extends StatefulWidget {
  @override
  _GetDailyState createState() => _GetDailyState();
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

class _GetDailyState extends State<GetDaily> {
  final Controller c = Get.find();
  final ControllerUpdate cc = Get.find();
  final ControllerForecast cf = Get.find();

  // CALL TO INITIALIZE A LIST
  List<Item> _data = generateItems(8);

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      // POPULATE LIST ITEMS WITH DATA
      children: _data.map<ExpansionPanel>((Item item) {
        // DECLARE VARIABLES
        var abbrDate = item.index == 0 ? 'Today' : '${cf.getAbbrDay(cf.daily[item.index]['dt'])}';
        var maxTemp = cf.daily[item.index]['temp']['max'].toInt();
        var minTemp = cf.daily[item.index]['temp']['min'].toInt();
        Icon weatherIcon = getIconInt(cf.daily[item.index]['weather'][0]['id'], 20.0);
        Icon weatherIconLargeDay = getIconIntDayOrNight(cf.daily[item.index]['weather'][0]['id'], 50.0, 'day');
        Icon weatherIconLargeNight = getIconIntDayOrNight(cf.daily[item.index]['weather'][0]['id'], 50.0, 'night');
        Icon raindropIcon = getIconString('raindrop', 17.0);
        Icon raindropIconLarge = getIconString('raindrop', 22.0);
        var pop = cf.daily[item.index]['pop'];
        var dateDay = '${cf.getDay(cf.daily[item.index]['dt'])}';
        var dateNight = '${cf.getNight(cf.daily[item.index]['dt'])}';
        var dayTemp = '${cf.daily[item.index]['temp']['day'].toInt()}${c.temperatureUnits}';
        var nightTemp = '${cf.daily[item.index]['temp']['night'].toInt()}${c.temperatureUnits}';
        var angle = cf.daily[item.index]['wind_deg'];
        String windDirection = cc.getWindDirection(angle);
        var windSpeed = cf.daily[item.index]['wind_speed'].toInt();
        var windDirectionIcon = getWindIcon(angle, 20.0);
        var gust;
        try {
          gust = ' - ${cf.daily[item.index]['wind_gust'].toInt()}';
        } catch (e) {
          gust = '';
        }
        String description = toBeginningOfSentenceCase(cf.daily[item.index]['weather'][0]['description']);
        var feelsLikeDay = cf.daily[item.index]['feels_like']['day'].toInt();
        var feelsLikeNight = cf.daily[item.index]['feels_like']['night'].toInt();
        var humidity = cf.daily[item.index]['humidity'];
        var uvi = cf.returnUviIndex(cf.daily[item.index]['uvi']);
        var sunrise = cf.getReadableTime(cf.daily[item.index]['sunrise']);
        var sunset = cf.getReadableTime(cf.daily[item.index]['sunset']);

        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            // UNEXPANDED DATA
            return ListTile(
              // DATE / HIGH TEMP / LOW TEMP / ICON ID / ICON RAINDROP / POP
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$abbrDate'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$maxTemp${c.temperatureUnits.value}'),
                      Text(' / '),
                      Text('$minTemp${c.temperatureUnits.value}'),
                    ],
                  ),
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
                // DAY / DATE / DAY \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                Text(dateDay),
                // DAY TEMP / WEATHER ICON / POP / WIND
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DAY TEMP
                    Text('$dayTemp', style: TextStyle(fontSize: 62.0)),
                    // WEATHER ICON
                    weatherIconLargeDay,
                    // POP / WIND
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // POP
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              raindropIconLarge,
                              Text(
                                '$pop%',
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                        // WIND
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            windDirectionIcon,
                            Text(' $windDirection $windSpeed', style: TextStyle(fontSize: 15.0)),
                            Text('${c.speedUnits}', style: TextStyle(fontSize: 12.0)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // FEELS LIKE
                Row(children: [Text('Feels like $feelsLikeDay${c.temperatureUnits}.')]),
                // DESCRIPTION / HIGH TEMP
                Row(
                  children: [
                    Text('$description. '),
                    Text(' High near $maxTemp${c.temperatureUnits.value}.'),
                  ],
                ),
                // WIND
                Row(
                  children: [
                    Text('Winds $windDirection $windSpeed $gust${c.speedUnits}.'),
                  ],
                ),
                // DETAILS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                // HUMIDITY / UVI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // BLUE BOX - HUMIDITY
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 20.0, 5.0, 5.0),
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
                    // BLUE BOX - UVI
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
                            // BLUE BOX / UVI
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: getIconInt(800),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('UV INDEX'),
                                Text('$uvi'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // BLUE BOX - CONDITION
                  ],
                ),
                // SUNRISE / SUNSET
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // BLUE BOX - SUNRISE
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
                            // BLUE BOX / SUNRISE
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: getIconString('sunrise'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SUNRISE'),
                                Text('$sunrise'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // BLUE BOX - SUNSET
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
                            // BLUE BOX / SUNSET
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: getIconString('sunset'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SUNSET'),
                                Text('$sunset'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // BLUE BOX - CONDITION
                  ],
                ),
                // NIGHT / DATE /DAY \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
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
                Text(dateNight),
                // NIGHT TEMP / WEATHER ICON / POP / WIND
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NIGHT TEMP
                    Text('$nightTemp', style: TextStyle(fontSize: 62.0)),
                    // WEATHER ICON
                    weatherIconLargeNight,
                    // POP / WIND
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // POP
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              raindropIconLarge,
                              Text(
                                '$pop%',
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                        // WIND
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            windDirectionIcon,
                            Text(' $windDirection $windSpeed', style: TextStyle(fontSize: 15.0)),
                            Text('${c.speedUnits}', style: TextStyle(fontSize: 12.0)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // FEELS LIKE
                Row(children: [Text('Feels like $feelsLikeNight${c.temperatureUnits}.')]),
                // DESCRIPTION / LOW TEMP
                Row(
                  children: [
                    Text('$description. '),
                    Text(' Low near $minTemp${c.temperatureUnits.value}.'),
                  ],
                ),
                // WIND
                Row(
                  children: [
                    Text('Winds $windDirection $windSpeed $gust${c.speedUnits}.'),
                  ],
                ),
                // DIVIDER
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 10.0),
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
    );
  }
}
