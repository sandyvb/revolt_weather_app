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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('NEW CITY',
                              style: kLighterBlueText.copyWith(
                                fontSize: 11.0,
                              ))),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('FORECAST',
                              style: kLighterBlueText.copyWith(
                                fontSize: 11.0,
                              ))),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('GLANCE',
                              style: kLighterBlueText.copyWith(
                                fontSize: 11.0,
                              ))),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('REFRESH',
                              style: kLighterBlueText.copyWith(
                                fontSize: 11.0,
                              ))),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('REVOLT',
                              style: kLighterBlueText.copyWith(
                                fontSize: 11.0,
                              ))),
                    ),
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
