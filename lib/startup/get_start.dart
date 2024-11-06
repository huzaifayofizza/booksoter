import 'package:bookstore/startup/login.dart';
import 'package:bookstore/startup/signup.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class get_start extends StatefulWidget {
  const get_start({super.key});

  @override
  State<get_start> createState() => _get_startState();
}

class _get_startState extends State<get_start> {
  // Video player controller
  late VideoPlayerController _controller;

  // Boolean variable to track checkbox state
  bool isChecked = false;

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
    return Scaffold(
      body: Stack(
        children: [
          // Video background
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
              : Container(),

          // Overlay content with horizontal centering in the column
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Horizontal center alignment
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Welcome ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.amber),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    " Book Lovers!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/img/Login.png",
                        height: 170,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 15),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "By continuing, you agree to our",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 255, 255, 255)),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Add navigation to Privacy Policy page or link
                                  print("Privacy Policy tapped");
                                },
                                child: const Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const Text(
                                " and ",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Add navigation to Terms and Conditions page or link
                                  print("Terms and Conditions tapped");
                                },
                                child: const Text(
                                  "Terms and Conditions",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Checkbox for Terms and Conditions agreement
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      const Text(
                        "I agree to the Terms and Conditions",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Continue with Google button
                  Center(
                    child: GestureDetector(
                      onTap: isChecked
                          ? () {
                              // Navigate to the next screen when checkbox is checked
                              print("Google continue tapped");
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => google()),
                              // );
                            }
                          : null,
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 255, 255, 255),
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
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 97, 95, 95)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: GestureDetector(
                      onTap: isChecked
                          ? () {
                              // Navigate to Signup page when checkbox is checked
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => signup()),
                              );
                            }
                          : null,
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color.fromARGB(0, 0, 0, 0),
                              radius: 20,
                              child: Image(
                                image: NetworkImage(
                                    'https://cdn4.iconfinder.com/data/icons/social-media-logos-6/512/112-gmail_email_mail-512.png'),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Continue With Email",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 97, 95, 95)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: GestureDetector(
                      onTap: isChecked
                          ? () {
                              // Navigate to Login page when checkbox is checked
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            }
                          : null,
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color.fromARGB(0, 255, 255, 255),
                              radius: 20,
                              child: Image(
                                image: NetworkImage(
                                    'https://cdni.iconscout.com/illustration/premium/thumb/login-illustration-download-in-svg-png-gif-file-formats--select-an-account-join-the-forum-password-digital-marketing-pack-business-illustrations-8333958.png?f=webp'),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Continue With Login",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 97, 95, 95)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
