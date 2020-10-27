import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class MapComponent extends StatelessWidget {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final ControllerMap cmap = Get.put(ControllerMap());
  final ControllerForecast cf = Get.find();

  final String _mapURL = 'https://tile.openweathermap.org/map';
  // final String _rainViewerMapURL = 'https://tilecache.rainviewer.com/v2';

  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BUTTON CONTROLS
      appBar: AppBar(
        leading: InkWell(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Obx(() => getIconString('wind', color: cmap.mapLayer.value == 'wind' ? Colors.white : kLighterBlue)),
          ),
          onTap: () {
            cmap.getSnackbar();
            cmap.mapLayer.value = 'wind';
            cmap.updateLegend();
          },
        ),
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(75.0, 0.0, 20.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // TEMPERATURE
                  InkWell(
                    child: Obx(() => getIconString('thermometer', color: cmap.mapLayer.value == 'temp' ? Colors.white : kLighterBlue)),
                    onTap: () {
                      cmap.getSnackbar();
                      cmap.mapLayer.value = 'temp';
                      cmap.updateLegend();
                    },
                  ),
                  // PRECIPITATION
                  InkWell(
                    child: Obx(() => getIconInt(501, color: cmap.mapLayer.value == 'precipitation' ? Colors.white : kLighterBlue)),
                    onTap: () {
                      cmap.getSnackbar();
                      cmap.mapLayer.value = 'precipitation';
                      cmap.updateLegend();
                    },
                  ),
                  // CLOUDS
                  InkWell(
                    child: Obx(() => getIconInt(802, color: cmap.mapLayer.value == 'clouds' ? Colors.white : kLighterBlue)),
                    onTap: () {
                      cmap.getSnackbar();
                      cmap.mapLayer.value = 'clouds';
                      cmap.updateLegend();
                    },
                  ),
                  // PRESSURE
                  InkWell(
                    child: Obx(() => getIconString('pressure', color: cmap.mapLayer.value == 'pressure' ? Colors.white : kLighterBlue)),
                    onTap: () {
                      cmap.getSnackbar();
                      cmap.mapLayer.value = 'pressure';
                      cmap.updateLegend();
                    },
                  ),
                  // SNOW
                  InkWell(
                    child: Obx(() => getIconString('cold', color: cmap.mapLayer.value == 'snow' ? Colors.white : kLighterBlue)),
                    onTap: () {
                      cmap.getSnackbar();
                      cmap.mapLayer.value = 'snow';
                      cmap.updateLegend();
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
              controller: _mapController,
              center: latLng.LatLng(cu.lat.value, cu.lon.value),
              zoom: 7.0,
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
                  urlTemplate: '$_mapURL/${cmap.mapLayer.value}/{z}/{x}/{y}.png?appid=$apiKey',
                  subdomains: ['a', 'b', 'c'],
                  opacity: 0.5,
                ),
              ),

              // RAIN VIEWER TILE - https://www.rainviewer.com/api.html?ref=public-apis
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
                            cmap.min.value,
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
                                colors: cmap.updateLegend(),
                                stops: cmap.updateLegendStops(),
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
                            cmap.max.value,
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
                        cmap.legendText.value,
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
                child: cmap.fullscreen.value
                    ? getIconString(
                        'fullscreenExit',
                        color: Colors.white,
                      )
                    : getIconString(
                        'fullscreen',
                        color: Colors.white,
                      ),
                onTap: () {
                  if (cmap.fullscreen.value) {
                    cmap.fullscreen.value = false;
                    Get.back();
                  } else {
                    cmap.fullscreen.value = true;
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
