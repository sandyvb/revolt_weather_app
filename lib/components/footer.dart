import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_location.dart';
import 'package:revolt_weather_app/screens/city_screen.dart';
import 'package:revolt_weather_app/screens/forecast_screen.dart';
import 'package:revolt_weather_app/screens/glance_screen.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'get_icon.dart';

Container footer() {
  final Controller c = Get.find();
  final ControllerLocation cl = Get.find();

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
      gradient: kBlueGradientVertical,
      boxShadow: kBoxShadowUp,
    ),
    child: Column(
      children: [
        // BOTTOM NAVIGATOR
        Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
          child: Row(
            children: [
              // NEW CITY
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: getIconString('city'),
                      onPressed: () {
                        c.prevScreen.value = 'location';
                        Get.to(CityScreen());
                      },
                    ),
                    Text('NEW CITY', style: kFooterIconText),
                  ],
                ),
              ),
              // FORECAST
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: getIconString('forecast'),
                      onPressed: () => Get.to(ForecastScreen()),
                    ),
                    Text('FORECAST', style: kFooterIconText),
                  ],
                ),
              ),
              // GLANCE
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: getIconString('glance', size: 30.0),
                      onPressed: () => Get.to(GlanceScreen()),
                    ),
                    Text('GLANCE', style: kFooterIconText),
                  ],
                ),
              ),
              // REFRESH
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: getIconString('refreshBottom'),
                      onPressed: () => cl.refresh(),
                    ),
                    Text('REFRESH', style: kFooterIconText),
                  ],
                ),
              ),
              // REVOLT
              Expanded(
                child: Column(
                  children: [
                    FlatButton(
                      child: getIconString('revolt'),
                      onPressed: () => Get.to(RevoltScreen()),
                    ),
                    Text('REVOLT', style: kFooterIconText),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: kHr,
          height: 20.0,
          thickness: 2.0,
          indent: 130.0,
          endIndent: 130.0,
        ),
      ],
    ),
  );
}
