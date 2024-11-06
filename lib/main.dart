
import 'package:bookstore/theme/color.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'startup/get_start.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primary
      ),
      home: get_start(),
    );
  }
}

