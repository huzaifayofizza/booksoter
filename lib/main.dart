import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/route/route_constants.dart';
import 'package:bookstore/route/router.dart' as router;
import 'package:bookstore/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart'; // Import the generated options file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Call the method to check if it's the first time
  String initialRoute = await getInitialRoute();

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Book Store App',
      theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light, // Dark theme is included in the Full template
      onGenerateRoute: router.generateRoute,
      initialRoute: initialRoute,
    );
  }
}

// This method checks if it's the first time the user opens the app
Future<String> getInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  bool? isFirstTime = prefs.getBool('isFirstTime') ?? true;

  if (isFirstTime) {
    await prefs.setBool('isFirstTime', false); // Set to false after the first launch
    return onbordingScreenRoute; // Return the Onboarding route if it's the first time
  } else {
    return logInScreenRoute; // Navigate to Login if it's not the first time
  }
}
