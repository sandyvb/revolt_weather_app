import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/footer.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_location.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/city_screen.dart';
import 'package:revolt_weather_app/screens/glance_screen.dart';
import 'package:revolt_weather_app/screens/forecast_screen.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:revolt_weather_app/services/sliders.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'package:revolt_weather_app/components/get_icon.dart';

class LocationScreen extends StatelessWidget {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerLocation cl = Get.put(ControllerLocation());
  final ControllerForecast cf = Get.find();

  // GET WORLD TIME - https://www.bigdatacloud.com/time-zone-apis/timezone-by-location-api

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      // floatingActionButton: Obx(() => cf.isWeatherEventExtended(EdgeInsets.only(top: 105.0))),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      // INCL BACKGROUND GRADIENT
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: kGradientBackgroundDecoration,
        // MAIN BODY
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // HEADER
            Container(
              padding: EdgeInsets.only(top: 35.0),
              decoration: BoxDecoration(
                color: kHeaderBlue,
                boxShadow: kBoxShadowDown,
              ),
              // REFRESH / GREETING / UNITS / DATE / TIME / DIVIDER
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // REFRESH / GREETING / UNITS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // REFRESH
                      FlatButton(
                        onPressed: () {
                          cl.refresh();
                        },
                        child: getIconString('refresh', color: Colors.white),
                      ),
                      // GREETING
                      Obx(
                        () => Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: FittedBox(
                              child: Text(
                                '${cf.greetingLocationScreen.value}',
                                style: kGreetingText,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // UNITS
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                            Text('C°'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  // DAY / DATE
                  cf.getDayDate(),
                  // DIVIDER
                  gradientDivider(padding: EdgeInsets.fromLTRB(15, 13, 15, 8)),
                ],
              ),
            ),
            // MAIN DATA CONTAINER
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                children: [
                  // FLOATING ACTION BUTTON
                  Obx(() => cf.isWeatherEventExtended(EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0))),
                  // DATA CONTAINER
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 18.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4D5268),
                          Color(0xFF34394D),
                          Color(0xFF272A3B),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.clamp,
                      ),
                      boxShadow: kBoxShadowDD,
                    ),
                    // HEADER AND CIRCULAR SLIDERS SECTION
                    child: Column(
                      children: [
                        // CURRENT CITY & LAST UPDATED / CITY BUTTON / FORECAST BUTTON / GLANCE BUTTON
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 9.0, bottom: 18.0),
                          child: Row(
                            children: [
                              // CURRENT CITY & LAST UPDATED
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Obx(() => Text(
                                            '${cu.city.value.toUpperCase()}${cu.country.value}',
                                            style: kHeadingTextLarge,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )),
                                    ),
                                    FittedBox(fit: BoxFit.scaleDown, child: Obx(() => Text('last update: ${cf.lastUpdate.value}', style: kSubHeadingText))),
                                  ],
                                ),
                              ),
                              // CITY BUTTON
                              IconButton(
                                  icon: getIconString('city'),
                                  onPressed: () {
                                    c.prevScreen.value = 'location';
                                    Get.to(CityScreen());
                                  }),
                              // FORECAST BUTTON
                              IconButton(
                                icon: getIconString('forecast'),
                                onPressed: () => Get.to(ForecastScreen()),
                              ),
                              // GLANCE BUTTON
                              IconButton(
                                icon: getIconString('glance'),
                                onPressed: () => Get.to(GlanceScreen()),
                              ),
                            ],
                          ),
                        ),
                        // BEGIN SLIDERS (row of 2 columns)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SLIDERS LEFT COLUMN / TEMP /CONDITIONS / WIND
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TEMPERATURE SLIDER
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
                                  child: Obx(
                                    () => circularSlider(
                                      min: c.isMetric.value ? -23.3333 : -10.0,
                                      max: c.isMetric.value ? 65.5556 : 150.0,
                                      initialValue: getLargeSliderInitValue(),
                                      modifier: temperatureTextModifier,
                                      colors: [kHr, Color(0xFF1F7AFC)],
                                      shadowColor: kBlack,
                                      shadowMaxOpacity: 0.018,
                                      trackWidth: 5.0,
                                      progressBarWidth: 5.0,
                                      shadowWidth: 95.0,
                                      bottomLabelText: 'TEMPERATURE',
                                      size: Get.width / 2,
                                      mainLabelStyle: kMainDataLargeSpinner,
                                      startAngle: 0.0,
                                      angleRange: 360.0,
                                    ),
                                  ),
                                ),
                                // CONDITION & WIND
                                Row(
                                  children: [
                                    // CONDITION SLIDER
                                    Obx(
                                      () => Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // CONDITION SLIDER
                                              circularSlider(
                                                max: 900.0,
                                                initialValue: cf.currentWeatherId.value.toDouble(),
                                                modifier: nullTextModifier,
                                                colors: [kHr, Color(0xFF9074FD), Color(0xFF3F30EB)],
                                                size: Get.width * 0.2,
                                                mainLabelStyle: kData,
                                              ),
                                              // CONDITION ICON
                                              Container(
                                                width: 30,
                                                height: 30,
                                                child: getIconInt(cf.currentWeatherId.value, color: Colors.white, dayOrNight: cf.getDayOrNight()),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Text('${cf.currentWeatherMain.value.toUpperCase()}', style: kSpinnerLabels),
                                        ],
                                      ),
                                    ),
                                    // WIND SLIDER
                                    Padding(
                                      padding: EdgeInsets.only(left: Get.width * 0.1),
                                      child: Column(
                                        children: [
                                          // WIND SLIDER
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Obx(
                                              () => circularSlider(
                                                min: 0,
                                                max: c.isMetric.value ? 65.5556 : 150.0,
                                                initialValue: cf.currentWindSpeed.value.toDouble(),
                                                modifier: windTextModifier,
                                                colors: [kHr, Color(0xFF4E61EC), Color(0xFF69E1EF)],
                                                bottomLabelText: '${c.speedUnits}',
                                                size: Get.width * 0.2,
                                                mainLabelStyle: kData,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              getWindIcon(cf.currentWindDeg.value, size: 16.0),
                                              Text(' WIND', style: kSpinnerLabels),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // RIGHT COLUMN / HUMIDITY / POWER
                            Padding(
                              // padding: EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 0.0),
                              padding: EdgeInsets.only(top: 2.0),
                              child: Column(
                                children: [
                                  // HUMIDITY SLIDER
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Obx(
                                      () => circularSlider(
                                        max: 100.0,
                                        initialValue: cf.currentHumidity.value.toDouble(),
                                        modifier: percentTextModifier,
                                        colors: [kHr, Color(0xFFF1AA3B), Color(0xFFD36321)],
                                        size: Get.width * 0.2,
                                        mainLabelStyle: kData,
                                      ),
                                    ),
                                  ),
                                  Text('HUMIDITY', style: kSpinnerLabels),
                                  //REVOLT WIND POWER
                                  GestureDetector(
                                    onTap: () => Get.to(RevoltScreen()),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                                          child: circularSlider(
                                            max: 200.5,
                                            initialValue: cf.power.value,
                                            modifier: revoltTextModifier,
                                            colors: [kHr, Color(0xFF83D475), Color(0xFF2EB62C)],
                                            bottomLabelText: cf.watt.value,
                                            size: Get.width * 0.2,
                                            mainLabelStyle: kData,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            getIconString('revolt', size: 15.0),
                                            Text(' REVOLT', style: kSpinnerLabels),
                                          ],
                                        ),
                                        Text('POWER', style: kSpinnerLabels),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // FOOTER
            footer(),
          ],
        ),
      ),
    );
  }
}
