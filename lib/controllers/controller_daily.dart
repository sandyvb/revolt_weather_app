import 'package:get/get.dart';
import 'package:revolt_weather_app/controllers/controller_forecast.dart';
import 'controller.dart';

class ControllerDaily extends GetxController {
  final ControllerForecast cf = Get.find();
  final Controller c = Get.find();

  String getGust(int i) {
    try {
      return ' - ${cf.daily[i]['wind_gust'].toInt()}';
    } catch (e) {
      return '';
    }
  }

  String rainOrSnow(int i, String timeOfDay) {
    if (timeOfDay == 'day' && c.isMetric.value == true) {
      return cf.daily[i]['temp']['max'] <= 0 ? 'snow' : 'rain';
    } else if (timeOfDay == 'day' && c.isMetric.value == false) {
      return cf.daily[i]['temp']['max'] <= 32 ? 'snow' : 'rain';
    } else if (timeOfDay == 'night' && c.isMetric.value == true) {
      return cf.daily[i]['temp']['min'] <= 0 ? 'snow' : 'rain';
    } else {
      return cf.daily[i]['temp']['min'] <= 32 ? 'snow' : 'rain';
    }
  }
}

// STORES EXPANSION PANEL STATE INFORMATION
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
    this.index,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
  int index;
}

// GENERATE LIST FOR EXPANSION PANEL
List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
      index: index,
    );
  });
}
