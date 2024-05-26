import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double latitude = 0;
  double longitude = 0;

  Future<void> getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Handle the case where the user denies the permission
        print('Location permission denied');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        // Handle the case where the user denies the permission permanently
        print('Location permission permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      longitude = position.longitude;
      latitude = position.latitude;
      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
    } catch (e) {
      // Handle any exceptions
      print('An error occurred: $e');
    }
  }
}
