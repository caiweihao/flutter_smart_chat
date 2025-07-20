import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import '../models/friend.dart';
import '../models/user_uid.dart';
import 'chat_screen.dart';

final _auth = FirebaseAuth.instance;

class FriendListScreen extends StatefulWidget {
  static const String id = 'friend_list_screen';
  const FriendListScreen({super.key});

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  Future<List<Friend>> getFriends() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child('users/${_auth.currentUser!.uid}/friends')
        .get();
    print(snapshot.value! as Map<dynamic, dynamic>);
    List<Friend> friends = [];
    if (snapshot.exists) {
      Map<dynamic, dynamic> userMap = snapshot.value! as Map<dynamic, dynamic>;

      for (final entry in userMap.entries) {
        final key = entry.key;

        final user = await ref.child('users/$key').get();
        print('$key');
        print("${(user.value! as Map<dynamic, dynamic>)['name']}");
        friends.add(
          Friend(
            uid: key,
            name: (user.value! as Map<dynamic, dynamic>)['name'],
          ),
        );
      }
    } else {
      print('No data available.');
    }
    print('friends length is ${friends.length}');
    return friends;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Friend>>(
        future: getFriends(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 加载中
          }

          if (snapshot.hasError) {
            return Center(child: Text('出错啦: ${snapshot.error}'));
          }

          final messages = snapshot.data ?? [];

          if (messages.isEmpty) {
            return Center(child: Text('暂无消息'));
          }

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              return Card(
                color: Colors.blueAccent,
                child: ListTile(title: Text(msg.name), onTap: () {
                  context.read<UserUid>().setFriend(msg);
                  Navigator.pushNamed(context, ChatScreen.id);
                },),
              );
            },
          );
        },
      ),
    );
  }
}
