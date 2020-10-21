import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_revolt.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/services/networking.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class RevoltScreen extends StatelessWidget {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerRevolt cr = Get.put(ControllerRevolt());
  final ControllerForecast cf = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: Obx(() => cf.isWeatherEvent(EdgeInsets.only(top: 150.0))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      // BACKGROUND GRADIENT / BODY
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: kGradientBackgroundDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // HEADER
            Container(
              padding: EdgeInsets.fromLTRB(0, 35.0, 0, 25.0),
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
                        child: getIconString('back', color: Colors.white70),
                      ),
                      // PAGE TITLE
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 35.0),
                          child: FittedBox(
                            child: Text('REVOLT Wind',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22.0,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                )),
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
                                  c.updateUnits();
                                  await WeatherModel().getCityWeather();
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
                  // CITY NAME BOX / GET NEW CITY ICON
                  Container(
                    margin: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    // MARKER ICON / CURRENT CITY / LAST UPDATED / NEW CITY BUTTON
                    child: Row(
                      children: [
                        // MARKER ICON
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: getIconString('location', size: 30.0, color: kLightPurple),
                          ),
                          flex: 1,
                        ),
                        // CURRENT CITY NAME / LAST UPDATED
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            // CURRENT CITY NAME / LAST UPDATED
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // CURRENT CITY
                                Obx(
                                  () => Text(
                                    '${cu.city.value.toUpperCase()}${cu.country.value}',
                                    style: TextStyle(
                                      color: Color(0xFF4C547B),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                // LAST UPDATED
                                Obx(
                                  () => Text(
                                    'Last updated: ${cf.lastUpdate.value}',
                                    style: TextStyle(color: Color(0xFF4C547B)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // BEGIN SCROLL VIEW
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  // REVOLT CONTAINER
                  GestureDetector(
                    onTap: () => NetworkHelper('https://revoltwind.com').openBrowserTab(),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                      child: Row(
                        children: [
                          ImageIcon(AssetImage('images/greenBolt.png'), size: 50.0, color: kSwitchColor),
                          SizedBox(width: 20.0),
                          Flexible(
                            child: Obx(
                              () => Text(
                                '${cf.revoltText.value} Tap to visit REVOLTwind.com',
                                maxLines: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // GIF
                  cr.windmillGif(),
                  // DESCRIPTION OF REVOLT WIND
                  cr.paragraph(
                    'The REVOLT wind turbine hangs from an overhead support such as a line strung between two points, a hook, bracket, or tree branch. It requires no tower, no permit, no real estate, no footers, and no guy wires making it inexpensive, fast and easy to set up.',
                  ),
                  cr.paragraph(
                    'The hanging design was born to allow windmills to be deployed in areas where towers are not permitted. It can be built in a range of sizes using the same blades and electric generator that are used on tower mounted windmills, but at a fraction of the cost. Because the device is not anchored to the ground by the tower, you can own it without owning the land beneath it and take it with you wherever you go.',
                  ),
                  cr.paragraph(
                    'On a planet where about three billion people do not have access to the electric grid, inexpensive, mass-produced REVOLT windmills will literally change the quality of life for millions by making electricity available and accessible to nearly anyone who needs convenient, remote, or portable electricity.',
                  ),
                  cr.paragraph(
                    'The mission of REVOLT wind, is to bring revolutionary wind-driven machines into mass-production so that they can be used to help solve today’s energy production and pollution problems while improving the lifestyle of people worldwide.',
                  ),
                  // BUY NOW / DETAILS BUTTONS
                  cr.buyOrViewBtnRow(),
                  // REVOLT LOGO TO WEBSITE
                  cr.goToWebsite(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
