import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:dinte_albastru/navigator.dart';
import 'package:dinte_albastru/utils.dart';

import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String lottieJson = Utils().emptyString;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Future<void> loadLottie() async {
    final response = await http.get(Uri.parse(Utils().lottieSplashAnimation));
    if (response.statusCode == Utils().statusCodeOk) {
      setState(() {
        lottieJson = response.body;
      });
    } else {
      log("Failed to load Lottie JSON");
    }
  }

  Future<bool> _delayedDisplay() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<bool>(
          future: _delayedDisplay(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return Lottie.memory(
                utf8.encode(lottieJson),
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text("Failed to load animation");
                },
              );
            }
          },
        ),
      ),
    );
  }

  Timer startTimer() {
    var duration = const Duration(seconds: 5);
    loadLottie();
    return Timer(duration, route);
  }

  route() => replace(const MainScreen(), context);
}
