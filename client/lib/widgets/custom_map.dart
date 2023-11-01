// import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../services/location_service.dart';

class CustomMap extends StatelessWidget {
  const CustomMap({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GeolocationService.determinePosition(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          // inspect(snapshot.data);
          var location = snapshot.data;
          return FlutterMap(
            options: MapOptions(
              center: LatLng(location!.latitude, location.longitude),
              zoom: 10.0,
            ),
            nonRotatedChildren: [
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(location.latitude, location.longitude),
                    width: 40,
                    height: 40,
                    builder: (context) => Image.asset('lib/images/marker.png'),
                  ),
                ],
              ),
            ],
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
            ],
          );
        }
      },
    );
  }
}
