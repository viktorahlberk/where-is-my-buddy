// // import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:kahoot/screens/login_screen.dart';
// import 'package:kahoot/screens/main_screen.dart';

// class AuthScreen extends StatelessWidget {
//   const AuthScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             // inspect(snapshot);
//             return MainScreen(data: snapshot.data!);
//           } else {
//             return LoginPage();
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kahoot/screens/login_screen.dart';
import 'package:kahoot/screens/main_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.idTokenChanges(),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData) {
                  // You can access the updated user data here using userSnapshot.data
                  // For example: User user = userSnapshot.data!;
                  return MainScreen(data: snapshot.data!);
                } else {
                  // If you want to handle the case when the user data is not available
                  // return a placeholder or loading widget, or whatever suits your app
                  return const CircularProgressIndicator();
                }
              },
            );
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
