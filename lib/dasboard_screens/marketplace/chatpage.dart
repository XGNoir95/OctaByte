// chat_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Chatbox.dart';


class ChatPage extends StatefulWidget {
  final String chatRoomId;
  final String currentUserId;

  ChatPage({required this.chatRoomId, required this.currentUserId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                List<ChatBox> messages = snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  String message = data['message']?.toString() ?? '';
                  String senderId = data['senderId']?.toString() ?? '';
                  return ChatBox(
                    message: message,
                    isSentByCurrentUser: senderId == widget.currentUserId,
                  );
                }).toList();

                return ListView(
                  children: messages,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String message = _messageController.text.trim();

    if (message.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add({
        'message': message,
        'senderId': widget.currentUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the message input field
      _messageController.clear();
    }
  }
}
