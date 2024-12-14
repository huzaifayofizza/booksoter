import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({super.key});

  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  String? adminId; // To store the admin's UID dynamically
  final messageController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    _fetchAdminId();
  }

  // Fetch admin UID based on the 'role' field
  Future<void> _fetchAdminId() async {
    final adminQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .limit(1)
        .get();

    if (adminQuery.docs.isNotEmpty) {
      setState(() {
        adminId = adminQuery.docs.first.id;
      });
    }
  }

  // Create a room if it doesn't exist
  Future<void> _createRoomIfNotExist() async {
    if (adminId == null) return;

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final roomId = _getRoomId();

    final roomDoc =
        await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();
    if (!roomDoc.exists) {
      // Create the room if it doesn't exist
      await FirebaseFirestore.instance.collection('rooms').doc(roomId).set({
        'userId': userId,
        'adminId': adminId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (adminId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat with Admin')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(_getRoomId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isAdmin = message['senderId'] == userId;
                    final status = message['status'] ?? 'sent';
                    final timestamp = message['timestamp'] as Timestamp?;

                    final messageTime = timestamp != null
                        ? '${timestamp.toDate().hour}:${timestamp.toDate().minute.toString().padLeft(2, '0')}'
                        : '';

                    return Align(
                      alignment: isAdmin
                          ? Alignment.centerRight // Admin message aligned left
                          : Alignment.centerLeft, // User message aligned right
                      child: Column(
                        crossAxisAlignment: isAdmin
                            ? CrossAxisAlignment
                                .end // Admin's message on the left
                            : CrossAxisAlignment
                                .start, // User's message on the right
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: isAdmin
                                  ? Colors.amber[200] // Admin message color
                                  : Colors.grey[300], // User message color
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(message['text']),
                                const SizedBox(height: 4),
                                Text(
                                  'Sent at: $messageTime',
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    final messageText = messageController.text.trim();
                    if (messageText.isNotEmpty) {
                      await _createRoomIfNotExist();
                      await _sendMessage(messageText);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to generate room ID
  String _getRoomId() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return [userId, adminId].join('_');
  }

  // Function to send a message
  Future<void> _sendMessage(String text) async {
    final roomId = _getRoomId();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final message = {
      'text': text,
      'senderId': userId,
      'status': 'sent', // Initial status
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .add(message);

    // Update message to 'delivered' after sending
    Future.delayed(const Duration(seconds: 2), () async {
      final lastMessage = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (lastMessage.docs.isNotEmpty) {
        await lastMessage.docs.first.reference.update({'status': 'delivered'});
      }
    });
  }
}
