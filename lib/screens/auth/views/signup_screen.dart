import 'dart:async';
import 'package:bookstore/screens/admin_panel/Screen/AdminOrderManage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bookstore/route/route_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController fullnameController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool isLoading = false;
bool isChecked = false; // Checkbox state

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
                      const AdminOrderManage()), // Navigate to Admin Panel
            );// Navigate to Admin Panel
    } else {
      Navigator.pushReplacementNamed(context, entryPointScreenRoute); // Navigate to User Screen
    }
  }
}

// Registration function
Future<void> _register() async {
  if (!_formKey.currentState!.validate()) return;

  if (!isChecked) {
    _showSnackbar("You must agree to the terms of service and privacy policy.");
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    // Create user
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Send email verification
    await userCredential.user!.sendEmailVerification();

    // Show loader while waiting for email verification
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoaderPage(),
      ),
    );

    // Start verification process
    _startEmailVerificationTimer(userCredential.user!);
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    _showSnackbar("Registration failed: ${e.toString()}");
  }
}

// Start email verification timer
Timer? _verificationTimer;
void _startEmailVerificationTimer(User user) {
  _verificationTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
    // Refresh user data
    await user.reload();
    User? currentUser = FirebaseAuth.instance.currentUser; // Retrieve current user again
    if (currentUser != null && currentUser.emailVerified) {
      timer.cancel();
      _verificationTimer = null;

      // Store user data in Firestore after confirming the email is verified
      try {
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
          'email': currentUser.email,
          'fullname': fullnameController.text.trim(),
          'role': 'user', // Default role
          'createdAt': DateTime.now(),
        });

        // Save login status and role in SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('uid', currentUser.uid);
        await prefs.setString('role', 'user'); // Default role is user

        // Navigate to entry point screen
        Navigator.pushReplacementNamed(context, entryPointScreenRoute);
      } catch (e) {
        _showSnackbar("Error saving user data. Please try again.");
        Navigator.of(context).pop();
      }
    }
  });

  // Cancel verification timer after 2 minutes
  Future.delayed(const Duration(minutes: 2), () {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && !currentUser.emailVerified) {
      _verificationTimer?.cancel();
      _showSnackbar("Email verification failed. Please try again.");
      Navigator.of(context).pop();
    }
  });
}

// Show snackbar for errors or messages
void _showSnackbar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

@override
void dispose() {
  _verificationTimer?.cancel();
  emailController.dispose();
  passwordController.dispose();
  fullnameController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/signUp_dark.jpg",
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let’s get started!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Please enter your valid data in order to create an account.",
                  ),
                  const SizedBox(height: defaultPadding),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                                        TextFormField(
                          controller: fullnameController,
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Full Name",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                              child: SvgPicture.asset(
                                "assets/icons/Image.svg",
                                height: 24,
                                width: 24,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email address",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                              child: SvgPicture.asset(
                                "assets/icons/Message.svg",
                                height: 24,
                                width: 24,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
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
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                              child: SvgPicture.asset(
                                "assets/icons/Lock.svg",
                                height: 24,
                                width: 24,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                          Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "I agree with the",
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, termsOfServicesScreenRoute);
                                  },
                                text: " Terms of service ",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(
                                text: "& privacy policy.",
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                        const SizedBox(height: defaultPadding),
                        isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: isChecked ? _register : null,
                              child: const Text("Sign Up"),
                            ),
                      ],
                    ),
                  ),
                
                
                  const SizedBox(height: defaultPadding * 2),
                 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Do you have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, logInScreenRoute);
                        },
                        child: const Text("Log in"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoaderPage extends StatelessWidget {
  const LoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Please check your email for verification."),
          ],
        ),
      ),
    );
  }
}
