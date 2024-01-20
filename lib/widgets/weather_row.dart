import 'package:flutter/material.dart';
import 'package:weather_app/logic/color.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_data.dart';

class WeatherRow extends StatelessWidget {
  const WeatherRow({super.key, required this.weatherDataList});

  final List<WeatherData> weatherDataList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weatherDataList
              .map((e) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: Column(
                      children: [
                        Text(e.label, style: const TextStyle(fontSize: 20)),
                        if (e.weather != null)
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(
                              WeatherCode.values
                                  .firstWhere(
                                      (w) => w.value.label == e.weather!.label)
                                  .value
                                  .icon,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        if (e.temperature != null)
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "${e.temperature.toString()} $temperatureUnit",
                              style: TextStyle(
                                fontSize: 14,
                                color: getColorForTemperature(e.temperature!),
                              ),
                            ),
                          ),
                        if (e.maxTemperature != null)
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              children: [
                                Text(
                                  "${e.maxTemperature.toString()} $temperatureUnit",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  " (max)",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (e.minTemperature != null)
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              children: [
                                Text(
                                  "${e.minTemperature.toString()} $temperatureUnit",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  " (min)",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (e.windSpeed != null)
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.wind_power,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${e.windSpeed.toString()} $windUnit",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: getColorForWind(e.windSpeed!),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
