import 'package:fblogin/dasboard_screens/marketplace/Chatbox.dart';
import 'package:fblogin/dasboard_screens/marketplace/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_message.dart';

class ChatPage extends StatefulWidget {
  final Product product;
  final String currentUserId;  // Add the currentUserId property

  ChatPage({required this.product, required this.currentUserId});  // Constructor to initialize currentUserId

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  late String chatRoomId;

  @override
  void initState() {
    super.initState();
    // Generate chatRoomId using productId and currentUserId
    chatRoomId = generateChatRoomId(widget.product.id, widget.currentUserId);

    // Add additional initialization logic here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Text(
          'chat with seller',
          style: GoogleFonts.bebasNeue(
            color: Colors.amber,
            fontSize: 40,
            //letterSpacing: 6,
          ),
        ),
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
          child: Column(
            children: [
              /*
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('privateChats').doc(chatRoomId).collection('messages').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // TODO: Implement chat message display
                    return snapshot.hasData
                        ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        // Customize the chat message widget
                        var messageData = snapshot.data.docs[index].data() as Map<String, dynamic>;
                        return ChatMessage(
                          // Extract necessary data from messageData
                          message: messageData['message'],
                          // Customize other parameters if needed
                        );
                      },
                    )
                        : Center(
                      // Optionally show a loading indicator or a message when data is null
                      child: CircularProgressIndicator(),
                    );
          
                  },
                ),
              ),
               */
              Divider(),
              ChatBox(productId: widget.product.id, chatRoomId: chatRoomId, currentUserId: widget.currentUserId),
          
              _buildMessageInput(),
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
      FirebaseFirestore.instance.collection('privateChats').doc(chatRoomId).collection('messages').add({
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'senderId': widget.currentUserId,
      });
      messageController.clear();
    }
  }
}
