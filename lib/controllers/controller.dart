import 'dart:async';
import 'package:get/get.dart';
import 'package:revolt_weather_app/services/current_time.dart';

// GLOBAL VALUES USED THROUGHOUT APP
class Controller extends GetxController {
  var isMetric = false.obs;
  var altitude = 0.0.obs; // in meters
  var altitudeUnits = 'ft'.obs;
  var speedUnits = 'mph'.obs;
  var temperatureUnits = '°F'.obs;
  var distanceUnits = 'miles'.obs;
  var precipUnits = 'in'.obs;
  var theTime = CurrentTime().getTime().obs;
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

  // TIMER KEEPS CURRENT TIME
  Timer _timer;

  void startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 2),
      (Timer t) {
        var current = CurrentTime().getTime();
        theTime.value = current;
      },
    );
  }

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  @override
  void onClose() {
    _timer.cancel();
    print('cf stop timer');
    super.onClose();
  }
}
