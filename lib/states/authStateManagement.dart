// ignore_for_file: file_names

import 'package:blue_art_mad2/models/user.dart';
import 'package:blue_art_mad2/routes/app_route.dart';
import 'package:blue_art_mad2/services/localSharedPreferences.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  Future<void> loadUserFromPrefs() async {
    final String? userName = await LocalSharedPreferences.getString(SharedPrefValues.userName);
    final String? userEmail = await LocalSharedPreferences.getString(SharedPrefValues.userEmail);
    final String? userToken = await LocalSharedPreferences.getString(SharedPrefValues.userToken);
    final String? userId = await LocalSharedPreferences.getString(SharedPrefValues.userId);
    final String? userPfp = await LocalSharedPreferences.getString(SharedPrefValues.userPfp);

    if (userId == null || userName == null || userEmail == null || userToken == null) {
      state = null;
      return;
    }

    final user = User(id: userId, name: userName, email: userEmail, token: userToken, pfp: userPfp);
    state = user;
  }

  Future<void> login(User user) async {
    state = user;
    await LocalSharedPreferences.saveString(SharedPrefValues.userToken, user.token!);
    await LocalSharedPreferences.saveString(SharedPrefValues.userId, user.id!);
    await LocalSharedPreferences.saveString(SharedPrefValues.userName, user.name!);
    await LocalSharedPreferences.saveString(SharedPrefValues.userEmail, user.email!);
    await LocalSharedPreferences.saveString(SharedPrefValues.userPfp, user.pfp!);
  }

  Future<void> register(User user) async {
    state = user;
    await LocalSharedPreferences.saveString(SharedPrefValues.userToken, user.token!);
    await LocalSharedPreferences.saveString(SharedPrefValues.userId, user.id!);
    await LocalSharedPreferences.saveString(SharedPrefValues.userName, user.name!);
    await LocalSharedPreferences.saveString(SharedPrefValues.userEmail, user.email!);
    await LocalSharedPreferences.saveString(SharedPrefValues.userPfp, user.pfp!);
  }

  Future<void> logout(context) async {
    final cart = await LocalSharedPreferences.getString(SharedPrefValues.userCart);
    await LocalSharedPreferences.clearAll();
    await LocalSharedPreferences.saveString(SharedPrefValues.userCart, cart ?? '');
    Navigator.pushReplacementNamed(context, AppRoute.login);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
