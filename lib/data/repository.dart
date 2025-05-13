import 'dart:convert';

import 'package:dinte_albastru/converters.dart';
import 'package:dinte_albastru/data/response_state.dart';
import 'package:dinte_albastru/helper.dart';
import 'package:dinte_albastru/model/player_model.dart';
import 'package:dinte_albastru/model/quote_entity.dart';
import 'package:dinte_albastru/model/quote_model.dart';
import 'package:dinte_albastru/model/registration_request.dart';
import 'package:dinte_albastru/my_logger.dart';
import 'package:dinte_albastru/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/team_model.dart';

class Repository {
  Helper helper = Helper();
  final ResponseState responseState = ResponseState();

  //Prefs methods
  Future saveToPrefs(
    String key,
    String value,
    void Function(String destination) navigateTo,
    void Function() navigateBack,
    String? destination,
    BuildContext context,
  ) async {
    await helper.setPreference(key, value);
    if (destination?.isNotEmpty ?? false) {
      navigateTo(destination!);
    } else {
      navigateBack();
    }
  }

  Future saveToPrefsWithoutNavi(String key, String value) async {
    await helper.setPreference(key, value);
  }

  Future getQuote() async {
    final Uri url = Uri.parse(Utils().baseUrl);
    await responseState.fetchData(
      Utils().baseUrl,
      (json) => Converters().fromJson(json),
    );

    final response = await http.get(url);
    List quoteJson = json.decode(response.body);
    QuoteModel quoteModel = Converters().fromJson(quoteJson[0]);
    return quoteModel;
  }

  //DB methods
  Future<int> insertQuote(Map<String, String> map) async {
    int key = await helper.insertRecord(Helper().store, map);
    return key;
  }

  Future<List<QuoteEntity>> getQuotes({String sortByField = 'a'}) async {
    return await helper.retrieveData(
      sortByField,
      Helper().store,
      (map) => QuoteEntity.fromJson(map),
    );
  }

  Future<void> deleteFavQuote(int id) async {
    return helper.deleteData(Helper().store, id, 'q');
  }

  Future<List<QuoteEntity>> searchQuoteByText(String query) async {
    if (query.isEmpty) return [];
    final results = await helper.searchBy('q', query);
    return results
        .whereType<Map<String, dynamic>>()
        .map((map) => QuoteEntity.fromMap(map))
        .toList();
  }

  Future<int> insertTeam(Map<String, Team> map) async {
    int key = await helper.insertRecord(Helper().teamStore, map);
    return key;
  }

  Future<int> insertPlayer(Map<String, Player> map) async {
    int key = await helper.insertRecord(Helper().playerStore, map);
    return key;
  }

  Future<List<TeamEntity>> getAllTeams({
    String sortByField = 'team_name',
  }) async {
    var teams = await helper.retrieveData(
      sortByField,
      Helper().teamStore,
      (map) => TeamEntity.fromJson(map),
    );
    logger.i("HELPER:: ${teams.first.name}");
    return teams;
  }

  Future<List<PlayerEntity>> getAllPlayers({
    String sortByField = 'player_fullname',
  }) async {
    return await helper.retrieveData(
      sortByField,
      Helper().playerStore,
      (map) => PlayerEntity.fromJson(map),
    );
  }

  Future<int> createRegistrationRequest(RegistrationRequest request) async {
    int key = await helper.insertRecord(
      Helper().registrationRequestsStore,
      request.toMap(),
    );
    return key;
  }

  Future<List<RegistrationRequestEntity>> getAllRequests() async {
    return await helper.retrieveDataWithoutSort(
      Helper().registrationRequestsStore,
      (map) => RegistrationRequestEntity.fromJson(map),
    );
  }

  Future<void> deleteRegistrationEntity(String name) async {
    return helper.deleteData(Helper().registrationRequestsStore, name, "fullName");
  }
}
