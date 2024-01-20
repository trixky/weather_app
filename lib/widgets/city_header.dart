import 'package:flutter/material.dart';
import 'package:weather_app/models/city.dart';

class CityHeader extends StatelessWidget {
  const CityHeader(this.city, {super.key});

  final City city;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          city.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (city.region != null)
          Text(
            city.region!,
            textAlign: TextAlign.center,
            style: const TextStyle(
            fontSize: 18,
          ),
          ),
        Text(
          city.country,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
