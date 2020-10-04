import 'package:flutter/material.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

Widget gradientDivider({dynamic padding}) {
  return Padding(
    padding: padding,
    child: SizedBox(
      height: 2.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kHr, Color(0xFF5988F9), kHr],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    ),
  );
}

Widget gradientDividerTransparentEnds({dynamic padding}) {
  return Padding(
    padding: padding,
    child: SizedBox(
      height: 2.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // colors: [Colors.transparent, Color(0xFF5988F9), Colors.transparent],
            colors: [Colors.transparent, Colors.white54, Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    ),
  );
}
