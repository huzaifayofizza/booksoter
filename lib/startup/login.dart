


import 'package:bookstore/startup/signup.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
final TextEditingController email = TextEditingController();
final TextEditingController password = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  late VideoPlayerController _controller;
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videos/background.mp4',
    )..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {}); // Update the UI once the video is loaded
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    // Theme(
    //   data: MyThemes.darkTheme, // Apply the dark theme from MyThemes
    //   child: 
      Scaffold(
        body: Stack(
          children: [
            _controller.value.isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : Container(), // Show empty container if video isn't initialized

            // Login Form
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Let's Sign You In",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Welcome Back, You've \nBeen Missed!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/img/Login.png",
                          height: 150,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: email,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter Username',
                              hintStyle: const TextStyle(color: Colors.white70),
                              labelText: 'Username',
                              labelStyle: const TextStyle(color: Colors.white),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: password,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter Password',
                              hintStyle: const TextStyle(color: Colors.white70),
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.white),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberMe,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        rememberMe = newValue ?? false;
                                      });
                                    },
                                  ),
                                  const Text(
                                    "Remember Me",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                              const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                              
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => ()),
                                // );
                              }
                            },
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  // Custom button color
                                  color: Colors.amber),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                 
                       
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't Have Account ",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => signup()),
                                );
                              },
                              child: const Text(
                                "Create One",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    // );
  }
}
