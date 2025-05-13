import 'package:dinte_albastru/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:dinte_albastru/navigator.dart';
import 'package:dinte_albastru/ui/screens/quotes_screen.dart';
import 'package:dinte_albastru/ui/screens/settings_screen.dart';

import 'home_screen.dart';
import 'match_dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  final List<Widget> screens = [
    const HomeScreen(),
    const SettingsScreen(),
    const MatchDashboardScreen()
  ];

  final List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.bluetooth),
      label: 'Bluetooth',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: currentIndex.value,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: items,
          currentIndex: currentIndex.value,
          onTap: (index) => {
            if (index == 3) {
              navigateTo(const MatchDashboardScreen(), context)
            } else
              {
                setState(() => currentIndex.value = index)
              }
          },
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.darkCoral,
          selectedLabelStyle: TextStyle(color: AppColors.darkCoral),
          iconSize: 20.0,
        ));
  }
}
