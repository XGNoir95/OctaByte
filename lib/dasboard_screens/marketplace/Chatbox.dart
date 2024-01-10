import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Chat with Seller', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          // Add chat messages here (you might want to use a ListView.builder)
          // Example:
          Text('Seller: Hello! How can I help you?'),
          Text('You: I have a question about the product.'),
          // Add more messages as needed
        ],
      ),
    );
  }
}
