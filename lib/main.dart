import 'package:flutter/material.dart';
import 'package:flutter_lab/pages/login.dart';

void main() {
  runApp(const FlutterLab());
}

class FlutterLab extends StatelessWidget {
  const FlutterLab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const LoginPage() ,
    );
  }
}
