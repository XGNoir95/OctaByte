
// chat_message.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String text;
  final DateTime timestamp;
  final String senderId;

  ChatMessage({required this.text, required this.timestamp, required this.senderId});
}
// utilities.dart
String generateChatRoomId(String sellerId, String buyerId) {
  List<String> sortedIds = [sellerId, buyerId]..sort();
  return '${sortedIds[0]}_${sortedIds[1]}';
}

