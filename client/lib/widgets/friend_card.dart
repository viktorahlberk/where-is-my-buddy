import 'package:flutter/material.dart';
import 'package:kahoot/screens/friend_map.dart';

class FriendCard extends StatelessWidget {
  const FriendCard(this.name, this.deleter, {super.key});
  final String name;
  final deleter;
  // final mapChanger;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: IconButton(
          onPressed: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => FriendMap(name),
              ),
            );
          },
          icon: const Icon(Icons.location_pin)),
      trailing: IconButton(
          onPressed: () {
            deleter();
          },
          icon: const Icon(Icons.person_off)),
      // onTap: () {},
    );
  }
}
