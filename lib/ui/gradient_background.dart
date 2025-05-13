import 'package:flutter/cupertino.dart';

import '../theme/colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
           AppColors.darkCoral,
           AppColors.mediumCoral,
           AppColors.lightCoral,
          ],
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
