import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/widgets/screen_wraper.dart';
import 'package:weather_app/widgets/temperature_chart.dart';
import 'package:weather_app/widgets/weather_row.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen(
      {super.key,
      required this.city,
      required this.weather,
      required this.geolocationError,
      required this.weatherError,
      required this.cityLoading,
      required this.weatherLoading});

  final City? city;
  final Weather? weather;
  final Error? geolocationError;
  final Error? weatherError;
  final bool cityLoading;
  final bool weatherLoading;

  @override
  Widget build(BuildContext context) {
    List<List<String>> weatherHourly = [];
    List<FlSpot> weatherHourlyFlSpot = [];
    double maxTemperature = 60;
    double minTemperature = -40;

    if (weather != null) {
      // TODO: compute all the data in the temperature_chart.dart file
      // ------------------- compute temperature spots -------------------
      weatherHourly = weather!.toHourlyListString();
      log(weatherHourly.toString());
      weatherHourlyFlSpot = weatherHourly
          .map((e) => FlSpot(weatherHourly.indexOf(e).toDouble(),
              double.parse(e[1].split(' ')[0])))
          .toList();

      // ------------------- compute max temperature -------------------
      maxTemperature = weatherHourlyFlSpot
          .map((e) => e.y)
          .reduce((value, element) => value > element ? value : element);
      maxTemperature += temperatureModulo + 1;
      maxTemperature -= maxTemperature % temperatureModulo;

      // ------------------- compute min temperature -------------------
      minTemperature = weatherHourlyFlSpot
          .map((e) => e.y)
          .reduce((value, element) => value < element ? value : element);
      minTemperature -= temperatureModulo + 1;
      minTemperature += 10 - (minTemperature % temperatureModulo);
    }

    return ScreenWrapper(
      city: city,
      cityLoading: cityLoading,
      geolocationError: geolocationError,
      body: Column(
        children: [
          TemperatureChart(
              titlePrefix: "Today",
              maxY: maxTemperature,
              minY: minTemperature,
              firstLineSpots: weatherHourlyFlSpot),
          WeatherRow(
            weatherDataList: weatherHourly
                .map((e) => WeatherData(
                      label: e[0],
                      temperature: double.parse(e[1].split(' ')[0]),
                      weather: WeatherCode.values
                          .firstWhere((element) => element.value.label == e[2])
                          .value,
                      windSpeed: double.parse(e[3].split(' ')[0]),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
