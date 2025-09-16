import 'dart:convert';
import 'package:blue_art_mad2/network/core.dart';
import 'package:blue_art_mad2/services/localSharedPreferences.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';
import 'package:http/http.dart' as http;

class AuthLogin {
  final http.Client client;

  AuthLogin({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await client.post(
      Uri.parse(Network.login),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    final result = json.decode(response.body);

    if (response.statusCode == 200) {
      await LocalSharedPreferences.saveString(SharedPrefValues.userToken, result['token']);
      await LocalSharedPreferences.saveString(SharedPrefValues.userId, result['user']['id'].toString());
      await LocalSharedPreferences.saveString(SharedPrefValues.userName, result['user']['name']);
      await LocalSharedPreferences.saveString(SharedPrefValues.userEmail, result['user']['email']);
    }

    return {'statusCode': response.statusCode, 'body': result};
  }
}
