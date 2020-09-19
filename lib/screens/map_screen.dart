import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/map_component.dart';
import 'package:revolt_weather_app/controllers/controller.dart';

// https://pub.dev/packages/flutter_map

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Controller c = Get.find();

  @override
  void initState() {
    super.initState();
    c.fullscreen.value = true;
  }

  @override
  void dispose() {
    c.fullscreen.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MapComponent(),
    );
  }
}
