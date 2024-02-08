import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'chat_message.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;

  const ChatPage({
    Key? key,
    required this.receiverUserEmail,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void initializeLocalNotifications() {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,

    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,

    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String currentUserEmail = _firebaseAuth.currentUser?.email ?? '';
    return StreamBuilder(
      stream: _chatService.getMessage(currentUserEmail, widget.receiverUserEmail),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading......');
        }

        // Fetch the last message
        QueryDocumentSnapshot? lastMessage = snapshot.data!.docs.isEmpty ? null : snapshot.data!.docs.first;

        if (lastMessage != null) {
          Map<String, dynamic> data = lastMessage.data() as Map<String, dynamic>;
          String receiverEmail = data['receiverEmail'];

          // Show a local notification if the receiver is the current user
          if (receiverEmail == currentUserEmail) {
            showNotification('New Message', 'You have received a new message');
          }
        }

        return ListView(
          reverse: true,
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      },
    );
  }


  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String currentUserEmail = _firebaseAuth.currentUser?.email ?? '';

    var alignment = (data['senderEmail'] == currentUserEmail)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            Row(
              mainAxisAlignment: (data['senderEmail'] == currentUserEmail)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (data['senderEmail'] != currentUserEmail)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[900],
                    child: Icon(Icons.account_circle, size: 40, color: Colors.amber),
                  ),
                SizedBox(width: 8),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: (data['senderEmail'] == currentUserEmail)
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatTimestamp2(data['timestamp']),
                        style: TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                      Text(
                        data['senderEmail'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                          fontSize: 16,
                          fontFamily: 'RobotoCondensed',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[800]!),
                          color: (data['senderEmail'] == currentUserEmail)
                              ? Colors.grey[900]
                              : Colors.grey[900],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['message'],
                              style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'RobotoCondensed'),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _formatTimestamp1(data['timestamp']),
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                if (data['senderEmail'] == currentUserEmail)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[900],
                    child: Icon(Icons.account_circle, size: 40, color: Colors.amber),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp2(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }

  String _formatTimestamp1(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.hour}:${dateTime.minute}';
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Container(
          child: Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8,20,8,20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30), // Set border radius
                  border: Border.all(color: Colors.grey[800]!), // Set border color
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.amber,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.white,fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: (){
            sendMessage();
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.email)
                .collection("inbox")
                .doc(widget.receiverUserEmail)
                .set({});
            FirebaseFirestore.instance
                .collection('users')
                .doc(widget.receiverUserEmail)
                .collection("inbox")
                .doc(FirebaseAuth.instance.currentUser?.email)
                .set({});
          },
          icon: Icon(Icons.send, size: 35, color: Colors.amber),
        )
      ],
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserEmail, _messageController.text);
      _messageController.clear();
    }
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
