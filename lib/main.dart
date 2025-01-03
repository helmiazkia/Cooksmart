import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart'; // Import WelcomeScreen

void main() {
  runApp(const CookSmartApp());
}

class CookSmartApp extends StatelessWidget {
  const CookSmartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookSmart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const WelcomeScreen(), // Set WelcomeScreen sebagai halaman awal
    );
  }
}
