import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:revolt_weather_app/utilities/constants.dart';
import 'dart:math';

//AVAILABLE METHODS:
//selectedIconData	Icon is displayed when value is true
//unselectedIconData	Icon is displayed when value is false
//activeColor	When value is true, the icon color is displayed
//inactiveColor	When value is false, the icon color is displayed
//value	Whether this IconToggle is selected.
//onChanged	Called when the value of the IconToggle should change.
//duration	The duration of the transition from selected Icon to unselected Icon
//reverseDuration	he duration of the transition from unselected Icon to selected Icon
//transitionBuilder	Transition animation function between the selected Icon and the unselected Icon

// GET HOUR TO DETERMINE IF IT'S DAY OR NIGHT
var hour = DateTime.now().hour;

// RETURNS A GENERAL ICON GIVEN AN INT
Icon getIconInt(int code, [double size, Color color]) {
  if (code == 801) {
    return Icon(WeatherIcons.wi_cloud, size: size, color: color);
  } else if (code >= 802 && code <= 804) {
    return Icon(WeatherIcons.wi_cloudy, size: size, color: color);
  } else if (code == 800 && hour < 5 && hour > 21) {
    return Icon(WeatherIcons.wi_night_clear, size: size, color: color);
  } else if (code == 800) {
    return Icon(WeatherIcons.wi_day_sunny, size: size, color: color);
  } else if (code == 701) {
    return Icon(WeatherIcons.wi_sprinkle, size: size, color: color);
  } else if (code == 711) {
    return Icon(WeatherIcons.wi_smoke, size: size, color: color);
  } else if (code == 721) {
    return Icon(WeatherIcons.wi_day_haze, size: size, color: color);
  } else if (code == 731) {
    return Icon(WeatherIcons.wi_sandstorm, size: size, color: color);
  } else if (code == 741) {
    return Icon(WeatherIcons.wi_fog, size: size, color: color);
  } else if (code == 751) {
    return Icon(WeatherIcons.wi_sandstorm, size: size, color: color);
  } else if (code == 761) {
    return Icon(WeatherIcons.wi_dust, size: size, color: color);
  } else if (code == 762) {
    return Icon(WeatherIcons.wi_volcano, size: size, color: color);
  } else if (code == 771) {
    return Icon(WeatherIcons.wi_cloudy_gusts, size: size, color: color);
  } else if (code == 781) {
    return Icon(WeatherIcons.wi_tornado, size: size, color: color);
  } else if (code >= 600 && code <= 602) {
    return Icon(WeatherIcons.wi_snow, size: size, color: color);
  } else if (code >= 611 && code <= 613) {
    return Icon(WeatherIcons.wi_sleet, size: size, color: color);
  } else if (code >= 615 && code <= 622) {
    return Icon(WeatherIcons.wi_rain_mix, size: size, color: color);
  } else if (code == 500 || code == 520) {
    return Icon(WeatherIcons.wi_sprinkle, size: size, color: color);
  } else if (code >= 501 && code <= 504) {
    return Icon(WeatherIcons.wi_rain, size: size, color: color);
  } else if (code == 511) {
    return Icon(WeatherIcons.wi_sleet, size: size, color: color);
  } else if (code >= 521 && code <= 531) {
    return Icon(WeatherIcons.wi_showers, size: size, color: color);
  } else if (code >= 300 && code <= 321) {
    return Icon(WeatherIcons.wi_sprinkle, size: size, color: color);
  } else if (code == 200 || code == 201 || code == 230 || code == 231 || code == 232) {
    return Icon(WeatherIcons.wi_storm_showers, size: size, color: color);
  } else if (code == 202) {
    return Icon(WeatherIcons.wi_thunderstorm, size: size, color: color);
  } else if (code == 210 || code == 211 || code == 212 || code == 221) {
    return Icon(WeatherIcons.wi_lightning, size: size, color: color);
  } else {
    return Icon(WeatherIcons.wi_na, size: size, color: color);
  }
}

// RETURNS AN ICON GIVEN A STRING
Widget getIconString(String code, [double size, Color color]) {
  if (code == 'location') {
    return Icon(
      Entypo.location_pin,
      color: Color(0xFF697EF5),
      size: 30.0,
    );
  } else if (code == 'add') {
    return Icon(
      Entypo.plus,
      color: Color(0xFF697EF5),
      size: 30.0,
    );
  } else if (code == 'city') {
    return Icon(
      MaterialCommunityIcons.city_variant_outline,
      color: kLighterBlue,
      size: size,
    );
  } else if (code == 'question') {
    return Icon(
      MaterialCommunityIcons.map_marker_question_outline,
      color: Colors.red,
      size: 40.0,
    );
  } else if (code == 'fullscreen') {
    return Icon(MaterialIcons.fullscreen, size: size, color: color);
  } else if (code == 'home') {
    return Icon(Feather.home, size: size, color: color);
  } else if (code == 'fullscreenExit') {
    return Icon(MaterialIcons.fullscreen_exit, size: size, color: color);
  } else if (code == 'forecast') {
    return Icon(
      Foundation.graph_bar,
      color: kLighterBlue,
      size: 27.0,
    );
  } else if (code == 'visibility') {
    return Icon(MaterialIcons.visibility, size: size, color: color);
  } else if (code == 'thermometer') {
    return Icon(WeatherIcons.wi_thermometer, size: size, color: color);
  } else if (code == 'wind') {
    return Icon(Feather.wind, size: size, color: color);
  } else if (code == 'sunrise') {
    return Icon(WeatherIcons.wi_sunrise, size: size, color: color);
  } else if (code == 'sunset') {
    return Icon(WeatherIcons.wi_sunset, size: size, color: color);
  } else if (code == 'horizon') {
    return Icon(WeatherIcons.wi_horizon, size: size, color: color);
  } else if (code == 'horizonAlt') {
    return Icon(WeatherIcons.wi_horizon_alt, size: size, color: color);
  } else if (code == 'pressure') {
    return Icon(WeatherIcons.wi_barometer, size: size, color: color);
  } else if (code == 'humidity') {
    return Icon(WeatherIcons.wi_humidity, size: size, color: color);
  } else if (code == 'raindrop') {
    return Icon(WeatherIcons.wi_raindrop, size: size, color: color);
  } else if (code == 'raindrops') {
    return Icon(WeatherIcons.wi_raindrops, size: size, color: color);
  } else if (code == 'hurricane') {
    return Icon(WeatherIcons.wi_hurricane, size: size, color: color);
  } else if (code == 'smog') {
    return Icon(WeatherIcons.wi_smog, size: size, color: color);
  } else if (code == 'fire') {
    return Icon(WeatherIcons.wi_fire, size: size, color: color);
  } else if (code == 'na') {
    return Icon(WeatherIcons.wi_na, size: size, color: color);
  } else if (code == 'hot') {
    return Icon(WeatherIcons.wi_hot, size: size, color: color);
  } else if (code == 'cold') {
    return Icon(WeatherIcons.wi_snowflake_cold, size: size, color: color);
  } else if (code == 'refreshBottom') {
    return Icon(
      FontAwesome.refresh,
      color: kLighterBlue,
      size: size,
    );
  } else if (code == 'refresh') {
    return Icon(FontAwesome.refresh, size: size, color: color);
  } else if (code == 'refresh_cloud') {
    return Icon(WeatherIcons.wi_cloud_refresh, size: 30.0, color: color);
  } else if (code == 'back') {
    return Icon(Ionicons.ios_arrow_back, size: 30.0, color: color);
  } else if (code == 'details') {
    return Icon(
      MaterialCommunityIcons.page_next_outline,
      size: 30.0,
      color: kLighterBlue,
    );
  } else {
    return Icon(WeatherIcons.wi_na, size: size, color: color);
  }
}

// RETURNS DIRECTIONAL ARROW GIVEN A RADIAN ANGLE
Widget getWindIcon(var angle, [double size, Color color]) {
  angle = angle * pi / 180;
  return Transform.rotate(
    angle: angle,
    child: Icon(SimpleLineIcons.arrow_up_circle, size: size, color: color),
  );
}

// RETURNS A DAY OR NIGHT ICON GIVEN AN INT
Icon getIconIntDayOrNight(int code, [double size, String dayOrNight, Color color]) {
  if (code == 801 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_cloudy, size: size, color: color);
  } else if (code == 801 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_cloudy, size: size, color: color);
  } else if (code >= 802 && code <= 804 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_cloudy, size: size, color: color);
  } else if (code >= 802 && code <= 804 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_cloudy, size: size, color: color);
  } else if (code == 800 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_sunny, size: size, color: color);
  } else if (code == 800 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_clear, size: size, color: color);
  } else if (code == 701 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_sprinkle, size: size, color: color);
  } else if (code == 701 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_sprinkle, size: size, color: color);
  } else if (code == 711) {
    return Icon(WeatherIcons.wi_smoke, size: size, color: color);
  } else if (code == 721) {
    return Icon(WeatherIcons.wi_day_haze, size: size, color: color);
  } else if (code == 731) {
    return Icon(WeatherIcons.wi_sandstorm, size: size, color: color);
  } else if (code == 741 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_fog, size: size, color: color);
  } else if (code == 741 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_fog, size: size, color: color);
  } else if (code == 751) {
    return Icon(WeatherIcons.wi_sandstorm, size: size, color: color);
  } else if (code == 761) {
    return Icon(WeatherIcons.wi_dust, size: size, color: color);
  } else if (code == 762) {
    return Icon(WeatherIcons.wi_volcano, size: size, color: color);
  } else if (code == 771 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_cloudy_gusts, size: size, color: color);
  } else if (code == 771 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_cloudy_gusts, size: size, color: color);
  } else if (code == 781) {
    return Icon(WeatherIcons.wi_tornado, size: size, color: color);
  } else if (code >= 600 && code <= 602 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_snow, size: size, color: color);
  } else if (code >= 600 && code <= 602 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_snow, size: size, color: color);
  } else if (code >= 611 && code <= 613 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_sleet, size: size, color: color);
  } else if (code >= 611 && code <= 613 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_sleet, size: size, color: color);
  } else if (code >= 615 && code <= 622 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_rain_mix, size: size, color: color);
  } else if (code >= 615 && code <= 622 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_rain_mix, size: size, color: color);
  } else if (code == 500 || code == 520 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_sprinkle, size: size, color: color);
  } else if (code == 500 || code == 520 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_sprinkle, size: size, color: color);
  } else if (code >= 501 && code <= 504 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_rain, size: size, color: color);
  } else if (code >= 501 && code <= 504 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_rain, size: size, color: color);
  } else if (code == 511 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_sleet, size: size, color: color);
  } else if (code == 511 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_sleet, size: size, color: color);
  } else if (code >= 521 && code <= 531 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_showers, size: size, color: color);
  } else if (code >= 521 && code <= 531 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_showers, size: size, color: color);
  } else if (code >= 300 && code <= 321 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_sprinkle, size: size, color: color);
  } else if (code >= 300 && code <= 321 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_sprinkle, size: size, color: color);
  } else if (code == 200 || code == 201 || code == 230 || code == 231 || code == 232 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_storm_showers, size: size, color: color);
  } else if (code == 200 || code == 201 || code == 230 || code == 231 || code == 232 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_storm_showers, size: size, color: color);
  } else if (code == 202 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_thunderstorm, size: size, color: color);
  } else if (code == 202 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_thunderstorm, size: size, color: color);
  } else if (code == 210 || code == 211 || code == 212 || code == 221 && dayOrNight == 'day') {
    return Icon(WeatherIcons.wi_day_lightning, size: size, color: color);
  } else if (code == 210 || code == 211 || code == 212 || code == 221 && dayOrNight == 'night') {
    return Icon(WeatherIcons.wi_night_alt_lightning, size: size, color: color);
  } else {
    return Icon(WeatherIcons.wi_na, size: size, color: color);
  }
}
