// import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kahoot/widgets/friend_card.dart';
import 'package:kahoot/widgets/invite_card.dart';

import '../ip.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key, required this.userName});
  final String userName;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  declineInvitation(String inviterEmail) async {
    Uri url = Uri.parse('http://$ipv4ServerAddress:8080/declineinvitation');
    await http.post(url, body: '${widget.userName} $inviterEmail');
  }

  acceptInvitation(String inviterEmail) async {
    Uri url = Uri.parse('http://$ipv4ServerAddress:8080/acceptinvitation');
    await http.post(url, body: '${widget.userName} $inviterEmail');
  }

  deleteFriend(String friend) async {
    Uri url = Uri.parse('http://$ipv4ServerAddress:8080/deletefriend');
    await http.post(url, body: '${widget.userName} $friend');
  }

  Future<List<FriendCard>> _fetchAllFriends() async {
    List<FriendCard> friendList = [];

    Uri url = Uri.parse('http://$ipv4ServerAddress:8080/getfriends');
    var response = await http.post(url, body: widget.userName);
    var friends = jsonDecode(response.body);
    for (var friend in friends['friends']) {
      friendList.add(FriendCard(friend, () => deleteFriend(friend)));
    }
    return Future(() => friendList);
  }

  Future<List<InviteCard>> _fetchAllInvites() async {
    List<InviteCard> inviteList = [];

    Uri url = Uri.parse('http://$ipv4ServerAddress:8080/getinvites');
    var response = await http.post(url, body: widget.userName);
    // inspect(response);
    var body = jsonDecode(response.body);
    // inspect(body);
    for (String inviterEmail in body['invites']) {
      inviteList.add(
        InviteCard(
          inviterEmail,
          () => declineInvitation(inviterEmail),
          () => acceptInvitation(inviterEmail),
        ),
      );
    }
    return Future(() => inviteList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
            ),
            // color: Colors.grey
          ),
          // margin: EdgeInsets.only(top: 50),
          child: Card(
            child: ListTile(
              title: Text(
                'Kahoot',
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                  '''Designed to be a fun and interactive way for users to stay connected with their friends and see where they've been.'''),
              subtitleTextStyle: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        FutureBuilder(
          future: _fetchAllInvites(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white30,
              ));
            } else {
//dummy code
              // list!.add(FriendCard(
              //     'viktorahu@gmail.com', deleteFriend('viktorahu@gmail.com')));
////////////

              var inviteList = snapshot.data;
              if (inviteList!.isNotEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 15, child: Text('Invites')),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: inviteList.length,
                      itemBuilder: (context, index) {
                        return inviteList[index];
                      },
                    ),
                  ],
                );
              } else {
                return Container();
                // return const Text('You dont have any Invites yet :(');
              }
            }
          },
        ),
        const Divider(
          indent: 5,
          endIndent: 5,
          color: Colors.white30,
        ),
        FutureBuilder(
          future: _fetchAllFriends(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white30,
              ));
            } else {
              var list = snapshot.data;

//dummy code
              // list!.add(FriendCard(
              //     'viktorahu@gmail.com', deleteFriend('viktorahu@gmail.com')));
////////////

              if (list!.isNotEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 20, child: Text('Friends')),
                    // const Text('Friends'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return list[index];
                      },
                    ),
                  ],
                );
              } else {
                return Container();
                // return const Text('You dont have any Friends yet :(');
              }
            }
          },
        ),
      ],
    );
  }
}
