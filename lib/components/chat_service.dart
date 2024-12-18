import 'package:client/models/message.dart';
import 'package:client/widgets/bottomNavigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send message
  Future<void> sendMessage(String receiverId, String message) async {
    try {
      final String currentUserId = _auth.currentUser!.uid;
      final String currentEmail = _auth.currentUser!.email!;
      final Timestamp timestamp = Timestamp.now();

      Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp,
      );

      List<String> users = [currentUserId, receiverId];
      users.sort();
      String chatId = users.join("_");

      await _firestore
          .collection('chat_rooms')
          .doc(chatId)
          .collection('messages')
          .add(newMessage.toMap());
      print(newMessage.toMap());
    } catch (e) {
      debugPrint("Error sending message: $e");
      rethrow;
    }
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> users = [userId, otherUserId];
    users.sort();
    String chatId = users.join("_");

    Stream<QuerySnapshot<Map<String, dynamic>>> chatData = _firestore
        .collection('chat_rooms')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();

    chatData.listen((snapshot) {
      // Print the entire snapshot
      print("Chat Data Snapshot: ${snapshot.docs}");

      // Or you can print specific data from the snapshot
      snapshot.docs.forEach((doc) {
        print("Message: ${doc['message']}, Sender: ${doc['senderId']}");
      });
    });

    return chatData;
  }
}
