import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/dasboard_screens/marketplace/chatpage.dart';
import 'package:fblogin/dasboard_screens/marketplace/product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Chatbox.dart';
import 'chat_message.dart';
import 'marketplace_screen.dart';

class ProductDetailsWithChatScreen extends StatefulWidget {
  final Product product;
  final String currentUserId;

  ProductDetailsWithChatScreen(
      {required this.product, required this.currentUserId});

  @override
  _ProductDetailsWithChatScreenState createState() =>
      _ProductDetailsWithChatScreenState();
}

class _ProductDetailsWithChatScreenState
    extends State<ProductDetailsWithChatScreen> {
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
      DocumentSnapshot sellerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.product.sellerId)
          .get();
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
        //automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: Text('Product Details',
            style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 40)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.cover,
            width: 411.4, // Specify an appropriate width
            height: 770.3, // Specify an appropriate height
            alignment: Alignment.center,
          ),
          SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(
                      color: Colors.grey[700]!,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.network(
                            widget.product.imageUrl ?? 'No Image',
                            height: 200,
                            width: 200),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.product.name ?? 'Default Name',
                                style: GoogleFonts.bebasNeue(
                                    fontSize: 40, color: Colors.amber)),
                            Text('\$${widget.product.price.toString()}',
                                style: GoogleFonts.bebasNeue(
                                    fontSize: 28, color: Colors.grey)),
                            Text('Seller: $sellerName',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey)),
                            SizedBox(
                              height: 50,
                            ),
                            GestureDetector(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(' Chat with Seller!',
                                      style: GoogleFonts.bebasNeue(
                                          fontSize: 40, color: Colors.amber)),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(Icons.message,
                                      color: Colors.amber, size: 40),
                                ],
                              ),
                              // In the calling widget
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                        product: widget.product,
                                        currentUserId: widget.currentUserId),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
      FirebaseFirestore.instance
          .collection('privateChats')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'senderId': widget.currentUserId,
      });
      messageController.clear();
    }
  }
}
