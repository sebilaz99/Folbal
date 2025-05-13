import 'dart:convert';

import 'package:http/http.dart' as http;

class ResponseState<T> {
  bool isLoading = false;
  T? data;
  String? error;

  Future<void> fetchData(String baseUrl, T Function(dynamic json) fromJson) async {
    isLoading = true;

    try {
      final Uri url = Uri.parse(baseUrl);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        data = fromJson(json.decode(response.body));
        error = null;
      } else {
        error = response.statusCode.toString();
        print("Error: $error");
      }
    } catch (e) {
      error = e.toString();
      print("Exception $error");
    } finally {
      isLoading = false;
    }
  }  
}
