// ignore_for_file: file_names

import 'dart:convert';
import 'package:blue_art_mad2/models/user.dart';
import 'package:blue_art_mad2/network/core.dart';
import 'package:blue_art_mad2/states/authStateManagement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class UpdateProfile {
  final http.Client client;
  final WidgetRef ref;

  UpdateProfile(this.ref, {http.Client? client}) : client = client ?? http.Client();

  /// Update user's name and profile picture
  Future<Map<String, dynamic>> update({
    required String name,
    String? pFPdata, // Base64 encoded image
  }) async {
    final user = ref.read(userProvider);
    if (user == null || user.token == null) {
      throw Exception('User is not logged in');
    }

    final response = await client.put(
      Uri.parse(await Network.updateProfileUrl()),
      headers: <String, String>{
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        if (pFPdata != null) 'pFPdata': pFPdata,
      }),
    );

    final result = json.decode(response.body);

    if (response.statusCode == 200) {
      // Update local user state
      final updatedUser = User(
        id: user.id,
        name: result['user']['name'],
        email: user.email,
        token: user.token,
        pfp: result['user']['pFPdata'],
      );

      await ref.read(userProvider.notifier).login(updatedUser);
    }

    return {'statusCode': response.statusCode, 'body': result};
  }
}
