import 'package:weather_app/models/weather.dart';

class WeatherData {
  const WeatherData({
    required this.label,
    this.weather,
    this.temperature,
    this.minTemperature,
    this.maxTemperature,
    this.windSpeed,
  });

  final String label;
  final WeatherCodeInfos? weather;
  final double? temperature;
  final double? minTemperature;
  final double? maxTemperature;
  final double? windSpeed;
}
