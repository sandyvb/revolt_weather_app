import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'package:revolt_weather_app/controllers/controller_map.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:revolt_weather_app/screens/map_screen.dart';
import 'package:latlong/latlong.dart' as latLng;
import 'package:revolt_weather_app/services/weather.dart';
import 'package:revolt_weather_app/utilities/constants.dart';

class MapComponent extends StatefulWidget {
  @override
  _MapComponentState createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerMap cm = Get.put(ControllerMap());
  final ControllerForecast cf = Get.find();

  String _mapURL = 'https://tile.openweathermap.org/map';
  // String _rainViewerMapURL = 'https://tilecache.rainviewer.com/v2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BUTTON CONTROLS
      appBar: AppBar(
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(75.0, 0.0, 20.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // WIND
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: getIconString('wind', color: Colors.white),
                    ),
                    onTap: () {
                      cm.mapLayer.value = 'wind';
                      cm.updateLegend();
                    },
                  ),
                  // TEMPERATURE
                  InkWell(
                    child: getIconString('thermometer', color: Colors.white),
                    onTap: () {
                      cm.mapLayer.value = 'temp';
                      cm.updateLegend();
                    },
                  ),
                  // PRECIPITATION
                  InkWell(
                    child: getIconInt(501, color: Colors.white),
                    onTap: () {
                      cm.mapLayer.value = 'precipitation';
                      cm.updateLegend();
                    },
                  ),
                  // CLOUDS
                  InkWell(
                    child: getIconInt(802, color: Colors.white),
                    onTap: () {
                      cm.mapLayer.value = 'clouds';
                      cm.updateLegend();
                    },
                  ),
                  // PRESSURE
                  InkWell(
                    child: getIconString('pressure', color: Colors.white),
                    onTap: () {
                      cm.mapLayer.value = 'pressure';
                      cm.updateLegend();
                    },
                  ),
                  // SNOW
                  InkWell(
                    child: getIconString('cold', color: Colors.white),
                    onTap: () {
                      cm.mapLayer.value = 'snow';
                      cm.updateLegend();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // MAP
      body: SafeArea(
        child: Obx(
          () => FlutterMap(
            options: MapOptions(
              center: latLng.LatLng(cu.lat.value, cu.lon.value),
              zoom: 12.0,
            ),
            layers: [
              // MAP LAYER OPTIONS
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 50.0,
                    height: 50.0,
                    point: latLng.LatLng(cu.lat.value, cu.lon.value),
                    builder: (ctx) => Container(
                      child: Icon(
                        Entypo.location_pin,
                        color: Colors.black,
                        size: 40.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            children: [
              // OPEN STREET MAP TILE
              TileLayerWidget(
                options: TileLayerOptions(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
              ),

              // OWM MAP TILES
              TileLayerWidget(
                options: TileLayerOptions(
                  urlTemplate: '$_mapURL/${cm.mapLayer.value}/{z}/{x}/{y}.png?appid=$apiKey',
                  subdomains: ['a', 'b', 'c'],
                  opacity: 0.4,
                ),
              ),

              // TODO: RAIN VIEWER TILE - https://www.rainviewer.com/api.html?ref=public-apis
              // TileLayerWidget(
              //   options: TileLayerOptions(
              //     urlTemplate: '$_rainViewerMapURL/coverage/0/256/{z}/{x}/{y}.png',
              //     subdomains: ['a', 'b', 'c'],
              //     tileSize: 20.0,
              //     opacity: 0.4,
              //   ),
              // ),
              // MIN / LEGEND / MAX
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // MIN / LEGEND / MAX
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // MIN VALUE
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            cm.min.value,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // LEGEND
                        Expanded(
                          child: Container(
                            height: 8.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              gradient: LinearGradient(
                                colors: cm.updateLegend(),
                                stops: cm.updateLegendStops(),
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                tileMode: TileMode.clamp,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 0.1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // MAX VALUE
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            cm.max.value,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // LEGEND DATA AT BOTTOM
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        cm.legendText.value,
                        style: kUpdateLegendText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // FULL SCREEN BUTTON / LAST UPDATED
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // FULL SCREEN BUTTON /LAST UPDATED
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // FULL SCREEN
              InkWell(
                child: cm.fullscreen.value
                    ? getIconString(
                        'fullscreenExit',
                        color: Colors.white,
                      )
                    : getIconString(
                        'fullscreen',
                        color: Colors.white,
                      ),
                onTap: () {
                  if (cm.fullscreen.value) {
                    cm.fullscreen.value = false;
                    Get.back();
                  } else {
                    cm.fullscreen.value = true;
                    Get.to(MapScreen());
                  }
                },
              ),
              // LAST UPDATED
              Obx(() => Text(
                    'Last updated: ${cf.lastUpdate.value}',
                    style: kOxygenWhite,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
