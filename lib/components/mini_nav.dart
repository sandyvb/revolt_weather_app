import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/forecast_screen.dart';
import 'package:revolt_weather_app/screens/glance_screen.dart';
import 'package:revolt_weather_app/screens/location_screen.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'get_icon.dart';

final Controller c = Get.find();
final ControllerUpdate cu = Get.find();
final ControllerForecast cf = Get.find();

Padding miniNav() {
  return Padding(
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
                child: Obx(
                  () => Text(
                    cu.city.value.contains('SOMEWHERE') ? '${cu.city.value}' : '${cu.city.value.toUpperCase()}${cu.country.value}',
                    style: kHeadingTextLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Obx(
                  () => Text(
                    'last update: ${cf.lastUpdate.value}',
                    style: kSubHeadingText,
                  ),
                ),
              ),
            ],
          ),
        ),
        // HOME BUTTON
        IconButton(
          icon: getIconString('home'),
          onPressed: () => Get.offAll(LocationScreen()),
        ),
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
  );
}
