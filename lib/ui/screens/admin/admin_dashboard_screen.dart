import 'package:dinte_albastru/navigator.dart';
import 'package:dinte_albastru/ui/screens/admin/admin_requests_screen.dart';
import 'package:dinte_albastru/ui/screens/home_screen.dart';
import 'package:dinte_albastru/ui/screens/registration/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../view_model/registration_view_model.dart';
import '../match_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registrationRequests =
        context.watch<RegistrationViewModel>().requests;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Welcome back, Sebastian",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.blueAccent,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.blueAccent,
            tabs: [
              Tab(text: 'Teams'),
              Tab(text: 'Players'),
              Tab(
                text: 'Requests',
                icon:
                    registrationRequests.isEmpty
                        ? null
                        : Icon(Icons.new_releases_outlined, color: Colors.red),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 1,
                child: Image.asset(
                  'assets/drawables/chairman.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            TabBarView(
              children: [RegistrationScreen(), MatchScreen(), RequestsScreen()],
            ),
          ],
        ),
      ),
    );
  }

  void handleButtonPress(Widget destination, BuildContext context) {
    navigateTo(destination, context);
  }
}
