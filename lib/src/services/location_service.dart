import 'package:geolocator/geolocator.dart';

class LocationSnapshot {
  const LocationSnapshot({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class LocationService {
  Future<LocationSnapshot?> currentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return null;
    }
    final position = await Geolocator.getCurrentPosition();
    return LocationSnapshot(latitude: position.latitude, longitude: position.longitude);
  }
}
