// import 'dart:convert';
import 'dart:convert';
// import 'dart:developer';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kahoot/ip.dart';
import 'package:kahoot/widgets/suceccful_registration.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isSuccessful = false;

  sendData() async {
//TODOs
    Uri url = Uri.http(ipv4ServerAddress, '/reg');
    var body = {
      'email': _email,
      'password': _password,
    };
    // http.Request().body .send();
    http.Response r = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (r.statusCode == 200) {
      setState(() {
        _isSuccessful = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isSuccessful
        ? const SuccessfulRegistration()
        : Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      label: Text('E-mail'),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _email = value,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please insert E-mail.';
                    //   } else if (!value.contains('@')) {
                    //     return "E-mail should contain '@'";
                    //   } else if (!value.contains('.')) {
                    //     return "E-mail should contain '.'";
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  TextFormField(
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please insert password.';
                    //   }
                    //   return null;
                    // },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.password),
                      label: Text('Password'),
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      // setState(() {
                      _password = value;
                      // });
                    },
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  TextFormField(
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please confirm password.';
                    //   }
                    //   if (value != _password) {
                    //     return 'Passwords is not identical.';
                    //   }
                    //   return null;
                    // },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.password),
                      label: Text('Confirm password'),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      sendData();
                      // }
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          );
  }
}
