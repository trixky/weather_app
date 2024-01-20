import 'package:flutter/material.dart';
import 'package:weather_app/logic/color.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/widgets/screen_wraper.dart';

class CurrentlyScreen extends StatelessWidget {
  const CurrentlyScreen(
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
    final currentWeather = weather?.toCurrentlyListString();

    return ScreenWrapper(
      city: city,
      cityLoading: cityLoading,
      geolocationError: geolocationError,
      body: Column(
        children: [
          if (weatherLoading && !cityLoading)
            const CircularProgressIndicator()
          else if (weather != null &&
              !cityLoading &&
              currentWeather != null &&
              currentWeather.length >= 3)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  currentWeather[0],
                  style: TextStyle(
                    fontSize: 50,
                    color: getColorForTemperature(
                        double.parse((currentWeather[0].split(" ")[0]))),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(currentWeather[1], style: const TextStyle(fontSize: 20)),
                const SizedBox(
                  height: 10,
                ),
                Icon(
                  WeatherCode.values
                      .firstWhere((e) => e.value.label == currentWeather[1])
                      .value
                      .icon,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wind_power, color: Colors.white),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      currentWeather[2],
                      style: TextStyle(
                        fontSize: 20,
                        color: getColorForWind(
                          double.parse(
                            (currentWeather[2].split(" ")[0]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
        ],
      ),
    );
  }
}
