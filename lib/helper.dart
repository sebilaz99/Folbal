import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dinte_albastru/converters.dart';
import 'package:dinte_albastru/data/repository.dart';
import 'package:dinte_albastru/identifiable.dart';
import 'package:dinte_albastru/model/team_model.dart';
import 'package:dinte_albastru/my_logger.dart';
import 'package:dinte_albastru/view_model/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  DatabaseFactory databaseFactory = databaseFactoryIo;
  Database? db;
  final store = intMapStoreFactory.store('store_reference');
  final playerStore = intMapStoreFactory.store('players');
  final teamStore = intMapStoreFactory.store('teams');
  final registrationRequestsStore = intMapStoreFactory.store('requests');

  Helper._internal();

  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
  Connectivity connectivity = Connectivity();

  StreamSubscription<Position>? positionSubscription;

  // Shared Preferences
  Future setPreference<T>(String key, T value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value is String) {
        return prefs.setString(key, value);
      } else if (value is int) {
        return prefs.setInt(key, value);
      } else if (value is double) {
        return prefs.setDouble(key, value);
      } else if (value is bool) {
        return prefs.setBool(key, value);
      } else if (value is List<String>) {
        return prefs.setStringList(key, value);
      } else {
        throw UnsupportedError('Type ${value.runtimeType} is not supported');
      }
    } on Exception catch (_) {
      return false;
    }
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  void callback<T>(void Function(T) parameter) {
    callback(parameter);
  }

  // Sembast DB
  static final Helper instance = Helper._internal();

  factory Helper() {
    return instance;
  }

  Future<Database> get database async {
    if (db != null) return db!;

    db = await openDb();
    return db!;
  }

  Future<Database> openDb() async {
    final docsPath = await getApplicationCacheDirectory();
    final dbPath = join(docsPath.path, 'quotes.db');
    final db = await databaseFactory.openDatabase(dbPath);
    return db;
  }

  Future<int> insertRecord(
    StoreRef<int, Map<String, Object?>> store,
    Map<String, dynamic> record,
  ) async {
    try {
      Database db = await openDb();
      final key = await store.add(db, record);
      return key;
    } catch (e) {
      return 0;
    }
  }

  Future<List<T>> retrieveData<T extends Identifiable>(
    String field,
    StoreRef<int, Map<String, Object?>> store,
    T Function(Map<String, dynamic>) factory,
  ) async {
    Database db = await openDb();
    final finder = Finder(sortOrders: [SortOrder(field)]);
    final records = await store.find(db, finder: finder);
    return records.map((item) {
      final record = Converters().genericFromJson(item.value, factory);
      record.id = item.key;
      return record;
    }).toList();
  }

  Future<List<T>> retrieveDataWithoutSort<T extends Identifiable>(
    StoreRef<int, Map<String, Object?>> store,
    T Function(Map<String, dynamic>) factory,
  ) async {
    Database db = await openDb();
    final records = await store.find(db);
    return records.map((item) {
      final record = Converters().genericFromJson(item.value, factory);
      record.id = item.key;
      return record;
    }).toList();
  }

  Future<void> deleteData(
    StoreRef<dynamic, Map<String, Object?>> store,
    dynamic identifier,
    String queryField,
  ) async {
    Database db = await openDb();
    final finder = Finder(filter: Filter.equals(queryField, identifier));
    await store.delete(db, finder: finder);
  }

  Future<List<RecordSnapshot<int, Map<String, dynamic>>>> searchBy(
    String queryField,
    String query,
  ) async {
    Database db = await openDb();
    if (query.isEmpty) return [];
    final finder = Finder(filter: Filter.matches(queryField, query));
    return await store.find(db, finder: finder);
  }

  // GETIT DI
  final locator = GetIt.instance;

  void setupLocator() {
    locator.registerSingleton(Repository());
    locator.registerLazySingleton<SettingsViewModel>(() => SettingsViewModel());
  }

  // NETWORK CONNECTIVITY
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }

    return updateConnectivityStatus(result);
  }

  Future<void> updateConnectivityStatus(List<ConnectivityResult> result) async {
    connectionStatus = result;
  }

  Future<void> trackSpeed(void onServiceDisabled) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) onServiceDisabled;
  }

  Stream<Position> positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    ),
  );

  void startTrackingSpeed() {
    positionSubscription = positionStream.listen(
      (Position position) {},
      onError: (error) {
        logger.e("SpeedTracking:: $error");
      },
    );
  }

  void stopTrackingSpeed() {
    positionSubscription?.cancel();
  }

  Future<void> initializeTeams() async {
    final db = await openDb();
    final teamsInStore = await teamStore.find(db);
    if (teamsInStore.isEmpty) {
      final teams = [
        TeamEntity(
          name: "Chelsea FC",
          logo: 'assets/drawables/chelsea_logo.jpg',
          players: [],
          colors: [Colors.blueAccent, Colors.white],
        ),
        TeamEntity(
          name: "Manchester City",
          logo: 'assets/drawables/man_city_logo.jpg',
          players: [],
          colors: [Colors.red, Colors.white],
        ),
        TeamEntity(
          name: "Burnley",
          logo: 'assets/drawables/burnley_logo.png',
          players: [],
          colors: [Colors.pink, Colors.amber],
        ),
      ];
      for (var team in teams) {
        await teamStore.add(db, team.toJson());
        logger.i("HELPER:: ${team.logo}");
      }
    }
  }

  void showToast(
    BuildContext context,
    String message, {
    Color color = Colors.redAccent,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
