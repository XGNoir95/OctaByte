// chat_box.dart

import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  final String message;
  final bool isSentByCurrentUser;

  ChatBox({required this.message, required this.isSentByCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      alignment: isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSentByCurrentUser ? Colors.blue : Colors.grey[800],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
