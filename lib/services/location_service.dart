import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:tempo_template/models/location.dart';

class LocationService {
  double? latitude;
  double? logitude;

  Future<void> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // serviço de localização desabilitado. Não será possível continuar
      return Future.error('O serviço de localização está desabilitado.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Sem permissão para acessar a localização
        return Future.error('Sem permissão para acesso à localização');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // permissões negadas para sempre
      return Future.error(
          'A permissão para acesso a localização foi negada para sempre. Não é possível pedir permissão.');
    }
  }

  Future<Location> getCurrentLocation() async {
    await checkLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    var location =
        Location(latitute: position.latitude, longitude: position.longitude);

    return location;
  }
}
