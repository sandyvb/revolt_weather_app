import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/components/get_icon.dart';
import 'package:revolt_weather_app/controllers/controller.dart';
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
  final ControllerUpdate cc = Get.find();

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
                    child: getIconString('wind'),
                    onTap: () {
                      c.mapLayer.value = 'wind';
                    },
                  ),
                  // TEMPERATURE
                  InkWell(
                    child: getIconString('thermometer'),
                    onTap: () {
                      c.mapLayer.value = 'temp';
                    },
                  ),
                  // PRECIPITATION
                  InkWell(
                    child: getIconInt(501),
                    onTap: () {
                      c.mapLayer.value = 'precipitation';
                    },
                  ),
                  // CLOUDS
                  InkWell(
                    child: getIconInt(802),
                    onTap: () {
                      c.mapLayer.value = 'clouds';
                    },
                  ),
                  // PRESSURE
                  InkWell(
                    child: getIconString('pressure'),
                    onTap: () {
                      c.mapLayer.value = 'pressure';
                    },
                  ),
                  // SNOW
                  InkWell(
                    child: getIconString('cold'),
                    onTap: () {
                      c.mapLayer.value = 'snow';
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
        child: FlutterMap(
          options: MapOptions(
            center: latLng.LatLng(cc.lat.value, cc.lon.value),
            zoom: 12.0,
          ),
          layers: [
            // MAP LAYER OPTIONS
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 50.0,
                  height: 50.0,
                  point: latLng.LatLng(cc.lat.value, cc.lon.value),
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
            Obx(
              () => TileLayerWidget(
                options: TileLayerOptions(
                  urlTemplate: '$_mapURL/${c.mapLayer.value}/{z}/{x}/{y}.png?appid=$apiKey',
                  subdomains: ['a', 'b', 'c'],
                  opacity: 0.4,
                ),
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
                        child: Obx(
                          () => Text(
                            c.min.value,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // LEGEND
                      Expanded(
                        child: Obx(
                          () => Container(
                            height: 8.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              gradient: LinearGradient(
                                colors: c.updateLegend(),
                                stops: c.updateLegendStops(),
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
                      ),
                      // MAX VALUE
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Obx(
                          () => Text(
                            c.max.value,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // LEGEND DATA AT BOTTOM
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Obx(
                          () => Text(
                            c.updateLegendData(),
                            style: kUpdateLegendText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // OWM LEGEND
          ],
        ),
      ),
      // FULL SCREEN / LAST UPDATED
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // FULL SCREEN /LAST UPDATED
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // FULL SCREEN
              InkWell(
                child: c.fullscreen.value ? getIconString('fullscreenExit') : getIconString('fullscreen'),
                onTap: () => c.fullscreen.value ? Get.back() : Get.to(MapScreen()),
              ),
              // LAST UPDATED
              Text('Last updated: ${cc.lastUpdate.value}'),
            ],
          ),
        ),
      ),
    );
  }
}
