import 'package:flutter/material.dart';

void navigateTo(Widget destination, BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) => destination));
}

void replace(Widget destination, BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => destination));
}

void navigateWithAnimation(Widget destination, BuildContext context) {
  Navigator.of(context).push(fadeRoute(destination));
}

void navigateBack(BuildContext context) {
  Navigator.pop(context);
}

PageRouteBuilder fadeRoute(Widget page) {
  return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      });
}
