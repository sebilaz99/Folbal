import 'package:flutter/material.dart';

class ShirtPainter extends CustomPainter {
  final Color firstColor;
  final Color secondColor;

  ShirtPainter({required this.firstColor, required this.secondColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
    Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [firstColor, secondColor],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final shirtWidth = size.width;
    final shirtHeight = size.height;
    final path = Path();

    path.moveTo(shirtWidth * 0.2, 0);
    path.lineTo(shirtWidth * 0.1, shirtHeight * 0.25);
    path.lineTo(shirtWidth * 0.25, shirtHeight * 0.35);

    path.lineTo(shirtWidth * 0.25, shirtHeight * 0.7); // shorter body

    path.lineTo(shirtWidth * 0.75, shirtHeight * 0.7);

    path.lineTo(shirtWidth * 0.75, shirtHeight * 0.35);
    path.lineTo(shirtWidth * 0.9, shirtHeight * 0.25);

    path.lineTo(shirtWidth * 0.8, 0);

    path.arcToPoint(
      Offset(shirtWidth * 0.2, 0),
      radius: Radius.circular(30),
      clockwise: false,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
