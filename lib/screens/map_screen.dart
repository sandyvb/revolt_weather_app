import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/map_component.dart';
import 'package:revolt_weather_app/controllers/controller_map.dart';

// https://pub.dev/packages/flutter_map

class MapScreen extends StatelessWidget {
  final ControllerMap cmap = Get.find();

  @override
  Widget build(BuildContext context) {
    cmap.fullscreen.value = true;
    return Container(
      child: MapComponent(),
    );
  }
}
