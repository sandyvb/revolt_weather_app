import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:flutter/material.dart';
import 'package:revolt_weather_app/services/networking.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class RevoltContainer extends StatelessWidget {
  final ControllerUpdate cu = Get.find();
  final ControllerForecast cf = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(RevoltScreen()),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Row(
          children: [
            ImageIcon(AssetImage('images/greenBolt.png'), size: 50.0, color: kSwitchColor),
            SizedBox(width: 20.0),
            Flexible(
              child: Obx(
                () => Text('${cf.revoltText.value} Tap here!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RevoltContainerToWebsite extends StatelessWidget {
  final ControllerUpdate cu = Get.find();
  final ControllerForecast cf = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NetworkHelper('https://revoltwind.com').openBrowserTab(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Row(
          children: [
            ImageIcon(AssetImage('images/greenBolt.png'), size: 50.0, color: kSwitchColor),
            SizedBox(width: 20.0),
            Flexible(
              child: Obx(
                () => Text('${cf.revoltText.value} Tap to visit REVOLTwind.com'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
