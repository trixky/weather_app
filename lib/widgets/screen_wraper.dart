import 'package:flutter/material.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/widgets/city_header.dart';

class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper(
      {super.key,
      required this.body,
      this.geolocationError,
      this.city,
      this.cityLoading = false});

  final Widget body;
  final City? city;
  final Error? geolocationError;
  final bool cityLoading;

  @override
  Widget build(BuildContext context) {
    bool showBody = false;

    Widget header;
    if (geolocationError != null) {
      header = Text(
        'Geolocation is not available,\nplease active it and enable it in your App settings.\nError: ${geolocationError.toString()}',
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      );
    } else if (cityLoading) {
      header = const CircularProgressIndicator();
    } else if (city != null) {
      showBody = true;
      header = CityHeader(city!);
    } else {
      header = const Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text(
          "No location selected",
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.6),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 24,
            ),
            header,
            if (showBody)
              Expanded(
                child: SingleChildScrollView(
                    child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: body,
                )),
              ),
          ],
        ),
      ),
    );
  }
}
