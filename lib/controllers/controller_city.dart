import 'package:get/get.dart';
import 'package:revolt_weather_app/screens/forecast_screen.dart';
import 'package:revolt_weather_app/screens/glance_screen.dart';
import 'package:revolt_weather_app/screens/location_screen.dart';
import 'package:revolt_weather_app/services/networking.dart';
import 'package:revolt_weather_app/services/weather.dart';
import 'controller.dart';
import 'controller_update.dart';

class ControllerCityScreen extends GetxController {
  final Controller c = Get.find();
  final ControllerUpdate cu = Get.find();
  final optionList = <dynamic>[].obs;

  Future<void> findCity() async {
    String url = 'https://revoltwind.com/data/city.list.json';
    NetworkHelper networkHelper = NetworkHelper(url);
    var cityList = await networkHelper.getData();
    print(cityList[0]);
    // String userInput = cu.userInput.value.toLowerCase();
    // optionList.value = cityList.where((elem) => elem['name'].toString().toLowerCase().contains(userInput)).toList();

    // return Container(
    //   height: 100,
    //   child: ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: cityList.length,
    //     itemBuilder: (con, ind) {
    //       return ListTile(
    //         title: Text(cityData[ind]['name']),
    //         subtitle: Text(results[ind]['country']),
    //         onTap: () async {
    //           cu.userInput.value = results[ind]['id'].toString();
    //           changeCity();
    //         },
    //       );
    //     },
    //   ),
    // );
  }
}
