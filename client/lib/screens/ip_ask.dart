import 'package:flutter/material.dart';
import 'package:kahoot/ip.dart';

class IpAsker extends StatelessWidget {
  IpAsker({super.key});
  var ipTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // setIp(context) {
    //   ipv4ServerAddress = ipTextController.text;
    //   Navigator.pushNamed(context, '/auth');
    // }

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Insert server local ipv4 addess:'),
            TextField(
              controller: ipTextController,
            ),
            TextButton(
                onPressed: () {
                  ipv4ServerAddress = ipTextController.text;
                  Navigator.pushNamed(context, '/auth');
                },
                child: const Text('Set')),
          ],
        ),
      ),
    );
  }
}
