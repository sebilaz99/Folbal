import 'package:flutter/material.dart';

class Widgets {
  Widget smallRedCircle(bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: Container(
        width: 20, // diameter
        height: 20,
        decoration: BoxDecoration(
          color: Colors.redAccent, // fill color
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget rotateDeviceDialog(bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: Dialog(
        elevation: 5,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.screen_rotation),
              SizedBox(height: 20),
              Text(
                "Please rotate your device to landscape mode",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
