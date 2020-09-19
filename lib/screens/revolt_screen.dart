import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/buy_screen.dart';
import 'package:revolt_weather_app/services/networking.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'package:revolt_weather_app/screens/city_screen.dart';

// TODO: ADD BUY BUTTON

class RevoltScreen extends StatefulWidget {
  @override
  _RevoltScreenState createState() => _RevoltScreenState();
}

class _RevoltScreenState extends State<RevoltScreen> {
  final Controller c = Get.find();
  final ControllerUpdate cc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      // BACKGROUND GRADIENT / BODY
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          gradient: LinearGradient(
            colors: [
              Color(0xFF37394B),
              Color(0xFF292B38),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // HEADER
            Container(
              padding: EdgeInsets.fromLTRB(0, 35.0, 0, 25.0),
              decoration: BoxDecoration(
                color: kTopColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
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
              // BODY
              child: Column(
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // BACK BUTTON
                      FlatButton(
                        onPressed: () => Get.back(),
                        child: getIconString('back'),
                      ),
                      // PAGE TITLE
                      Padding(
                        padding: const EdgeInsets.only(right: 35.0),
                        child: Text('Revolt Wind', style: kGreetingText),
                      ),
                      // SWITCH UNITS
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // OBX SWITCH
                            Obx(
                              () => Switch(
                                activeColor: kActiveColor,
                                value: c.isMetric.value,
                                onChanged: (value) async {
                                  c.isMetric.value = value;
                                  c.updateUnits();
                                  await WeatherModel().getCityWeather();
                                },
                              ),
                            ),
                            // SWITCH LABEL
                            Text('C°'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // CITY NAME BOX / GET NEW CITY ICON
                  Container(
                    margin: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    // MARKER ICON / CURRENT CITY / LAST UPDATED / NEW CITY BUTTON
                    child: Row(
                      children: [
                        // MARKER ICON
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: getIconString('location'),
                          ),
                          flex: 1,
                        ),
                        // CURRENT CITY NAME / LAST UPDATED
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            // CURRENT CITY NAME / LAST UPDATED
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // CURRENT CITY
                                Text(
                                  '${cc.city.value.toUpperCase()}${cc.country.value}',
                                  style: TextStyle(
                                    color: Color(0xFF4C547B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                // LAST UPDATED
                                Text(
                                  'Last updated: ${cc.lastUpdate.value}',
                                  style: TextStyle(color: Color(0xFF4C547B)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // NEW CITY BUTTON
                        Expanded(
                          flex: 1,
                          child: FlatButton(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: getIconString('add'),
                            onPressed: () {
                              c.prevScreen.value = 'revoltScreen';
                              Get.to(CityScreen());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // BEGIN SCROLL VIEW
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  // REVOLT CONTAINER
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                    child: Row(
                      children: [
                        ImageIcon(AssetImage('images/greenBolt.png'), size: 50.0),
                        SizedBox(width: 20.0),
                        // REVOLT TEXT
                        Flexible(
                            child: Text(
                          '${cc.revoltScreenText.value}',
                          style: TextStyle(fontSize: 15.0, height: 1.5),
                          textAlign: TextAlign.justify,
                        )),
                      ],
                    ),
                  ),
                  // REVOLT BUTTON TO WEBSITE
                  IconButton(
                      icon: Image.asset('images/rwBoltR.png'),
                      padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                      splashColor: Colors.green[600],
                      splashRadius: 100.0,
                      iconSize: 75.0,
                      onPressed: () {
                        NetworkHelper('https://revoltwind.com').openBrowserTab();
                      }),
                  // BUY NOW / DETAILS BUTTONS
                  Row(
                    children: [
                      // BUY NOW
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: RaisedButton(
                            color: Color(0xFF5C47E0),
                            child: Text('BUY NOW'),
                            onPressed: () => {
                              c.buyOrView.value = 'buy',
                              Get.to(BuyScreen()),
                            },
                          ),
                        ),
                      ),
                      // DETAILS BUTTON
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: RaisedButton(
                            color: Color(0xFF5C47E0),
                            child: Text('DETAILS'),
                            onPressed: () => {
                              c.buyOrView.value = 'view',
                              Get.to(BuyScreen()),
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // GIF
                  Container(
                    width: 300.0,
                    height: 300.0,
                    margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      image: DecorationImage(
                        image: AssetImage('images/gallery2-1.gif'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // DESCRIPTION OF REVOLT WIND
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                    child: Text(
                      'The REVOLT wind turbine hangs from an overhead support such as a line strung between two points, a hook, bracket, or tree branch. It requires no tower, no permit, no real estate, no footers, and no guy wires making it inexpensive, fast and easy to set up.',
                      style: kRevoltText,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                    child: Text(
                      'The hanging design was born to allow windmills to be deployed in areas where towers are not permitted. It can be built in a range of sizes using the same blades and electric generator that are used on tower mounted windmills, but at a fraction of the cost. Because the device is not anchored to the ground by the tower, you can own it without owning the land beneath it and take it with you wherever you go.',
                      style: kRevoltText,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                    child: Text(
                      'On a planet where about three billion people do not have access to the electric grid, inexpensive, mass-produced REVOLT windmills will literally change the quality of life for millions by making electricity available and accessible to nearly anyone who needs convenient, remote, or portable electricity.',
                      style: kRevoltText,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                    child: Text(
                      'The mission of REVOLT wind, is to bring revolutionary wind-driven machines into mass-production so that they can be used to help solve today’s energy production and pollution problems while improving the lifestyle of people worldwide.',
                      style: kRevoltText,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  // BUY NOW / DETAILS BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // BUY NOW
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: RaisedButton(
                            color: Color(0xFF5C47E0),
                            child: Text('BUY NOW'),
                            onPressed: () => {
                              c.buyOrView.value = 'buy',
                              Get.to(BuyScreen()),
                            },
                          ),
                        ),
                      ),
                      // DETAILS BUTTON
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: RaisedButton(
                            color: Color(0xFF5C47E0),
                            child: Text('DETAILS'),
                            onPressed: () => {
                              c.buyOrView.value = 'view',
                              Get.to(BuyScreen()),
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // REVOLT LOGO TO WEBSITE
                  IconButton(
                      icon: Image.asset('images/rwBoltR.png'),
                      padding: EdgeInsets.fromLTRB(0, 10.0, 0, 30.0),
                      splashColor: Colors.green[600],
                      splashRadius: 100.0,
                      iconSize: 75.0,
                      onPressed: () {
                        NetworkHelper('https://revoltwind.com').openBrowserTab();
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
