import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/buy_screen.dart';
import 'package:revolt_weather_app/services/networking.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class ControllerRevolt extends GetxController {
  final ControllerUpdate cu = Get.find();

  // FOR THE RW-X TURBINE
  final String viewUrl = 'https://www.fatfreecartpro.com/i/z3z7?card';
  final String buyUrl = 'https://www.fatfreecartpro.com/i/z3z7?cc';
  var url = 'url'.obs;

  // GIF - CONTAINER AND STYLING
  Container windmillGif() {
    return Container(
      width: 300.0,
      height: 300.0,
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: FadeInImage(
          imageSemanticLabel: 'The REVOLT Hanging Wind Turbine',
          fit: BoxFit.fill,
          image: NetworkImage('https://revoltwind.com/images/buy/gallery2-1.webp'),
          placeholder: AssetImage('images/galleryLoad.webp'),
        ),
      ),
    );
  }

  // FORMAT PARAGRAPHS ON REVOLT SCREEN
  Padding paragraph(String paragraph) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Text(paragraph, style: kRevoltText, textAlign: TextAlign.justify),
    );
  }

  // GO TO REVOLTWIND.COM
  IconButton goToWebsite() {
    return IconButton(
      icon: Image.asset('images/rwBoltR.webp'),
      padding: EdgeInsets.fromLTRB(0, 5.0, 0, 25.0),
      splashColor: Colors.green[600],
      splashRadius: 100.0,
      iconSize: 75.0,
      onPressed: () {
        NetworkHelper('https://revoltwind.com').openBrowserTab();
      },
    );
  }

  // REUSABLE BUTTON TO GO TO EJUNKIE BUY OR EJUNKIE DETAIL CARD
  Expanded buyOrViewBtn(String buyView) {
    String title = buyView == 'buy' ? 'BUY NOW' : 'DETAILS';
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          color: Color(0xFF5C47E0),
          child: Text('$title'),
          onPressed: () => {
            url.value = buyView == 'buy' ? buyUrl : viewUrl,
            Get.to(BuyScreen()),
          },
        ),
      ),
    );
  }

  // BUY & VIEW BUTTON ROW
  Row buyOrViewBtnRow() {
    return Row(
      children: [
        buyOrViewBtn('buy'),
        // DETAILS BUTTON
        buyOrViewBtn('view'),
      ],
    );
  }
}
