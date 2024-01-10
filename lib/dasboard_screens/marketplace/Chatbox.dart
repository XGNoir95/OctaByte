import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[900],
      child: Column(
        children: [
          Center(child: Text('Chat with Seller', style: GoogleFonts.bebasNeue(fontSize: 38, fontWeight: FontWeight.bold,color: Colors.amber,letterSpacing: 1))),
          SizedBox(height: 10),
          // Example chats:
          Text(''),
          Text(''),
          Text(''),
          Text(''),
          Text(''),
          Text(''),
          Text(''),
          Text(''),
          Text(''),Text(''),Text(''),Text(''),


        ],
      ),
    );
  }
}
