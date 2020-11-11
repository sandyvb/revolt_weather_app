import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/footer.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/components/mini_nav.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_revolt.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/services/networking.dart';
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
      // BACKGROUND GRADIENT / BODY
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: kGradientBackgroundDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // HEADER
            Container(
              padding: EdgeInsets.fromLTRB(0, 35.0, 0, 30.0),
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
                      Padding(
                        padding: cf.isEvent.value ? const EdgeInsets.only(right: 40.0) : const EdgeInsets.only(right: 95.0),
                        child: Text(
                          'Revolt Wind',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 22.0,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: cf.isWeatherEvent(EdgeInsets.only(top: 0.0)),
                      ),
                    ],
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
                  miniNav(),
                  gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0)),
                  // REVOLT CONTAINER
                  GestureDetector(
                    onTap: () => NetworkHelper('https://revoltwind.com').openBrowserTab(),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                      child: Row(
                        children: [
                          ImageIcon(AssetImage('images/greenBolt.webp'), size: 50.0, color: kSwitchColor),
                          SizedBox(width: 20.0),
                          Flexible(
                            child: Obx(
                              () => Text(
                                '${cf.revoltText.value} Tap to visit revoltwind.com',
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
                  footer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
