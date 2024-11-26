import 'package:bookstore/screens/admin_panel/Screen/AdminOrderManage.dart';
import 'package:bookstore/screens/admin_panel/Screen/BookInsertForm.dart';
import 'package:bookstore/screens/admin_panel/Screen/BookView.dart';
import 'package:bookstore/screens/admin_panel/Screen/adminUserAccount.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String name = 'Guest';
  String email = 'guest@example.com';
  String imageUrl =
      'https://e7.pngegg.com/pngimages/518/320/png-clipart-computer-icons-mobile-app-development-android-my-account-icon-blue-text.png';
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (user.providerData.any((info) => info.providerId == 'google.com')) {
          final googleUser = await _googleSignIn.signInSilently();
          if (googleUser != null) {
            setState(() {
              name = googleUser.displayName ?? 'Google User';
              email = googleUser.email;
              imageUrl = googleUser.photoUrl ?? imageUrl;
            });
          }
        } else if (user.isAnonymous) {
          setState(() {
            name = 'Guest';
            email = 'guest@example.com';
          });
        } else {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (userDoc.exists) {
            final data = userDoc.data();
            setState(() {
              name = data?['fullname'] ?? 'User';
              email = data?['email'] ?? email;
              imageUrl = data?['photoUrl'] ?? imageUrl;
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      _showSnackbar('Failed to fetch user data. Please try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : const AssetImage('assets/default_avatar.png')
                                  as ImageProvider,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildDrawerItem(
                  title: 'Book View',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookStoreView()),
                    );
                  },
                ),
                _buildDrawerItem(
                  title: 'Book Insert',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookStoreAdmin()),
                    );
                  },
                ),
                _buildDrawerItem(
                  title: 'Order Management',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminOrderManage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  title: 'User Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminUserAccount()),
                    );
                  },
                ),
                _buildDrawerItem(
                  title: 'Logout',
                  onTap: _handleLogout,
                ),
              ],
            ),
    );
  }

  Future<void> _handleLogout() async {
    setState(() => isLoading = true);
    try {
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.signOut();
      } else {
        await FirebaseAuth.instance.signOut();
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    } catch (e) {
      debugPrint('Error during logout: $e');
      _showSnackbar('Failed to log out. Please try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildDrawerItem(
      {required String title, required VoidCallback onTap}) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}
