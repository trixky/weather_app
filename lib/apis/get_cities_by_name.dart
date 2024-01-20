import 'dart:convert';

import 'package:weather_app/models/city.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/geolocation.dart';

Future<List<City>> getCitiesByName(String name, {int limit = 1}) async {
  final List<City> cities = [];

  final apiUrl =
      'https://geocoding-api.open-meteo.com/v1/search?name=$name&count=$limit&language=en&format=json';

  final response = await http.get(Uri.parse(apiUrl));
  final parsedResponse = jsonDecode(response.body) as Map<String, dynamic>;
  final resultList = parsedResponse['results'] as List<dynamic>?;

  if (resultList != null) {
    for (final result in resultList) {
      final name = result['name'] as String;
      final region = result['admin1'] as String?;
      final country = result['country'] as String;
      final latitude = result['latitude'] as double;
      final longitude = result['longitude'] as double;

      final resultCity =
          City(name, country, region, Geolocation(latitude, longitude));

      cities.add(resultCity);
    }
  }

  return cities;
}
