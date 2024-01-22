import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/dasboard_screens/marketplace/product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'Chatbox.dart';
import 'chat_message.dart';
import 'marketplace_screen.dart';

class ProductDetailsWithChatScreen extends StatefulWidget {
  final Product product;
  final String currentUserId;

  ProductDetailsWithChatScreen({required this.product, required this.currentUserId});

  @override
  _ProductDetailsWithChatScreenState createState() => _ProductDetailsWithChatScreenState();
}

class _ProductDetailsWithChatScreenState extends State<ProductDetailsWithChatScreen> {
  TextEditingController messageController = TextEditingController();
  late String chatRoomId;
  String sellerName = 'Unknown';

  void initState() {
    super.initState();
    // Call fetchSellerName when the screen is initialized
    fetchSellerName();
    // Generate chatRoomId using productId and currentUserId
    chatRoomId = generateChatRoomId(widget.product.id, widget.currentUserId);
  }

  Future<void> fetchSellerName() async {
    try {
      print('Fetching seller ID: ${widget.product.sellerId}');
      DocumentSnapshot sellerSnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.product.sellerId).get();
      print('Seller document data: ${sellerSnapshot.data()}');

      setState(() {
        sellerName = sellerSnapshot['name'] ?? 'Unknown';
      });
    } catch (error) {
      print('Error fetching seller name: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details', style: GoogleFonts.bebasNeue(fontSize: 35, color: Colors.amber)),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[700],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.network(widget.product.imageUrl ?? 'No Image', height: 200, width: 200),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product.name ?? 'Default Name', style: GoogleFonts.bebasNeue(fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 0)),
                    Text('\$${widget.product.price.toString()}', style: GoogleFonts.bebasNeue(fontSize: 28)),
                    Text('Seller: $sellerName', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Divider(),
              ChatBox(productId: widget.product.id, chatRoomId: chatRoomId, currentUserId: widget.currentUserId),
              Divider(),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MarketPlaceScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
          ),
          child: Text('Back to Marketplace', style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 30)),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              _sendMessage();
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String message = messageController.text.trim();
    if (message.isNotEmpty) {
      FirebaseFirestore.instance.collection('privateChats').doc(chatRoomId).collection('messages').add({
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'senderId': widget.currentUserId,
      });
      messageController.clear();
    }
  }

}
