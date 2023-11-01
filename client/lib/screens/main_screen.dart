import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kahoot/services/location_service.dart';
import 'package:kahoot/widgets/custom_map.dart';
// import 'package:kahoot/widgets/search.dart';
import 'package:kahoot/widgets/side_menu.dart';

import '../ip.dart';

class MainScreen extends StatefulWidget {
  final User? data;
  const MainScreen({this.data, super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String? myEmail;
  late Timer timer;
  bool _isSearching = false;
  final TextEditingController _searchQueryController = TextEditingController();

  @override
  initState() {
    super.initState();
    myEmail = widget.data?.email;
    sendCoordinates();
  }

  @override
  dispose() {
    super.dispose();
    timer.cancel();
  }

  logOut() {
    GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }

  sendCoordinates() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      Position loc = await GeolocationService.determinePosition();

      var url = Uri.http('$ipv4ServerAddress:8080', '/update');
      var bodyObject = {
        'email': widget.data!.email,
        'latitude': loc.latitude.toString(),
        'longitude': loc.longitude.toString()
      };
      var json = jsonEncode(bodyObject);
      // var resp =

      try {
        await http.post(url, body: json);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _clearSearchQuery();
      }
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search people by email...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white60),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  _fetchSearch() async {
    Uri url = Uri.parse('http://$ipv4ServerAddress:8080/search');
    var response = await http.post(url, body: _searchQueryController.text);
    // inspect(response.body);
    if (response.body == "true") {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          // inspect(context.widget.);
          return AlertDialog(
            title: Text(
              _searchQueryController.text,
            ),
            content: const Text(
              'User found. You can add him to your friendlist.',
            ),
            actions: [
              ElevatedButton.icon(
                onPressed: _inviteUser,
                icon: const Icon(Icons.person_add),
                label: const Text('Invite user'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blueGrey[300])),
              ),
              // IconButton.filled(
              //   onPressed: () => {},
              //   icon: Icon(Icons.add),
              // ),
            ],
          );
        },
      );
    } else if (response.body == "false") {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Oops!'),
            content:
                Text('User ${_searchQueryController.text} does not exist.'),
          );
        },
      );
    }
  }

  _inviteUser() async {
    Uri url = Uri.parse('http://$ipv4ServerAddress:8080/invite');
    var response = await http.post(
      url,
      body: '$myEmail ${_searchQueryController.text}',
    );
    // inspect(response);
    if (response.body == "invited") {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invited!',
          ),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.popAndPushNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    // var myEmail = widget.data!.email;
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? _buildSearchField()
            : Text(myEmail == null ? 'Hello!' : 'Hello, $myEmail!'),
        actions: [
          _isSearching
              ? IconButton(
                  onPressed: _fetchSearch, icon: const Icon(Icons.send_rounded))
              : Container(),
          IconButton(
            icon: Icon(_isSearching ? Icons.cancel : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            onPressed: logOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: Drawer(
          backgroundColor: Colors.transparent,
          elevation: 20,
          width: 250,
          child: SideMenu(
            userName: myEmail!,
          )),
      body: const CustomMap(),
    );
  }
}
