import 'package:bookstore/constants.dart';
import 'package:bookstore/screens/admin_panel/Screen/DrawerWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminUserAccount extends StatefulWidget {
  const AdminUserAccount({super.key});

  @override
  _AdminUserAccountState createState() => _AdminUserAccountState();
}

class _AdminUserAccountState extends State<AdminUserAccount> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Fetch users from Firestore
  Future<void> _fetchUsers() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore.collection('users').get();
      final userList = querySnapshot.docs.map((doc) {
        return User(
          email:
              doc['email'] ?? 'No Email', // Add default value if email is null
          role: doc['role'] ?? 'No Role', // Add default value if role is null
          uid: doc.id, // Store Firestore document id as UID
        );
      }).toList();

      setState(() {
        users = userList;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }
// Delete user from Firestore (Firebase Authentication doesn't allow deleting other users by email or UID)
Future<void> _deleteUser(String uid) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    // Prevent deleting the currently logged-in user
    if (auth.currentUser?.uid == uid) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You cannot delete the currently logged-in user.'),
      ));
      return;
    }

    // Find user document in Firestore
    final userDoc = await firestore.collection('users').doc(uid).get();
    if (!userDoc.exists) {
      // If user does not exist in Firestore, show a message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User not found.'),
      ));
      return;
    }

    // If user exists, delete their document from Firestore
    await firestore.collection('users').doc(uid).delete();

    setState(() {
      users.removeWhere((user) => user.uid == uid);
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('User deleted successfully from Firestore.'),
    ));
  } catch (e) {
    print('Error deleting user: $e');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Error deleting user.'),
    ));
  }
}


  // Change user role in Firestore
  Future<void> _changeRole(String uid, String newRole) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userDoc = await firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        await userDoc.reference.update({'role': newRole});
      }

      setState(() {
        // Update user role locally
        final index = users.indexWhere((user) => user.uid == uid);
        if (index != -1) {
          users[index].role = newRole;
        }
      });

      print('User role updated to $newRole.');
    } catch (e) {
      print('Error changing user role: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store Admin'),
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50.0),
              Text(
                "User Accounts ",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: defaultPadding),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: users.map((user) {
                  return DataRow(
                    cells: [
                      DataCell(
                          Text(user.email.isEmpty ? user.uid : user.email)),
                      DataCell(Text(user.role)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Handle role change
                                _changeRole(user.uid,
                                    user.role == 'admin' ? 'user' : 'admin');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Confirm before deleting
                                _showDeleteConfirmation(user.uid);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show confirmation before deletion
  void _showDeleteConfirmation(String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteUser(uid);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class User {
  String email;
  String role;
  String uid; // UID field added

  User({required this.email, required this.role, required this.uid});
}
