import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/screens/loading_screen.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //transparent status bar
    ));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Revolt Wind Weather App',
      theme: ThemeData.dark().copyWith(
        accentColor: kLighterBlue,
        dividerColor: Colors.transparent,
        iconTheme: IconThemeData(size: 30.0, color: kLighterBlue),
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
