import 'package:dinte_albastru/data/repository.dart';
import 'package:dinte_albastru/helper.dart';
import 'package:dinte_albastru/model/player_model.dart';
import 'package:dinte_albastru/my_logger.dart';
import 'package:dinte_albastru/utils.dart';
import 'package:flutter/cupertino.dart';

import '../model/team_model.dart';

class SettingsViewModel extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  double _matchDuration = 0.0;

  double get matchDuration => _matchDuration;

  List<Team> _teams = List.empty(growable: true);

  List<Team> get teams => _teams;

  List<Player> _players = List.empty(growable: true);

  List<Player> get players => _players;

  SettingsViewModel() {
    getThemeMode();
    getTeams();
    getPlayers();
  }

  Future<void> getThemeMode() async {
    try {
      final themeMode = await Helper().getBool(Utils().themeKey);
      _isDarkMode = themeMode ?? false;
    } catch (e) {
      _isDarkMode = false; // fallback
      logger.e("Error loading theme: $e");
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setThemeMode(bool value) async {
    _isDarkMode = value;
    Helper().setPreference(Utils().themeKey, value);
    notifyListeners();
  }

  Future<void> getMatchDuration() async {
    final matchDuration = await Helper().getDouble(Utils().matchDurationKey);
    _matchDuration = matchDuration ?? 0.0;
    notifyListeners();
  }

  Future<void> getTeams() async {
    try {
      final allTeams = await Repository().getAllTeams();
      if (allTeams.isEmpty) {
        _teams = [];
      } else {
        _teams = allTeams.map((team) => team.toModel).toList();
      }
      logger.e("SettingsViewModel:: Teams are ${_teams.first.name.isEmpty}");
      notifyListeners();
    } catch (e) {
      logger.e("SettingsViewModel:: Exception is $e");
    }
  }

  Future<void> getPlayers() async {
    try {
      _players =
          (await Repository().getAllPlayers())
              .map((player) => player.toModel)
              .toList();
    } catch (e) {
      logger.e("SettingsViewModel:: Exception is $e");
    }
  }
}
