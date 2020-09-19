import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:flutter/material.dart';

class RevoltContainer extends StatefulWidget {
  @override
  _RevoltContainerState createState() => _RevoltContainerState();
}

class _RevoltContainerState extends State<RevoltContainer> {
  final ControllerUpdate cc = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(RevoltScreen()),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Row(
          children: [
            ImageIcon(AssetImage('images/greenBolt.png'), size: 50.0),
            SizedBox(width: 20.0),
            Flexible(
                child: Text(
              '${cc.revoltText.value}',
              textAlign: TextAlign.justify,
            )),
          ],
        ),
      ),
    );
  }
}
