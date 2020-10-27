import 'package:get/get.dart';

// GLOBAL VALUES USED THROUGHOUT APP
class Controller extends GetxController {
  var isMetric = false.obs;
  var altitude = 0.0.obs; // in meters
  var altitudeUnits = 'ft'.obs;
  var isUnknown = false.obs;
  var speedUnits = 'mph'.obs;
  var temperatureUnits = '°F'.obs;
  var distanceUnits = 'miles'.obs;
  var precipUnits = 'in'.obs;
  var prevScreen = 'location'.obs;
  // MIN / MAX VALUES FOR TEMPERATURE SLIDERS
  var min = (-50.0).obs;
  var max = 200.0.obs;

  // CHANGE UNITS FROM IMPERIAL TO METRIC AND BACK
  Future<void> updateUnits() async {
    if (isMetric.value) {
      min.value = (-45.5556);
      max.value = 93.3333;
      speedUnits.value = 'm/s';
      temperatureUnits.value = '°C';
      distanceUnits.value = 'km';
      altitudeUnits.value = 'm';
      precipUnits.value = 'mm';
    } else {
      min.value = (-50.0);
      max.value = 200.0;
      speedUnits.value = 'mph';
      temperatureUnits.value = '°F';
      distanceUnits.value = 'miles';
      altitudeUnits.value = 'ft';
      precipUnits.value = 'in';
    }
  }
}
