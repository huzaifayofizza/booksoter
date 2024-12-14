import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminChatScreen extends StatefulWidget {
  final String roomId;

  const AdminChatScreen({super.key, required this.roomId});

  @override
  _AdminChatScreenState createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(widget.roomId)
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
                    final isAdmin = message['senderId'] ==
                        FirebaseAuth.instance.currentUser!.uid;
                    final status = message['status'];
                    final timestamp = message['timestamp'] as Timestamp?;

                    if (!isAdmin && status != 'read') {
                      // Mark the message as "read" when it's displayed
                      FirebaseFirestore.instance
                          .collection('rooms')
                          .doc(widget.roomId)
                          .collection('messages')
                          .doc(message.id)
                          .update({'status': 'read'});
                    }

                    // Format the message time
                    final messageTime = timestamp != null
                        ? '${timestamp.toDate().hour}:${timestamp.toDate().minute.toString().padLeft(2, '0')}'
                        : '';

                    return Align(
                      alignment: isAdmin
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isAdmin
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: isAdmin
                                  ? Colors.amber[200]
                                  : Colors.grey[300],
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
                          if (!isAdmin)
                            Text(
                              'Status: ${status.toUpperCase()}',
                              style: TextStyle(
                                fontSize: 12,
                                color: status == 'read'
                                    ? Colors.green
                                    : Colors.grey,
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

  // Function to send a message
  Future<void> _sendMessage(String text) async {
    final adminId = FirebaseAuth.instance.currentUser!.uid;

    final message = {
      'text': text,
      'senderId': adminId,
      'status': 'sent', // Initial status
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('messages')
        .add(message);

    // Optionally update status to "delivered" after a delay
    Future.delayed(const Duration(seconds: 2), () async {
      final lastMessage = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
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
