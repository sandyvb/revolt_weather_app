import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_current.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:revolt_weather_app/services/sliders.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'get_icon.dart';

class GetCurrent extends StatelessWidget {
  final ControllerCurrent cc = Get.put(ControllerCurrent());
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerForecast cf = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 25.0),
      child: Column(
        children: [
          // SPINNERS FOR TEMP / REVOLT / HOURS TIL SUNSET
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TEMPERATURE / CONDITIONS
              Container(
                constraints: BoxConstraints(
                  maxWidth: Get.width / 3.6,
                ),
                child: Obx(
                  () => Column(
                    children: [
                      circularSlider(
                        max: c.isMetric.value ? 65.56 : 150.0,
                        initialValue: cf.currentTemp.value.toDouble(),
                        modifier: temperatureTextModifier,
                        colors: [kHr, Color(0xFF1F7AFC)],
                        bottomLabelText: 'Temperature',
                        size: Get.width / 3.6,
                        mainLabelStyle: kDataCurrent,
                        bottomLabelStyle: kBottomLabelStyleSm,
                      ),
                      SizedBox(height: 10.0),
                      FittedBox(child: Text('${toBeginningOfSentenceCase(cf.currentWeatherDescription.value)}', style: kOxygen)),
                      Container(
                        width: 33,
                        height: 33,
                        child: getIconInt(cf.currentWeatherId.value, size: 33.0, dayOrNight: cf.getDayOrNight()),
                      ),
                    ],
                  ),
                ),
              ),
              // REVOLT POWER
              Container(
                constraints: BoxConstraints(
                  maxWidth: Get.width / 3.6,
                ),
                child: GestureDetector(
                  onTap: () => Get.to(RevoltScreen()),
                  child: Obx(
                    () => Column(
                      children: [
                        circularSlider(
                          max: 200,
                          initialValue: cf.power.value,
                          modifier: revoltTextModifier,
                          colors: [kHr, Color(0xFF83D475), Color(0xFF2EB62C)],
                          bottomLabelText: cf.watt.value,
                          size: Get.width / 3.6,
                          mainLabelStyle: kDataCurrent,
                          bottomLabelStyle: kBottomLabelStyleSm,
                        ),
                        SizedBox(height: 10.0),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'REVOLT power',
                              style: kOxygen,
                            )),
                        Text('${cf.currentWindSpeed.value.toInt()} ${c.speedUnits}',
                            style: kOxygen.copyWith(
                              height: 1.5,
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 3.0),
                              child: getWindIcon(cf.currentWindDeg.value, size: 16.0),
                            ),
                            Text('  ${getWindDirection(cf.currentWindDeg.value)}',
                                style: kOxygen.copyWith(
                                  height: 1.5,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // SUNRISE / SUNSET
              Container(
                constraints: BoxConstraints(
                  maxWidth: Get.width / 3.6,
                ),
                child: Obx(
                  () => Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: circularSlider(
                          max: 12,
                          initialValue: cf.timeDifference.value,
                          modifier: hourTillSunsetTextModifier,
                          colors: [kHr, Color(0xFFF1AA3B), Color(0xFFD36321)],
                          bottomLabelText: cf.sunriseSunsetMessage.value,
                          size: Get.width / 3.6,
                          mainLabelStyle: kDataCurrent,
                          bottomLabelStyle: kBottomLabelStyleSm,
                          startAngle: 0,
                          angleRange: 360,
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          'Sunrise: ${cf.currentSunrise.value}',
                          style: kOxygen,
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          'Sunset: ${cf.currentSunset.value}',
                          style: kOxygen.copyWith(height: 1.5),
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          '${cu.initialCity.value} time',
                          style: kOxygen.copyWith(height: 1.5),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // MORNING / AFTERNOON / EVENING / OVERNIGHT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // MORNING
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Obx(
                      () => circularSlider(
                        max: c.isMetric.value ? 65.5556 : 150.0,
                        initialValue: cf.daily[0]['temp']['morn'].toDouble(),
                        modifier: temperatureTextModifier,
                        colors: [kHr, Color(0xFF3C4156), Color(0xFFAB319E)],
                        size: Get.width / 4.8,
                        mainLabelStyle: kDataCurrentSmall,
                      ),
                    ),
                  ),
                  Text('Morning', style: kOxygen),
                ],
              ),
              // AFTERNOON
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Obx(
                      () => circularSlider(
                        max: c.isMetric.value ? 65.5556 : 150.0,
                        initialValue: cf.daily[0]['temp']['day'].toDouble(),
                        modifier: temperatureTextModifier,
                        colors: [kHr, Color(0xFFF1AA3B), Color(0xFFD36321)],
                        size: Get.width / 4.8,
                        mainLabelStyle: kDataCurrentSmall,
                      ),
                    ),
                  ),
                  Text('Afternoon', style: kOxygen),
                ],
              ),
              // EVENING
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Obx(
                      () => circularSlider(
                        max: c.isMetric.value ? 65.5556 : 150.0,
                        initialValue: cf.daily[0]['temp']['eve'].toDouble(),
                        modifier: temperatureTextModifier,
                        colors: [kHr, Color(0xFF4E61EC), Color(0xFF69E1EF)],
                        size: Get.width / 4.8,
                        mainLabelStyle: kDataCurrentSmall,
                      ),
                    ),
                  ),
                  Text('Evening', style: kOxygen),
                ],
              ),
              // OVERNIGHT
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Obx(
                      () => circularSlider(
                        max: c.isMetric.value ? 65.5556 : 150.0,
                        initialValue: cf.daily[0]['temp']['night'].toDouble(),
                        modifier: temperatureTextModifier,
                        colors: [kHr, Color(0xFF1F7AFC), Color(0xFF00264D)],
                        size: Get.width / 4.8,
                        mainLabelStyle: kDataCurrentSmall,
                      ),
                    ),
                  ),
                  Text('Overnight', style: kOxygen),
                ],
              ),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // HIGH / LOW TEMPS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('thermometer', color: Colors.white),
                  ),
                  Text('High / Low', style: kOxygenWhite),
                ],
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${cf.daily[0]['temp']['max'].toInt()}${c.temperatureUnits.value}',
                      style: kOxygenWhite,
                    ),
                    Text(' / ', style: kOxygenWhite),
                    Text(
                      '${cf.daily[0]['temp']['min'].toInt()}${c.temperatureUnits.value}',
                      style: kOxygenWhite,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // PRECIPITATION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('raindrop', color: Colors.white),
                  ),
                  FittedBox(child: Text('Chance of Precipitation', style: kOxygenWhite)),
                ],
              ),
              Obx(() => Text('${(cf.daily[0]['pop'] * 100).toStringAsFixed(1)}%', style: kOxygenWhite)),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // CLOUDS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconInt(801, color: Colors.white),
                  ),
                  Text('Cloud Cover', style: kOxygenWhite),
                ],
              ),
              Obx(() => Text('${cf.currentClouds.value}%', style: kOxygenWhite)),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // WIND
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('wind', color: Colors.white),
                  ),
                  Text('Wind', style: kOxygenWhite),
                ],
              ),
              Obx(
                () => Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: getWindIcon(cf.currentWindDeg.value, color: Colors.white),
                    ),
                    Text(
                      '${getWindDirection(cf.currentWindDeg.value)}  ${cf.currentWindSpeed.value.toInt()} ${c.speedUnits.value}',
                      style: kOxygenWhite,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // HUMIDITY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('humidity', size: 20.0, color: Colors.white),
                  ),
                  Text('Humidity', style: kOxygenWhite),
                ],
              ),
              Obx(() => Text('${cf.currentHumidity.value.toInt()}%', style: kOxygenWhite)),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // DEW POINT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('raindrops', color: Colors.white),
                  ),
                  Text('Dew Point', style: kOxygenWhite),
                ],
              ),
              Obx(
                () => Text(
                  '${cf.currentDewpoint.value.toInt()}${c.temperatureUnits.value}',
                  style: kOxygenWhite,
                ),
              ),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // UVI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconInt(800, color: Colors.white),
                  ),
                  Text('UV Index', style: kOxygenWhite),
                ],
              ),
              Obx(() => Text('${cf.returnUviIndex(cf.currentUvi.value)}', style: kOxygenWhite)),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // VISIBILITY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('visibility', color: Colors.white),
                  ),
                  Text('Visibility', style: kOxygenWhite),
                ],
              ),
              Obx(() => Text(
                    '${cf.currentVisibility.value.toStringAsFixed(1)} ${c.distanceUnits.value}',
                    style: kOxygenWhite,
                  )),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // PRESSURE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('pressure', color: Colors.white),
                  ),
                  Text('Pressure', style: kOxygenWhite),
                ],
              ),
              Obx(() => Text('${cf.currentPressureHg.value} inHg', style: kOxygenWhite)),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // ALTITUDE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('altitude', color: Colors.white),
                  ),
                  Text('Altitude', style: kOxygenWhite),
                ],
              ),
              Obx(
                () => Text('${c.altitude.value.toInt()} ${c.altitudeUnits.value}', style: kOxygenWhite),
              ),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // LATITUDE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('latitude', color: Colors.white),
                  ),
                  Text('Latitude', style: kOxygenWhite),
                ],
              ),
              Obx(() => Text('${cu.lat}°', style: kOxygenWhite)),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // LONGITUDE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('longitude', color: Colors.white),
                  ),
                  Text('Longitude', style: kOxygenWhite),
                ],
              ),
              Obx(() => Text('${cu.lon}°', style: kOxygenWhite)),
            ],
          ),
          // DIVIDER
          gradientDivider(padding: EdgeInsets.symmetric(vertical: 20.0)),
          // DENSITY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: getIconString('pressure', color: Colors.white),
                  ),
                  Text('Air Density', style: kOxygenWhite),
                ],
              ),
              Obx(() => Text('${cf.airDensity.value} kg/m^3', style: kOxygenWhite)),
            ],
          ),
        ],
      ),
    );
  }
}
