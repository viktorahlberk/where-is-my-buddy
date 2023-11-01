import 'package:flutter/material.dart';

class InviteCard extends StatelessWidget {
  const InviteCard(this.name, this.decliner, this.accepter, {super.key});
  final String name;
  final decliner;
  final accepter;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: Key(name),
      onDismissed: (direction) {
        decliner();
      },
      child: ListTile(
        title: Text(name),
        trailing: IconButton(
            onPressed: () {
              accepter();
            },
            icon: const Icon(Icons.add)),
        // onTap: () {},
      ),
    );
  }
}
