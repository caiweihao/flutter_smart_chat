import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../constants.dart';
import '../models/user_uid.dart';

final _auth = FirebaseAuth.instance;

String generateChatId(String uid1, String uid2) {
  final uids = [uid1, uid2]..sort();
  return '${uids[0]}_${uids[1]}';
}

Future<void> sendMessage(String myUid, String otherUid, String text) async {
  final chatId = generateChatId(myUid, otherUid);
  final ref = FirebaseDatabase.instance.ref('chats/$chatId/messages').push();

  await ref.set({
    'senderId': myUid,
    'text': text,
    'timestamp': ServerValue.timestamp,
    'readBy': {otherUid: false},
  });
}

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String messageText;
  late TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              //Implement logout functionality
              print('logout pressed email is ${_auth.currentUser!.toString()}');
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text(context.read<UserUid>().friend!.name),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      //Implement send functionality.
                      sendMessage(
                        _auth.currentUser!.uid,
                        context.read<UserUid>().friend!.uid,
                        messageText,
                      );
                      controller.clear();
                    },
                    child: Text('Send', style: kSendButtonTextStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  Stream<DatabaseEvent> getChatStream(String chatId) {
    return FirebaseDatabase.instance
        .ref('chats/$chatId/messages')
        .orderByChild('timestamp')
        .onValue;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: getChatStream(
        generateChatId(
          context.read<UserUid>().friend!.uid,
          _auth.currentUser!.uid,
        ),
      ),
      builder: (value, snap) {
        List<MessageBubble> texts = [];
        if (!snap.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }

        final data = snap.data?.snapshot.value;
        if (data == null || data is! Map) {
          return Center(child: Text("No messages yet"));
        }

        final messages = data.entries.toList()
          ..sort((a, b) {
            final tsA = a.value['timestamp'] ?? 0;
            final tsB = b.value['timestamp'] ?? 0;
            return tsA.compareTo(tsB);
          });


        for (var message in messages) {
          var messageText = message.value['text'];
          var messageSender = message.value['senderId'];
          print('message is ${message.value} and friend uid is ${context.read<UserUid>().friend!.uid}');
          print('message key is ${message.key.toString()}');
          print('message is ${message.key} and friend uid is ${context.read<UserUid>().friend!.uid}');
          print('message readBy is ${message.value['readBy']['${context.read<UserUid>().friend!.uid}']}');
          final readBy = message.value['readBy'] as Map<dynamic, dynamic>?;
          print('message readBy as map  $readBy key is ${message.key}');
          bool isRead = false;
          if (readBy != null && (readBy[context.read<UserUid>().friend!.uid] == true || readBy[_auth.currentUser!.uid] == true)) {
            isRead = true;
          }
          texts.add(
            MessageBubble(
              key: ValueKey(message.key.toString()),
              messageSender: messageSender == _auth.currentUser!.uid
                  ? "Me"
                  : context.read<UserUid>().friend!.name,
              messageText: messageText,
              isMe: messageSender == _auth.currentUser!.uid,
              isRead: isRead,
              onTap: () async {
                String chatId =  generateChatId(
                  context.read<UserUid>().friend!.uid,
                  _auth.currentUser!.uid,
                );
                // print('key is $key');
                // print('message key is ${message.key}');
                // ValueKey<String> valueKey = key! as ValueKey<String>;
                // print('valueKey is $valueKey');
                DatabaseReference ref = FirebaseDatabase.instance.ref('chats/$chatId/messages/${message.key}/readBy');
                final readBy = message.value['readBy'] as Map<dynamic, dynamic>?;

                if (readBy != null && readBy[_auth.currentUser!.uid] == false) {
                  await ref.update({
                    _auth.currentUser!.uid: true,
                  });
                }

// Only update the age, leave the name and address!

              },
            ),
          );
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            children: texts,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required  this.key,
    required this.messageText,
    required this.messageSender,
    required this.isMe,
    required this.isRead,
    required this.onTap,
  });
  final Key key;
  final String messageText;
  final String messageSender;
  final bool isMe;
  final bool isRead;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    onTap();
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            messageSender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                messageText,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Text(
            isRead ? "已读" : "未读",
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
