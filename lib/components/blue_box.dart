import 'package:flutter/material.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

Widget smBlueBox({dynamic child}) {
  return Expanded(
    child: Container(
      height: 65.0,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        boxShadow: kBoxShadowDD,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xFF709EFE),
            Color(0xFF5C47E0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.clamp,
        ),
      ),
      child: child,
    ),
  );
}

Widget blueBox({dynamic child, dynamic margin}) {
  return Expanded(
    child: Container(
      margin: margin,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xFF709EFE),
            Color(0xFF5C47E0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.clamp,
        ),
      ),
      child: child,
    ),
  );
}
