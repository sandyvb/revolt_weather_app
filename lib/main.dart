import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/screens/loading_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Controller c = Get.put(Controller());
  final ControllerUpdate cc = Get.put(ControllerUpdate());
  final ControllerForecast cf = Get.put(ControllerForecast());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //transparent status bar
    ));
    return GetMaterialApp(
      title: 'Revolt Wind Weather App',
      theme: ThemeData.dark().copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'RedHat',
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        cardColor: Color(0xFF3B3C4E).withOpacity(0.8),
      ),
      home: LoadingScreen(),
    );
  }
}
