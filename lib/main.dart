import 'package:flutter/material.dart';
import 'package:northstars_final/views/nav_bar.dart'; // Import the NavBar file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NavBar Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavBar(), // Use NavBar as the home page
    );
  }
}
