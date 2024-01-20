import 'dart:convert';

import 'package:weather_app/apis/open_meteo.dart';
import 'package:weather_app/models/city.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/geolocation.dart';

Future<City?> getCityByCoordinates(num latitude, longitude) async {
  const limit = 1;
  final apiUrl =
      'http://api.openweathermap.org/geo/1.0/reverse?lat=$latitude&lon=$longitude&limit=$limit&appid=$kApiKey';

  final response = await http.get(Uri.parse(apiUrl));
  final parsedResponse = jsonDecode(response.body) as List<dynamic>;

  if (parsedResponse.isNotEmpty) {
    final firstCity = parsedResponse[0] as Map<String, dynamic>;

    final name = firstCity['name'] as String;
    final region = firstCity['state'] as String;
    final country = firstCity['country'] as String;
    final latitude = firstCity['lat'] as double;
    final longitude = firstCity['lon'] as double;

    final resultCity =
        City(name, country, region, Geolocation(latitude, longitude));

    return resultCity;
  }

  return null;
}
