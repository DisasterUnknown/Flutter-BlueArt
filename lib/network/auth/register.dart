import 'dart:convert';
import 'package:blue_art_mad2/models/user.dart';
import 'package:blue_art_mad2/network/core.dart';
import 'package:blue_art_mad2/states/authStateManagement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AuthRegister {
  final http.Client client;
  final WidgetRef ref;

  AuthRegister(this.ref, {http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> register(String username, String email, String password, String confirmPass) async {
    final response = await client.post(
      Uri.parse(await Network.registerUrl()),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{'name': username, 'email': email, 'password': password, 'password_confirmation': confirmPass}),
    );

    final result = json.decode(response.body);

    if (response.statusCode == 200) {
      final user = User(
        id: result['user']['id'].toString(),
        name: result['user']['name'],
        email: result['user']['email'],
        token: result['token'],
        pfp: result['user']['pFPdata'],
      );

      await ref.read(userProvider.notifier).register(user);
    }

    return {'statusCode': response.statusCode, 'body': result};
  }
}
