import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class AlertScreen extends StatelessWidget {
  final ControllerUpdate cu = Get.find();
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
              padding: EdgeInsets.fromLTRB(0, 35.0, 0, 25.0),
              decoration: BoxDecoration(
                boxShadow: kBoxShadowDown,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
                gradient: kRedGradientDiagonal,
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
                        child: getIconString('back', color: Colors.white),
                      ),
                      // PAGE TITLE
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: Get.width * 0.22),
                          child: FittedBox(
                            child: Text(
                              'Weather Alert',
                              style: kGreetingText,
                            ),
                          ),
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
                            child: getIconString('location', size: 30.0, color: Color(0xFFC42E2C)),
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
                padding: EdgeInsets.all(20.0),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Text(
                    'From: ${cf.senderName}',
                    maxLines: 2,
                  ),
                  FittedBox(child: Text(cf.event.value)),
                  Text(cf.eventDescription.value,
                      style: TextStyle(
                        fontSize: 16.0,
                        height: 1.5,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
