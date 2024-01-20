import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/logic/date.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/widgets/screen_wraper.dart';
import 'package:weather_app/widgets/temperature_chart.dart';
import 'package:weather_app/widgets/weather_row.dart';

class WeeklyScreen extends StatelessWidget {
  const WeeklyScreen(
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
    List<List<String>> weatherDaily = [];
    List<List<String>> weatherDailyMax = [];
    List<FlSpot> weatherDailyMaxFlSpot = [];
    List<List<String>> weatherDailyMin = [];
    List<FlSpot> weatherDailyMinFlSpot = [];
    double maxTemperature = 60;
    double minTemperature = -40;

    if (weather != null) {
      // TODO: compute all the data in the temperature_chart.dart file
      weatherDaily = weather!.toDailyListString();
      // ------------------- compute temperature spots -------------------
      // ---------- max
      weatherDailyMax = weather!.toDailyListString();
      log(weatherDailyMax.toString());
      weatherDailyMaxFlSpot = weatherDailyMax
          .map((e) => FlSpot(weatherDailyMax.indexOf(e).toDouble(),
              double.parse(e[2].split(' ')[0])))
          .toList();
      // ---------- min
      weatherDailyMin = weather!.toDailyListString();
      log(weatherDailyMin.toString());
      weatherDailyMinFlSpot = weatherDailyMin
          .map((e) => FlSpot(weatherDailyMin.indexOf(e).toDouble(),
              double.parse(e[1].split(' ')[0])))
          .toList();

      // ------------------- compute max temperature -------------------
      maxTemperature = [...weatherDailyMaxFlSpot, ...weatherDailyMinFlSpot]
          .map((e) => e.y)
          .reduce((value, element) => value > element ? value : element);

      maxTemperature += temperatureModulo + 1;
      maxTemperature -= maxTemperature % temperatureModulo;

      // ------------------- compute min temperature -------------------
      minTemperature = [...weatherDailyMaxFlSpot, ...weatherDailyMinFlSpot]
          .map((e) => e.y)
          .reduce((value, element) => value < element ? value : element);
      minTemperature -= temperatureModulo + 1;
      minTemperature +=
          temperatureModulo - (minTemperature % temperatureModulo);
    }

    return ScreenWrapper(
      city: city,
      cityLoading: cityLoading,
      geolocationError: geolocationError,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (weatherLoading && !cityLoading)
            const CircularProgressIndicator()
          else if (weather != null && !cityLoading)
            TemperatureChart(
              titlePrefix: "Weekly",
              maxY: maxTemperature,
              minY: minTemperature,
              firstLineSpots: weatherDailyMaxFlSpot,
              secondLineSpots: weatherDailyMinFlSpot,
            ),
            WeatherRow(
            weatherDataList: weatherDaily.asMap().entries
                .map((e) => WeatherData(
                      label: generateMmDdDate(e.key.toDouble()),
                      minTemperature: double.parse(e.value[1].split(' ')[0]),
                      maxTemperature: double.parse(e.value[2].split(' ')[0]),
                      weather: WeatherCode.values
                          .firstWhere((element) => element.value.label == e.value[3])
                          .value,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
