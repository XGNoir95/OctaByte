import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

class ChatService {
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

    // Show notification if the sender is not the current user
    if (newMessage.senderEmail != currentUserEmail) {
      showNotification('New Message', 'You have received a new message');
    }
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

  String getChatRoomId(String userEmail1, String userEmail2) {
    List<String> emails = [userEmail1, userEmail2];
    emails.sort();
    return emails.join("-");
  }

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
