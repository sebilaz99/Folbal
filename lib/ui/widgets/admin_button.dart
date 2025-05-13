import 'package:dinte_albastru/ui/widgets/small_widgets.dart';
import 'package:flutter/material.dart';

class AdminButton extends StatelessWidget {
  final String buttonText;
  final IconData icon;
  final VoidCallback onPress;
  final bool isRedDotVisible;

  const AdminButton({
    super.key,
    required this.buttonText,
    required this.icon,
    required this.onPress,
    this.isRedDotVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 110,
          height: 110,
          child: Card(
            color: Colors.white,
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: InkWell(
              onTap: onPress,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(icon),
                      Text(buttonText, style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Widgets().smallRedCircle(isRedDotVisible),
        ),
      ],
    );
  }
}
