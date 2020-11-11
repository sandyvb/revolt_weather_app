import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/gradientDivider.dart';
import 'package:revolt_weather_app/components/progress_bar.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_minutely.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/revolt_screen.dart';
import 'package:revolt_weather_app/services/sliders.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'footer.dart';

class GetMinutely extends StatelessWidget {
  final ControllerMinutely cm = Get.put(ControllerMinutely());
  final Controller c = Get.find();
  final ControllerForecast cf = Get.find();
  final ControllerUpdate cu = Get.find();

  final ScrollController _scrollController = ScrollController();

  // LOOP THROUGH MINUTELY & EXTRACT DATA \\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  Future<Column> _getData() async {
    String _progressBarHeader;
    try {
      if (cf.minutely[0]['precipitation'] >= 0) _progressBarHeader = 'PRECIPITATION';
    } catch (e) {
      _progressBarHeader = 'NO DATA AVAILABLE';
    }
    return Column(
      children: [
        Text(_progressBarHeader, style: TextStyle(fontSize: 12.0, letterSpacing: 0.7)),
        Obx(() => ProgressBar().getSpotlight(type: 'minutely')),
        gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0)),
        // INITIAL CITY TIME AND PRECIP
        if (_progressBarHeader == 'PRECIPITATION')
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${cu.initialCity.value.toUpperCase()} TIME',
                  style: kTimePrecipHeadings,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('PRECIPITATION', style: kTimePrecipHeadings),
              ],
            ),
          ),
        if (_progressBarHeader == 'PRECIPITATION') gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0)),
        _progressBarHeader == 'PRECIPITATION'
            ? ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: 61,
                itemBuilder: (BuildContext context, int i) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(cm.getTime(i), style: kOxygenWhite),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 8.0, right: 25.0),
                                  child: Obx(() => cm.getIcon(i)),
                                ),
                                Obx(() => cm.getPrecip(i)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0)),
                    ],
                  );
                },
              )
            : Column(
                children: [
                  Container(
                    width: Get.width * 0.8,
                    child: Text(
                      'OOPS!  NO DATA IS AVAILABLE FOR THIS REMOTE LOCATION',
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  gradientDivider(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0)),
                ],
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<Column>(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot<Column> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                children: [
                  loadingSpinner(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: Text('Retrieving Data...', style: TextStyle(fontSize: 20.0)),
                  ),
                ],
              );
            } else {
              if (snapshot.hasError) {
                return Column(children: [Text('Error: ${snapshot.error}')]);
              } else
                return snapshot.data;
            }
          },
        ),
        // REVOLT POWER
        GestureDetector(
          onTap: () => Get.to(RevoltScreen()),
          child: Container(
            padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
            margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
            child: Row(
              children: [
                ImageIcon(AssetImage('images/greenBolt.webp'), size: 50.0, color: kSwitchColor),
                SizedBox(width: 20.0),
                Flexible(
                  child: Obx(() => Text(
                        '${cf.revoltText.value} Tap here for more information!',
                        maxLines: 5,
                      )),
                ),
              ],
            ),
          ),
        ),
        footer(),
      ],
    );
  }
}
