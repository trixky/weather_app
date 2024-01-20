import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const temperatureUnit = "°C";
const temperatureModulo = 10;
const windUnit = "km/h";
final DateFormat formatter = DateFormat('yyyy-MM-dd');

class WeatherCodeInfos {
  const WeatherCodeInfos(this.label, this.number, this.icon);

  final int number;
  final String label;
  final IconData icon;
}

enum WeatherCode {
  clearSky(WeatherCodeInfos("clear sky", 0, Icons.wb_sunny)),
  mainlyClear(WeatherCodeInfos("mainly clear", 1, Icons.wb_sunny)),
  partlyCloudy(WeatherCodeInfos("partly cloudy", 2, Icons.wb_cloudy)),
  overcast(WeatherCodeInfos("overcast", 3, Icons.wb_cloudy)),
  fog(WeatherCodeInfos("fog", 45, Icons.foggy)),
  depositingRimeFog(WeatherCodeInfos("depositing rime fog", 48, Icons.foggy)),
  drizzleLight(WeatherCodeInfos("drizzle light", 51, Icons.wb_cloudy)),
  drizzleModerate(WeatherCodeInfos("drizzle moderate", 53, Icons.wb_cloudy)),
  drizzleDense(WeatherCodeInfos("drizzle dense", 55, Icons.wb_cloudy)),
  freezingDrizzleLight(
      WeatherCodeInfos("freezing drizzle light", 56, Icons.foggy)),
  freezingDrizzleDense(
      WeatherCodeInfos("freezing drizzle dense", 57, Icons.foggy)),
  rainSlight(WeatherCodeInfos("rain slight", 61, Icons.wb_cloudy)),
  rainModerate(WeatherCodeInfos("rain moderate", 63, Icons.grain)),
  rainHeavy(WeatherCodeInfos("rain heavy", 65, Icons.grain)),
  freezingRainLight(WeatherCodeInfos("freezing rain light", 66, Icons.ac_unit)),
  freezingRainHeavy(WeatherCodeInfos("freezing rain heavy", 67, Icons.ac_unit)),
  snowFallSlight(WeatherCodeInfos("snow fall slight", 71, Icons.ac_unit)),
  snowFallModerate(WeatherCodeInfos("snow fall moderate", 73, Icons.ac_unit)),
  snowFallHeavy(WeatherCodeInfos("snow fall heavy", 75, Icons.ac_unit)),
  snowGrains(WeatherCodeInfos("snow grains", 77, Icons.ac_unit)),
  rainShowersSlight(WeatherCodeInfos("rain showers slight", 80, Icons.grain)),
  rainShowersModerate(
      WeatherCodeInfos("rain showers moderate", 81, Icons.grain)),
  rainShowersViolent(WeatherCodeInfos("rain showers violent", 82, Icons.grain)),
  snowShowersSlight(WeatherCodeInfos("snow showers slight", 85, Icons.ac_unit)),
  snowShowersHeavy(WeatherCodeInfos("snow showers heavy", 86, Icons.ac_unit)),
  thunderstormSlight(
      WeatherCodeInfos("thunderstorm slight", 95, Icons.flash_on)),
  thunderstormModerate(
      WeatherCodeInfos("thunderstorm moderate", 96, Icons.flash_on)),
  thunderstormHeavy(WeatherCodeInfos("thunderstorm heavy", 99, Icons.flash_on));

  const WeatherCode(this.value);
  final WeatherCodeInfos value;
}

class WeatherHourly {
  const WeatherHourly({
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
  });

  final double temperature;
  final WeatherCode weatherCode;
  final double windSpeed;

  List<String> toListString() => [
        "$temperature $temperatureUnit",
        (weatherCode.value.label),
        "$windSpeed $windUnit",
      ];
}

class WeatherDaly {
  const WeatherDaly({
    required this.minTemperature,
    required this.maxTemperature,
    required this.weatherCode,
  });

  final double minTemperature;
  final double maxTemperature;
  final WeatherCode weatherCode;

  List<String> toListString() => [
        "$minTemperature $temperatureUnit",
        "$maxTemperature $temperatureUnit",
        (weatherCode.value.label),
      ];
}

class Weather {
  Weather({
    required this.currently,
    required this.hourly,
    required this.daily,
  });

  final WeatherHourly currently;
  final List<WeatherHourly> hourly;
  final List<WeatherDaly> daily;

  List<String> toCurrentlyListString() => currently.toListString();

  List<List<String>> toHourlyListString() {
    var hour = -1;

    return hourly.asMap().entries.map((e) {
      hour++;

      return [
        "${hour.toString().padLeft(2, '0')}:00",
        ...e.value.toListString()
      ];
    }).toList();
  }

  List<List<String>> toDailyListString() {
    var currentDate = DateTime.now();

    return daily.asMap().entries.map((e) {
      currentDate = currentDate.add(const Duration(days: 1));

      return [formatter.format(currentDate), ...e.value.toListString()];
    }).toList();
  }
}
