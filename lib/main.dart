import 'package:dinte_albastru/helper.dart';
import 'package:dinte_albastru/my_logger.dart';
import 'package:dinte_albastru/network_provider.dart';
import 'package:dinte_albastru/ui/screens/admin/admin_dashboard_screen.dart';
import 'package:dinte_albastru/ui/screens/main_screen.dart';
import 'package:dinte_albastru/ui/screens/match_screen.dart';
import 'package:dinte_albastru/ui/screens/registration/registration_screen.dart';
import 'package:dinte_albastru/ui/screens/splash_screen.dart';
import 'package:dinte_albastru/view_model/registration_view_model.dart';
import 'package:dinte_albastru/view_model/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  Helper();
  Helper().setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Helper().initializeTeams();
  } catch (e) {
    logger.e("Error initializing teams: $e");
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(create: (_) => RegistrationViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settingsViewModel = Provider.of<SettingsViewModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MatchScreen(),
      navigatorObservers: [routeObserver],
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        fontFamily: 'Racing'
      ),
      themeMode:
          settingsViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
