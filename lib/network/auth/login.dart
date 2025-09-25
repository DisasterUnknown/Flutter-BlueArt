import 'dart:convert';
import 'package:blue_art_mad2/models/user.dart';
import 'package:blue_art_mad2/network/core.dart';
import 'package:blue_art_mad2/states/authStateManagement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AuthLogin {
  final http.Client client;
  final WidgetRef ref;

  AuthLogin(this.ref, {http.Client? client}) : client = client ?? http.Client();

  // Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await client.post(
      Uri.parse(Network.login),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    final result = json.decode(response.body);

    if (response.statusCode == 200) {
      final user = User(
        id: result['user']['id'].toString(),
        name: result['user']['name'],
        email: result['user']['email'],
        token: result['token'],
      );

      await ref.read(userProvider.notifier).login(user);
    }

    return {'statusCode': response.statusCode, 'body': result};
  }

  /// Logout user
  Future<void> logout(context) async {
    final user = ref.read(userProvider);
    final token = user?.token;

    final response = await client.post(
      Uri.parse(Network.logout),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      await ref.read(userProvider.notifier).logout(context);
    }
  }
}
