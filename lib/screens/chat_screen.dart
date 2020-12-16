import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// FirebaseFirestore _firebaseFirestore;
// User _loggedInUser;

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageEditingTextController = TextEditingController();

  FirebaseAuth _auth;
  FirebaseFirestore _firebaseFirestore;
  User _loggedInUser;
  String _messageText;

  @override
  void initState() {
    super.initState();
    print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    _getCurrentUser();
  }

  void _getCurrentUser() {
    try {
      _auth = FirebaseAuth.instance;
      _firebaseFirestore = FirebaseFirestore.instance;

      final user = _auth.currentUser;
      if (user != null) {
        _loggedInUser = user;
        print(_loggedInUser.email);
      }
    } catch (e) {
      print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~chat_screen exception');
      print(e);
    }
  }

  // void getMessages()async {
  //   print('Yo');
  //   final messagesCollection = await _firebaseFirestore.collection('messages').get();
  //   for(var message in messagesCollection.docs){
  //     print(message.data());
  //   }
  // }

  // void messagesStream() async {
  //   print('Stream');
  //   await for (var snapshots
  //       in _firebaseFirestore.collection('messages').snapshots()) {
  //     for (var snap in snapshots.docs) {
  //       print(snap.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // messagesStream();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(
              firebaseFirestore: _firebaseFirestore,
              loggedInUser: _loggedInUser,
            ),
            // StreamBuilder<QuerySnapshot>(
            //   stream: _firebaseFirestore.collection('messages').snapshots(),
            //   builder: (context, asyncSnapshot) {
            //     if (asyncSnapshot.hasData) {
            //       final messages = asyncSnapshot.data.docs;
            //       List<MessageBubble> messagesWidgets = [];
            //       for (var message in messages) {
            //         final messageText = message.data()['text'];
            //         final messageSender = message.data()['sender'];
            //
            //         var currentUser = _loggedInUser.email;
            //
            //         final messageWidget = MessageBubble(
            //           text: messageText,
            //           sender: messageSender,
            //           isMe: currentUser == messageSender,
            //         );
            //         messagesWidgets.add(messageWidget);
            //       }
            //
            //       return Expanded(
            //         child: ListView(
            //           children: messagesWidgets,
            //         ),
            //       );
            //     }
            //
            //     return Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   },
            // ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageEditingTextController,
                      onChanged: (value) {
                        print(value);
                        _messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _messageEditingTextController.clear();
                      if (_messageText != null) {
                        _firebaseFirestore.collection('messages').add({
                          'sender': _loggedInUser.email,
                          'text': _messageText,
                        });
                      } else {
                        print('empty message lol');
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
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
  MessageStream({this.firebaseFirestore, this.loggedInUser});

  final FirebaseFirestore firebaseFirestore;
  final User loggedInUser;

  @override
  Widget build(BuildContext context) {
    if (firebaseFirestore == null) {
      print('Null firebasefirestore in messages tream');
      return Container();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: firebaseFirestore.collection('messages').snapshots(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          final messages = asyncSnapshot.data.docs.reversed;
          List<MessageBubble> messagesWidgets = [];
          for (var message in messages) {
            final messageText = message.data()['text'];
            final messageSender = message.data()['sender'];

            final messageWidget = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: loggedInUser.email == messageSender,
            );
            messagesWidgets.add(messageWidget);
          }

          return Expanded(
            child: ListView(
              reverse: true,
              children: messagesWidgets,
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
//
//
// StreamBuilder<QuerySnapshot>(
// stream: firebaseFirestore.collection('messages').snapshots(),
// builder: (context, asyncSnapshot) {
// if (asyncSnapshot.hasData) {
// final messages = asyncSnapshot.data.docs;
// List<MessageBubble> messagesWidgets = [];
// for (var message in messages) {
// final messageText = message.data()['text'];
// final messageSender = message.data()['sender'];
//
// var currentUser = loggedInUser.email;
//
// final messageWidget = MessageBubble(
// text: messageText,
// sender: messageSender,
// isMe: currentUser == messageSender,
// );
// messagesWidgets.add(messageWidget);
// }
//
// return Expanded(
// child: ListView(
// children: messagesWidgets,
// ),
// );
// }
//
// return Center(
// child: CircularProgressIndicator(),
// );
// },
// )

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe});

  final String text;
  final String sender;
  final bool isMe;

  // BorderRadius _getPointy() {
  //   if (isMe) {
  //     return _getMePointy();
  //   }
  //   return _getOtherPointy();
  // }

  BorderRadius _getMePointy() {
    return BorderRadius.only(
      topLeft: Radius.circular(25),
      bottomLeft: Radius.circular(25),
      bottomRight: Radius.circular(25),
    );
  }

  BorderRadius _getOtherPointy() {
    return BorderRadius.only(
      topRight: Radius.circular(25),
      bottomLeft: Radius.circular(25),
      bottomRight: Radius.circular(25),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe ? _getMePointy() : _getOtherPointy(),
            // BorderRadius.only(
            //   topLeft: Radius.circular(25),
            //   bottomLeft: Radius.circular(25),
            //   bottomRight: Radius.circular(25),
            // ), //BorderRadius.circular(25),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 25,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
