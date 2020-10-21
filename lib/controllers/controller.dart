import 'package:get/get.dart';

// GLOBAL VALUES USED THROUGHOUT APP
class Controller extends GetxController {
  var isMetric = false.obs;
  var altitude = 0.0.obs; // in meters
  var altitudeUnits = 'ft'.obs;
  var speedUnits = 'mph'.obs;
  var temperatureUnits = '°F'.obs;
  var distanceUnits = 'miles'.obs;
  var precipUnits = 'in'.obs;
  var prevScreen = 'location'.obs;

  // CHANGE UNITS FROM IMPERIAL TO METRIC AND BACK \\\\\\\\\\\\\\\\\\\\\\
  void updateUnits() async {
    if (isMetric.value) {
      speedUnits.value = 'm/s';
      temperatureUnits.value = '°C';
      distanceUnits.value = 'km';
      altitudeUnits.value = 'm';
      precipUnits.value = 'mm';
    } else {
      speedUnits.value = 'mph';
      temperatureUnits.value = '°F';
      distanceUnits.value = 'miles';
      altitudeUnits.value = 'ft';
      precipUnits.value = 'in';
    }
  }
}
