import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverEmail;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverEmail,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }
}

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverEmail, String message) async {
    final String currentUser = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUser,
      senderEmail: currentUserEmail,
      receiverEmail: receiverEmail,
      message: message,
      timestamp: timestamp,
    );

    String chatRoomId = getChatRoomId(currentUserEmail, receiverEmail);
    CollectionReference messagesCollection = _firestore.collection('chatRoom').doc(chatRoomId).collection('messages');
    await messagesCollection.add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(String? userEmail, String otherUserEmail) {
    if (userEmail == null) {
      throw ArgumentError('userEmail cannot be null');
    }

    String chatRoomId = getChatRoomId(userEmail, otherUserEmail);
    return _firestore
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<List<String>> getBuyersForSeller(String sellerEmail) async {
    try {
      QuerySnapshot<Map<String, dynamic>> chatRoomsSnapshot = await _firestore
          .collection('chatRoom')
          .where('sellerEmail', isEqualTo: sellerEmail)
          .get();

      List<String> buyers = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> chatRoomSnapshot
      in chatRoomsSnapshot.docs) {
        String buyerEmail = extractBuyerEmail(chatRoomSnapshot.id, sellerEmail);
        buyers.add(buyerEmail);
      }

      return buyers;
    } catch (error) {
      print('Error getting buyers for seller: $error');
      return [];
    }
  }

  String extractBuyerEmail(String chatRoomId, String sellerEmail) {
    String emailsPart = chatRoomId.replaceAll('$sellerEmail-', '');
    List<String> emailParts = emailsPart.split('-');
    return emailParts[0]; // Assuming the buyer's email is the first part
  }

  String getChatRoomId(String userEmail1, String userEmail2) {
    List<String> emails = [userEmail1, userEmail2];
    emails.sort();
    return emails.join("-");
  }
}
