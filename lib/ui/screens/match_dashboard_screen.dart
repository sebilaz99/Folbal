import 'package:dinte_albastru/ui/screens/match_settings_screen.dart';
import 'package:flutter/material.dart';

class MatchDashboardScreen extends StatefulWidget {
  const MatchDashboardScreen({super.key});

  @override
  State<MatchDashboardScreen> createState() => _MatchDashboardScreen();
}

class _MatchDashboardScreen extends State<MatchDashboardScreen> {
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  final List<Widget> screens = [
    const MatchSettingsScreen(),
    // to change with kick-off screen
    const MatchDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
    );
  }
}
