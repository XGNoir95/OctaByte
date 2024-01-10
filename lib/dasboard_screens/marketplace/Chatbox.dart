import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Center(child: Text('Chat with Seller', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          SizedBox(height: 10),
          // Example chats:
          Text('Seller: Hello! How can I help you?'),
          Text('You: I have a question about the product.'),
        ],
      ),
    );
  }
}
