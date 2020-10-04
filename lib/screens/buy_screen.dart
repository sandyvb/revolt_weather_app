import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller_buy.dart';
import 'package:revolt_weather_app/controllers/controller_revolt.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// https://medium.com/@zeyadelosherey/the-complete-webview-in-flutter-d562b40c3260

class BuyScreen extends StatelessWidget {
  final ControllerBuy cb = Get.put(ControllerBuy());
  final ControllerRevolt cr = Get.find();

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: cr.url.value,
      withJavascript: true,
      withZoom: false,
      hidden: true,
      // USE DOCS ABOUT APP BAR TO PUT ALL THE BUTTONS HERE MAYBE ZOOM? OR SET ZOOM: TRUE?
      appBar: AppBar(
        title: Text("The RW-X Hanging Wind Turbine"),
        toolbarHeight: 100.0,
        elevation: 1,
        backgroundColor: Color(0xFF5C47E0),
      ),
      // IF NO INITIAL CHILD PRESENT - APP DEFAULTS TO SPINNER
      initialChild: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          gradient: LinearGradient(
            colors: [
              Color(0xFF37394B),
              Color(0xFF292B38),
              Color(0xFF222536),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: SleekCircularSlider(
            appearance: CircularSliderAppearance(
              spinnerMode: true,
              size: 110.0,
              customColors: CustomSliderColors(
                dotColor: Color(0x00000000),
                hideShadow: true,
              ),
              customWidths: CustomSliderWidths(
                trackWidth: 4.5,
                progressBarWidth: 4.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
