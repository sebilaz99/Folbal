import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> with ChangeNotifier {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column()
    );
  }
}