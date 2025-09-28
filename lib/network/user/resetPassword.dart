import 'dart:convert';
import 'package:blue_art_mad2/states/authStateManagement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../core.dart';

class ResetPassword {
  final http.Client client;
  final WidgetRef ref;

  ResetPassword(this.ref, {http.Client? client}) : client = client ?? http.Client();

  // Reset password 
  Future<Map<String, dynamic>> reset({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final user = ref.read(userProvider);
    final token = user?.token;

    if (token == null) {
      return {'statusCode': 401, 'message': 'User not authenticated'};
    }

    final response = await client.put(
      Uri.parse(Network.resetPassword), 
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      }),
    );

    final result = json.decode(response.body);

    return {'statusCode': response.statusCode, 'body': result};
  }
}
