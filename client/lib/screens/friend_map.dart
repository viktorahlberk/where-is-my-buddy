import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../ip.dart';

class FriendMap extends StatefulWidget {
  const FriendMap(this.userEmail, {super.key});
  final userEmail;

  @override
  State<FriendMap> createState() => _FriendMapState();
}

class _FriendMapState extends State<FriendMap> {
  // @override
  // initState() {
  //   super.initState();
  // }

  fetchUserCoordinates() async {
    Uri url = Uri.parse('http://$ipv4ServerAddress:8080/lastposition');
    var r = await http.post(url, body: widget.userEmail);
    // inspect(r);
    return jsonDecode(r.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userEmail),
      ),
      body: FutureBuilder(
        future: fetchUserCoordinates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var user = snapshot.data as Map;
            return FlutterMap(
              options: MapOptions(
                center: LatLng(
                  double.parse(user['latitude']),
                  double.parse(user['longitude']),
                ),
                zoom: 10.0,
              ),
              nonRotatedChildren: [
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        double.parse(user['latitude']),
                        double.parse(user['longitude']),
                      ),
                      width: 40,
                      height: 40,
                      builder: (context) =>
                          Image.asset('lib/images/marker.png'),
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
      ),
    );
  }
}
