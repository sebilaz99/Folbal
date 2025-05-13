import 'package:dinte_albastru/model/team_model.dart';
import 'package:dinte_albastru/view_model/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/shirt_widget.dart';

class MatchSettingsScreen extends StatefulWidget {
  const MatchSettingsScreen({super.key});

  @override
  State<MatchSettingsScreen> createState() => _MatchSettingsScreen();
}

class _MatchSettingsScreen extends State<MatchSettingsScreen> {
  ValueNotifier<int> matchDuration = ValueNotifier(0);
  final PageController _pageControllerHome = PageController();
  final PageController _pageControllerAway = PageController();
  ValueNotifier<int> currentHomeTeam = ValueNotifier(0);
  ValueNotifier<int> currentAwayTeam = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageControllerHome.dispose();
    _pageControllerAway.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();
    final List<Team> teams = viewModel.teams;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Match settings',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/drawables/football_pitch.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer_sharp, size: 30, color: Colors.white),
                SizedBox(width: 20),
                Text(
                  "${matchDuration.value.toStringAsFixed(0)}'",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (matchDuration.value < 45) {
                            setState(() {
                              matchDuration.value++;
                            });
                          }
                        },
                        child: Icon(
                          Icons.arrow_drop_up,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (matchDuration.value > 1) {
                            setState(() {
                              matchDuration.value--;
                            });
                          }
                        },
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: PageView.builder(
                                controller: _pageControllerHome,
                                itemCount: teams.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    currentHomeTeam.value = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: Image.asset(
                                      teams[index].logo,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: PageView.builder(
                                controller: _pageControllerAway,
                                itemCount: teams.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    currentAwayTeam.value = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: Image.asset(
                                      teams[index].logo,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: currentHomeTeam,
                        builder: (context, teamIndex, _) {
                          final team = viewModel.teams[currentHomeTeam.value];
                          return CustomPaint(
                            size: Size(70, 70),
                            painter: ShirtPainter(
                              firstColor: team.colors.first,
                              secondColor: team.colors.last,
                            ),
                          );
                        },
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: currentAwayTeam,
                        builder: (context, teamIndex, _) {
                          final team = viewModel.teams[currentAwayTeam.value];
                          return CustomPaint(
                            size: Size(70, 70),
                            painter: ShirtPainter(
                              firstColor: team.colors.first,
                              secondColor: team.colors.last,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: OutlinedButton(
                onPressed: () {
                //  navigateTo(destination, context);
                },
                style: OutlinedButton.styleFrom(
                  overlayColor: Colors.amberAccent,
                  side: const BorderSide(
                    color: Colors.white,
                    width: 2, // Border width
                  ),
                ),
                child: Text("KICK OFF", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
