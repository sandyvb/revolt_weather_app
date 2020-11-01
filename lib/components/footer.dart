import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/screens/city_screen.dart';
import 'package:revolt_weather_app/screens/forecast_screen.dart';
import 'package:revolt_weather_app/screens/glance_screen.dart';
import 'package:revolt_weather_app/screens/location_screen.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'get_icon.dart';

final Controller c = Get.find();

Container footer() {
  return Container(
    margin: EdgeInsets.only(top: 10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
      gradient: kBlueGradientFooter,
      boxShadow: kBoxShadowUp,
    ),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // HOME
              Expanded(
                child: Column(
                  children: [
                    IconButton(icon: getIconString('home'), onPressed: () => Get.offAll(LocationScreen())),
                    Text('HOME', style: kLighterBlueText.copyWith(fontSize: 11.0)),
                  ],
                ),
              ),
              // FORECAST
              Expanded(
                child: Column(
                  children: [
                    IconButton(icon: getIconString('forecast'), onPressed: () => Get.to(ForecastScreen())),
                    Text('FORECAST', style: kLighterBlueText.copyWith(fontSize: 11.0)),
                  ],
                ),
              ),
              // GLANCE
              Expanded(
                child: Column(
                  children: [
                    IconButton(icon: getIconString('glance'), onPressed: () => Get.to(GlanceScreen())),
                    Text('GLANCE', style: kLighterBlueText.copyWith(fontSize: 11.0)),
                  ],
                ),
              ),
              // REVOLT
              Expanded(
                child: Column(
                  children: [
                    FlatButton(child: getIconString('revolt'), onPressed: () => Get.to(RevoltScreen())),
                    Text('REVOLT', style: kLighterBlueText.copyWith(fontSize: 11.0)),
                  ],
                ),
              ),
              // NEW CITY
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: getIconString('city'),
                      onPressed: () => Get.to(CityScreen()),
                    ),
                    Text('NEW CITY', style: kLighterBlueText.copyWith(fontSize: 11.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
        gradientDividerTransparentEnds(padding: EdgeInsets.all(10.0)),
      ],
    ),
  );
}
