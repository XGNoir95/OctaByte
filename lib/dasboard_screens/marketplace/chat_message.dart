import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Chatbox.dart';
import 'chat_message.dart';

class ChatBox extends StatelessWidget {
  final String productId;
  final String chatRoomId;
  final String currentUserId;

  ChatBox({required this.productId, required this.chatRoomId, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('privateChats').doc(chatRoomId).collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<ChatMessage> messages = snapshot.data!.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Handle null timestamp
          DateTime timestamp = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

          return ChatMessage(
            text: data['message'],
            timestamp: timestamp,
            senderId: data['senderId'],
          );
        }).toList();


        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var message in messages)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text('${message.text} - ${message.senderId}', style: TextStyle(fontSize: 16)),
              ),
          ],
        );
      },
    );
  }
}
