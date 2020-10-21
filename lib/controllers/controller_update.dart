import 'package:get/get.dart';

class ControllerUpdate extends GetxController {
  var city = 'home'.obs;
  var initialCity = 'my city'.obs;
  var country = 'anywhere but here'.obs;
  var userInput = 'userInput'.obs;
  var lat = 0.0.obs;
  var lon = 0.0.obs;

  void updateData(dynamic weatherData) async {
    // UPDATE LOCATION VARIABLES FROM WEATHER.DART //////////////////////////////////////////
    city.value = weatherData['name'];
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
