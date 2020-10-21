import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller_update.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// api https://console.cloud.google.com/

class CityMapComponent extends StatefulWidget {
  @override
  _CityMapComponentState createState() => _CityMapComponentState();
}

class _CityMapComponentState extends State<CityMapComponent> {
  final ControllerUpdate cu = Get.find();

  List<Marker> markers = [];

  // SET INITIAL MARKER TO CURRENTLY CHOSEN LOCATION
  @override
  void initState() {
    markers.add(Marker(
      markerId: MarkerId((LatLng(cu.lat.value, cu.lon.value)).toString()),
      position: LatLng(cu.lat.value, cu.lon.value),
    ));
    super.initState();
  }

  _handleTap(latLng) {
    setState(() {
      markers = [];
      markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
        ),
      );
    });
    cu.userInput.value = 'lat=${latLng.latitude}&lon=${latLng.longitude}';
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(cu.lat.value, cu.lon.value),
        zoom: 10.0,
      ),
      markers: Set.from(markers),
      onTap: _handleTap,
    );
  }
}
