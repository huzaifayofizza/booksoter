import 'package:bookstore/screens/admin_panel/Screen/AdminOrderManage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookstore/constants.dart';
import 'package:bookstore/route/route_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final GoogleSignIn _googleSignIn = GoogleSignIn();

@override
void initState() {
  super.initState();
  _checkLoginStatus();
}

// Check if the user is already logged in
Future<void> _checkLoginStatus() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  if (isLoggedIn) {
    final role = prefs.getString('role') ?? 'user';
    if (role == 'admin') {
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdminOrderManage()), // Navigate to Admin Panel
            );
    } else {
      Navigator.pushReplacementNamed(context, entryPointScreenRoute);
    }
  }
}

// Email and Password Sign-In
Future<void> _signInWithEmailAndPassword() async {
  if (!_formKey.currentState!.validate()) return;

  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    User? user = userCredential.user;

    if (user != null) {
      if (!user.emailVerified) {
        throw Exception("Please verify your email before logging in.");
      }

      // Fetch role from Firestore
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final role = userDoc.data()?['role'] ?? 'user';

        // Save login status, UID, and role locally
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('uid', user.uid);
        await prefs.setString('role', role);

        // Navigate based on role
        if (role == 'admin') {
                   Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdminOrderManage()), // Navigate to Admin Panel
            );
        } else {
          Navigator.pushReplacementNamed(context, entryPointScreenRoute);
        }
      } else {
        throw Exception("User data not found in Firestore.");
      }
    }
  } catch (error) {
    _showErrorSnackBar(error.toString());
  }
}

// Google Sign-In
Future<void> _signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      final uid = user.uid;

      // Fetch role or create a default user document
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
      final userData = await userDoc.get();

      if (!userData.exists) {
        // Create default user data
        await userDoc.set({
          'email': user.email,
          'uid': uid,
          'role': 'user', // Default role
          'createdAt': DateTime.now(),
        });
      }

      final role = (await userDoc.get()).data()?['role'] ?? 'user';

      // Save login status, UID, and role locally
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('uid', uid);
      await prefs.setString('role', role);

      // Navigate based on role
      if (role == 'admin') {
         Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdminOrderManage()), // Navigate to Admin Panel
            );
      } else if (role == 'user') {
        Navigator.pushReplacementNamed(context, entryPointScreenRoute);
      } else {
        throw Exception("Invalid user role: $role");
      }
    }
  } catch (error) {
    _showErrorSnackBar('Google Sign-In Error: $error');
  }
}

// Anonymous Sign-In
Future<void> _continueAsGuest() async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    User? user = userCredential.user;

    if (user != null) {
      final uid = user.uid;

      // Fetch role or create a default user document
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
      final userData = await userDoc.get();

      if (!userData.exists) {
        // Create default user data
        await userDoc.set({
          'email': null, // Guest users don't have emails
          'uid': uid,
          'role': 'user', // Default role for guest users
          'createdAt': DateTime.now(),
        });
      }

      final role = (await userDoc.get()).data()?['role'] ?? 'user';

      // Save login status, UID, and role locally
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('uid', uid);
      await prefs.setString('role', role);

      // Navigate based on role
      if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdminOrderManage()), // Navigate to Admin Panel
            );
      } else if (role == 'user') {
        Navigator.pushReplacementNamed(context, entryPointScreenRoute);
      } else {
        throw Exception("Invalid user role: $role");
      }
    }
  } catch (error) {
    _showErrorSnackBar('Anonymous Sign-In Error: $error');
  }
}

// Show error messages
void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/login_dark.png",
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back!",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    const Text(
                      "Log in with your data that you entered during your registration.",
                    ),
                    const SizedBox(height: defaultPadding),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Email address",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding * 0.75,
                                ),
                                child: SvgPicture.asset(
                                  "assets/icons/Message.svg",
                                  height: 24,
                                  width: 24,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.3),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: defaultPadding),
                          TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding * 0.75,
                                ),
                                child: SvgPicture.asset(
                                  "assets/icons/Lock.svg",
                                  height: 24,
                                  width: 24,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.3),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _signInWithEmailAndPassword,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 50),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(123, 97, 255, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, passwordRecoveryScreenRoute);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 25),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 173, 173, 173),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Forgot password",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        "OR",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: GestureDetector(
                        onTap: _signInWithGoogle,
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 173, 173, 173),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: Image(
                                  image: NetworkImage(
                                      'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png'),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Continue With Google",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: GestureDetector(
                        onTap: _continueAsGuest,
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(123, 97, 255, 1),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(0, 255, 255, 255),
                                radius: 20,
                                child: Image(
                                  image: NetworkImage(
                                      'https://cdn-icons-png.flaticon.com/512/4514/4514759.png'),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Continue With Guest",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, signUpScreenRoute);
                        },
                        child: const Text(
                          "Create account",
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF7B61FF)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
