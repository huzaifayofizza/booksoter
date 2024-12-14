import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookstore/screens/admin_panel/Screen/chatscreen.dart';

class AdminChatRoomList extends StatelessWidget {
  const AdminChatRoomList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Chats'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .snapshots(), // Listen to changes in the rooms collection
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No active chats'));
          }

          final rooms = snapshot.data!.docs;

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              final roomId = room.id; // Use the room ID directly
              final userId = room[
                  'userId']; // Assuming the userId is stored in the room document

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(title: Text('Loading user data...'));
                  }

                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: const Text('Error loading user'),
                      subtitle: Text(userSnapshot.error.toString()),
                    );
                  }

                  final userData = userSnapshot.data!;
                  final userName = userData['fullname'] ?? 'Guest'; // Default to 'Guest' if fullname is not found
                  final userAvatar = userData['imageUrl'] ??
                      'https://www.example.com/default-avatar.png';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(userAvatar), // Avatar image
                        onBackgroundImageError: (_, __) =>
                            const Icon(Icons.account_circle, size: 40),
                      ),
                      title: Text(userName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(roomId)
                            .collection('messages')
                            .orderBy('timestamp', descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context, messageSnapshot) {
                          if (!messageSnapshot.hasData ||
                              messageSnapshot.data!.docs.isEmpty) {
                            return const Text('No messages yet');
                          }

                          final lastMessage =
                              messageSnapshot.data!.docs.first['text'];
                          final timestamp = messageSnapshot
                              .data!.docs.first['timestamp'] as Timestamp?;
                          final time = timestamp != null
                              ? '${timestamp.toDate().hour}:${timestamp.toDate().minute.toString().padLeft(2, '0')}'
                              : '';

                          return Row(
                            children: [
                              Expanded(
                                  child: Text(lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)),
                              Text(
                                time,
                                style:
                                    const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          );
                        },
                      ),
                      onTap: () {
                        // Navigate to the chat screen for the selected room
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AdminChatScreen(roomId: roomId),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement functionality for creating a new chat or any admin action
        },
        tooltip: 'Create New Chat',
        child: Icon(Icons.add),
      ),
    );
  }
}
