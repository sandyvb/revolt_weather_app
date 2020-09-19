import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:revolt_weather_app/services/spinner.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'get_icon.dart';
import 'map_component.dart';

class GetCurrent extends StatefulWidget {
  @override
  _GetCurrentState createState() => _GetCurrentState();
}

class _GetCurrentState extends State<GetCurrent> {
  final Controller c = Get.find();
  final ControllerUpdate cc = Get.find();
  final ControllerForecast cf = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // SPINNERS FOR TEMP / REVOLT / HOURS TIL SUNSET
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TEMPERATURE / CONDITIONS
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: smallSleekCircularSlider(
                      max: c.isMetric.value ? 65.56 : 150.0,
                      initialValue: cf.currentTemp.value.toDouble(),
                      modifier: temperatureTextModifier,
                      colors: [kHr, Color(0xFF1F7AFC)],
                      bottomLabelText: 'Temperature',
                      size: 118.0,
                      mainLabelStyle: kDataCurrent,
                    ),
                  ),
                  Text('${toBeginningOfSentenceCase(cf.currentWeatherMain.value)}'),
                  getIconInt(cf.currentWeatherId.value),
                ],
              ),
              // REVOLT POWER
              GestureDetector(
                onTap: () => Get.to(RevoltScreen()),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: smallSleekCircularSlider(
                        max: 200,
                        initialValue: cc.power.value,
                        modifier: revoltTextModifier,
                        colors: [kHr, Color(0xFF83D475), Color(0xFF2EB62C)],
                        bottomLabelText: getWatt(),
                        size: 118.0,
                        mainLabelStyle: kDataCurrent,
                      ),
                    ),
                    Text('REVOLT Power'),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: [
                          getIconString('wind'),
                          Text('  ${cf.currentWindSpeed.value.toInt()}${c.speedUnits}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // SUNRISE / SUNSET
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: smallSleekCircularSlider(
                      max: 24,
                      // initialValue: double.parse(current.currentSunsetHour) - double.parse(current.hourNow),
                      initialValue: cf.getHoursUntilSunset(),
                      modifier: hourTillSunsetTextModifier,
                      colors: [kHr, Color(0xFFF1AA3B), Color(0xFFD36321)],
                      bottomLabelText: cf.sunriseSunsetMessage.value,
                      size: 118.0,
                      mainLabelStyle: kDataCurrent,
                    ),
                  ),
                  Text('Sunrise: ${cf.currentSunrise.value}'),
                  Text('Sunset: ${cf.currentSunset.value}'),
                  Text('in ${cc.initialCity.value} time'),
                ],
              ),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // MORNING / AFTERNOON / EVENING / OVERNIGHT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // MORNING
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: smallSleekCircularSlider(
                      max: c.isMetric.value ? 65.5556 : 150.0,
                      initialValue: cf.daily[0]['temp']['morn'].toDouble(),
                      modifier: temperatureTextModifier,
                      colors: [kHr, Color(0xFF3C4156), Color(0xFFAB319E)],
                      size: 80.0,
                      mainLabelStyle: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Text('Morning'),
                ],
              ),
              // AFTERNOON
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: smallSleekCircularSlider(
                      max: c.isMetric.value ? 65.5556 : 150.0,
                      initialValue: cf.daily[0]['temp']['day'].toDouble(),
                      modifier: temperatureTextModifier,
                      colors: [kHr, Color(0xFFF1AA3B), Color(0xFFD36321)],
                      size: 80.0,
                      mainLabelStyle: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Text('Afternoon'),
                ],
              ),
              // EVENING
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: smallSleekCircularSlider(
                      max: c.isMetric.value ? 65.5556 : 150.0,
                      initialValue: cf.daily[0]['temp']['eve'].toDouble(),
                      modifier: temperatureTextModifier,
                      colors: [kHr, Color(0xFF4E61EC), Color(0xFF69E1EF)],
                      size: 80.0,
                      mainLabelStyle: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Text('Evening'),
                ],
              ),
              // OVERNIGHT
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: smallSleekCircularSlider(
                      max: c.isMetric.value ? 65.5556 : 150.0,
                      initialValue: cf.daily[0]['temp']['night'].toDouble(),
                      modifier: temperatureTextModifier,
                      colors: [kHr, Color(0xFF1F7AFC), Color(0xFF00264D)],
                      size: 80.0,
                      mainLabelStyle: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Text('Overnight'),
                ],
              ),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // HIGH / LOW TEMPS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('thermometer'),
                  ),
                  Text('High / Low'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${cf.daily[0]['temp']['max'].toInt()}${c.temperatureUnits.value}'),
                  Text(' / '),
                  Text('${cf.daily[0]['temp']['min'].toInt()}${c.temperatureUnits.value}'),
                ],
              ),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // PRECIPITATION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('raindrop'),
                  ),
                  Text('Chance of Precipitation'),
                ],
              ),
              Text('${cf.daily[0]['pop']}%'),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // CLOUDS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconInt(801),
                  ),
                  Text('Cloud Cover'),
                ],
              ),
              Text('${cc.clouds}%'),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // WIND
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('wind'),
                  ),
                  Text('Wind'),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: getWindIcon(cf.currentWindDeg.value),
                  ),
                  Text('${cf.currentWindSpeed.value.toInt()} ${c.speedUnits.value}'),
                ],
              ),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // HUMIDITY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('humidity'),
                  ),
                  Text('Humidity'),
                ],
              ),
              Text('${cf.currentHumidity.value.toInt()}%'),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // DEW POINT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('raindrops'),
                  ),
                  Text('Dew Point'),
                ],
              ),
              Text('${cf.currentDewpoint.value.toInt()}${c.temperatureUnits.value}'),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // UVI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconInt(800),
                  ),
                  Text('UV Index'),
                ],
              ),
              Text('${cf.returnUviIndex(cf.currentUvi)}'),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // VISIBILITY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('visibility'),
                  ),
                  Text('Visibility'),
                ],
              ),
              Text('${cf.currentVisibility.value.toStringAsFixed(1)} ${c.distanceUnits.value}'),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // PRESSURE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('pressure'),
                  ),
                  Text('Pressure'),
                ],
              ),
              Text('${cf.currentPressure.value} inHg'),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // DENSITY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('pressure'),
                  ),
                  Text('Air Density'),
                ],
              ),
              Text('${cc.airDensity.value} kg/m^3'),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // LATITUDE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(MaterialCommunityIcons.latitude),
                  ),
                  Text('Latitude'),
                ],
              ),
              Text('${cc.lat}°'),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // LONGITUDE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(MaterialCommunityIcons.longitude),
                  ),
                  Text('Longitude'),
                ],
              ),
              Text('${cc.lon}°'),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // ALTITUDE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(MaterialCommunityIcons.slope_uphill),
                  ),
                  Text('Altitude'),
                ],
              ),
              Obx(() => Text('${c.altitude.value.toInt()} ${c.altitudeUnits.value}')),
            ],
          ),
          // DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          // MAP
          Container(
            height: 400.0,
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
            child: MapComponent(),
          ),
        ],
      ),
    );
  }
}
