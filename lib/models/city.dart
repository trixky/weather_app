import 'package:weather_app/models/geolocation.dart';

class City {
  const City(this.name, this.country, this.region, this.geolocation);

  final String name;
  final String? region;
  final String country;
  final Geolocation geolocation;
}
