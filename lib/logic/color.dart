import 'package:flutter/material.dart';

Color getColorForTemperature(double temperature) {
  if (temperature <= -30.0) {
    return Colors.blue[900]!; // Bleu foncé pour très froid
  } else if (temperature <= 0.0) {
    return Colors.blue[300]!; // Bleu clair pour froid
  } else if (temperature <= 20.0) {
    return Colors.green[400]!; // Vert pour température agréable
  } else if (temperature <= 30.0) {
    return Colors.yellow[600]!; // Jaune pour chaud
  } else if (temperature <= 40.0) {
    return Colors.orange[400]!; // Orange pour très chaud
  } else {
    return Colors.red[900]!; // Rouge foncé pour très très chaud
  }
}

  // wind in km/h
Color getColorForWind(double wind) {
  if (wind <= 5.0) {
    return Colors.green[400]!; // Vert pour vent faible
  } else if (wind <= 20.0) {
    return Colors.yellow[600]!; // Jaune pour vent modéré
  } else if (wind <= 40.0) {
    return Colors.orange[400]!; // Orange pour vent fort
  } else {
    return Colors.red[900]!; // Rouge foncé pour vent très fort
  }
}
