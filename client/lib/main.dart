// import 'dart:developer';
// import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kahoot/screens/auth_gate.dart';
import 'package:kahoot/screens/ip_ask.dart';
import 'package:kahoot/screens/login_screen.dart';
import 'package:kahoot/screens/register_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kahoot',
      theme: ThemeData.dark(),
      initialRoute: "/ipask",
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/ipask': (context) => IpAsker(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => LoginPage(),
        // 'friendmap':(context) => FriendMap();
        // '/main': (context) => const MainScreen(),
      },
    );
  }
}

// go() async {
//   var url = Uri.http('192.168.10.101:8080', '/users');
//   var response = await http.get(url);
//   inspect(response);
//   // print('Response body: ${response.body}');

//   // print(await http.read(Uri.https('example.com', 'foobar.txt')));
// }
