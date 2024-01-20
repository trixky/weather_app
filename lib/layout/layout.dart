import 'package:flutter/material.dart';
import 'package:weather_app/apis/get_city_by_coordinates.dart';
import 'package:weather_app/apis/get_weather_from_coordinates.dart';
import 'package:weather_app/apis/native_geolocalisation.dart';
import 'package:weather_app/layout/location_search_bar.dart';
import 'package:weather_app/models/geolocation.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/screens/currently.dart';
import 'package:weather_app/screens/today.dart';
import 'package:weather_app/screens/weekly.dart';
import 'package:weather_app/models/city.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FocusNode searchFocusNode = FocusNode();

  City? city;
  Error? geolocationError;
  Error? weatherError;
  Weather? weather;
  bool cityLoading = false;
  bool weatherLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _setCity(City newCity) async {
    setState(() {
      city = newCity;
      weather = null;
      cityLoading = false;
      weatherLoading = true;
      geolocationError = null;
      weatherError = null;
    });

    // TODO: fix the error gesture
    try {
      final newWeather = await getWeatherFromCoordinates(city!.geolocation);
      setState(() {
        weather = newWeather;
        weatherLoading = false;
      });
    } catch (error) {
      setState(() {
        weather = null;
        weatherLoading = false;
        switch (error.runtimeType) {
          case String:
            weatherError = ArgumentError(error as String);
            break;
          case Error:
            weatherError = error as Error;
            break;
          default:
        }
      });
    }
  }

  void _setGeolocalisation() async {
    setState(() {
      city = null;
      weather = null;
      cityLoading = true;
      weatherLoading = true;
      geolocationError = null;
      weatherError = null;
    });

    // TODO: fix the error gesture
    try {
      final nativeGeolocalisation = await determinePosition();

      final newGeoLocation = Geolocation(
          nativeGeolocalisation.latitude, nativeGeolocalisation.longitude);

      final newWeather = await getWeatherFromCoordinates(newGeoLocation);

      setState(() {
        weather = newWeather;
        weatherLoading = false;
      });

      final newCity = await getCityByCoordinates(
          newGeoLocation.latitude, newGeoLocation.longitude);

      if (newCity != null) {
        setState(() {
          city = newCity;
          cityLoading = false;
        });
      } else {
        setState(() {
          city = null;
          cityLoading = false;
          geolocationError = ArgumentError('No city found');
        });
      }
    } catch (error) {
      setState(() {
        city = null;
        weather = null;
        cityLoading = false;
        weatherLoading = false;
        switch (error.runtimeType) {
          case String:
            geolocationError = ArgumentError(error as String);
            break;
          case Error:
            geolocationError = error as Error;
            break;
          default:
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            if (searchFocusNode.hasFocus) {
              searchFocusNode.unfocus();
            } else {
              searchFocusNode.requestFocus();
              // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
              searchFocusNode.notifyListeners();
            }
          },
        ),
        title: LocationSearchBar(
          setCity: _setCity,
          searchFocusNode: searchFocusNode,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.near_me),
            onPressed: _setGeolocalisation,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          TabBarView(
            controller: _tabController,
            children: [
              CurrentlyScreen(
                  city: city,
                  weather: weather,
                  geolocationError: geolocationError,
                  weatherError: weatherError,
                  cityLoading: cityLoading,
                  weatherLoading: weatherLoading),
              TodayScreen(
                  city: city,
                  weather: weather,
                  geolocationError: geolocationError,
                  weatherError: weatherError,
                  cityLoading: cityLoading,
                  weatherLoading: weatherLoading),
              WeeklyScreen(
                  city: city,
                  weather: weather,
                  geolocationError: geolocationError,
                  weatherError: weatherError,
                  cityLoading: cityLoading,
                  weatherLoading: weatherLoading),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        padding: EdgeInsets.zero,
        child: TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          dividerColor: Colors.black,
          padding: EdgeInsets.zero,
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.brightness_low), text: "Currently"),
            Tab(icon: Icon(Icons.calendar_today), text: "Today"),
            Tab(icon: Icon(Icons.calendar_month), text: "Weekly"),
          ],
        ),
      ),
    );
  }
}
