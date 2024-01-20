import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/geolocation.dart';
import 'package:weather_app/models/weather.dart';

Future<Weather> getWeatherFromCoordinates(Geolocation geolocation) async {
  final localTimezone = DateTime.now().timeZoneName;
  final currentLocalHour = DateTime.now().hour;
  final forecastHours = 24 - currentLocalHour;
  final pastHours = currentLocalHour;

  final apiUrl =
      'https://api.open-meteo.com/v1/forecast?latitude=${geolocation.latitude}&longitude=${geolocation.longitude}&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&forecast_hours=$forecastHours&past_hours=$pastHours&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=$localTimezone&temperature_unit=celsius&wind_speed_unit=kmh&format=json';

  final response = await http.get(Uri.parse(apiUrl));
  final parsedResponse = jsonDecode(response.body) as Map<String, dynamic>;

  // ------- Parse current weather
  final currentWeather = parsedResponse['current'] as Map<String, dynamic>;
  final currentWeatherCode = currentWeather['weather_code'];
  final WeatherHourly currently = WeatherHourly(
    temperature: currentWeather['temperature_2m'] as double,
    weatherCode: WeatherCode.values.where((element) {
      return element.value.number.toString() == currentWeatherCode.toString();
    }).first,
    windSpeed: currentWeather['wind_speed_10m'] as double,
  );

  // ------- Parse hourly weather
  final hourlyWeather = parsedResponse['hourly'] as Map<String, dynamic>;
  final hourlyWeatherTemperature =
      hourlyWeather['temperature_2m'] as List<dynamic>;
  final hourlyWeatherWeatherCodes =
      hourlyWeather['weather_code'] as List<dynamic>;
  final hourlyWeatherWindSpeeds =
      hourlyWeather['wind_speed_10m'] as List<dynamic>;
  final List<WeatherHourly> hourly = hourlyWeatherTemperature
      .map((e) => WeatherHourly(
            temperature: e as double,
            weatherCode: WeatherCode.values
                .where((element) =>
                    element.value.number.toString() ==
                    (hourlyWeatherWeatherCodes[
                        hourlyWeatherTemperature.indexOf(e)] as int).toString())
                .first,
            windSpeed:
                hourlyWeatherWindSpeeds[hourlyWeatherTemperature.indexOf(e)]
                    as double,
          ))
      .toList();

  // ------- Parse daily weather
  final dailyWeather = parsedResponse['daily'] as Map<String, dynamic>;
  final dailyWeatherTemperatureMin =
      dailyWeather['temperature_2m_min'] as List<dynamic>;
  final dailyWeatherTemperatureMax =
      dailyWeather['temperature_2m_max'] as List<dynamic>;
  final dailyWeatherWeatherCode = dailyWeather['weather_code'] as List<dynamic>;
  final List<WeatherDaly> daily = dailyWeatherTemperatureMin
      .map((e) => WeatherDaly(
            minTemperature: e as double,
            maxTemperature: dailyWeatherTemperatureMax[
                dailyWeatherTemperatureMin.indexOf(e)] as double,
            weatherCode: WeatherCode.values
                .where((element) =>
                    element.value.number.toString() ==
                    (dailyWeatherWeatherCode[
                        dailyWeatherTemperatureMin.indexOf(e)] as int)
                        .toString())
                .first,
          ))
      .toList();
  return Weather(currently: currently, hourly: hourly, daily: daily);
}
