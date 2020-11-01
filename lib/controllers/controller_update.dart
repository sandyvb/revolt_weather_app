import 'package:get/get.dart';

class ControllerUpdate extends GetxController {
  var city = 'home'.obs;
  var initialCity = 'my city'.obs;
  var country = 'anywhere but here'.obs;
  var userInputLat = 0.0.obs;
  var userInputLon = 0.0.obs;
  var lat = 0.0.obs;
  var lon = 0.0.obs;

  Future<void> updateData(dynamic weatherData) async {
    // UPDATE LOCATION VARIABLES FROM WEATHER.DART //////////////////////////////////////////
    city.value = weatherData['name'];
    if (city.value.isNullOrBlank) city.value = 'SOMEWHERE AT\nlat: ${lat.value.toStringAsFixed(2)}, lon: ${lon.value.toStringAsFixed(2)}';
    var _getCountry = weatherData['sys']['country'];
    country.value = _getCountry == 'US'
        ? ''
        : _getCountry == null
            ? ''
            : ', $_getCountry';
    lon.value = weatherData['coord']['lon'].toDouble();
    lat.value = weatherData['coord']['lat'].toDouble();
  }
}
