import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tempo_template/services/location_service.dart';
import 'package:http/http.dart' as http;
import 'package:tempo_template/services/networking.dart';
import '../models/location.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<Location> getLocation() async {
    var locationService = LocationService();
    Location location = await locationService.getCurrentLocation();
    return location;
  }

  Future<void> getWeatherData() async {
    var location = await getLocation();
    var apiKey = 'd9631c1efdc485d19284b240e877bffa';
    var url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitute}&lon=${location.longitude}&appid=${apiKey}&units=metric';

    var weatherData = await NetworkHelper(url).getData();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // obtém a localização atual
            getLocation();
          },
          child: const Text('Obter Localização'),
        ),
      ),
    );
  }
}
