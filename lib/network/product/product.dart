// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:blue_art_mad2/models/products.dart';
import 'package:blue_art_mad2/network/auth/login.dart';
import 'package:blue_art_mad2/network/core.dart';
import 'package:blue_art_mad2/services/localSharedPreferences.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';
import 'package:blue_art_mad2/states/authStateManagement.dart';
import 'package:blue_art_mad2/store/liveStore/productLiveStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as https;
import 'package:http/http.dart' as http;

class NetworkProducts {
  final https.Client client;
  final WidgetRef ref;

  List<Product> artProducts = [];
  List<Product> collectiblesProducts = [];

  NetworkProducts(this.ref, {https.Client? client}) : client = client ?? http.Client();

  Future<Uri> _getNetworkUrlDetails(String networkPath) async {
    String? networkScheme;
    String? networkHost;
    int? networkPort;

    final connectionType = await LocalSharedPreferences.getString(SharedPrefValues.connection);

    if (connectionType == 'local') {
      final portStr = await LocalSharedPreferences.getString(SharedPrefValues.localPort);
      networkScheme = await LocalSharedPreferences.getString(SharedPrefValues.protocol);
      networkHost = await LocalSharedPreferences.getString(SharedPrefValues.localIP);
      networkPort = portStr != null ? int.tryParse(portStr) : null;
    } else {
      networkScheme = await LocalSharedPreferences.getString(SharedPrefValues.protocol);
      networkHost = await Network.getAuthority();
      networkScheme = networkScheme == null ? 'https' : null;
      networkPort = null;
    }

    return Uri(
      scheme: networkScheme,
      host: networkHost,
      port: networkPort,
      path: networkPath,
    );
  }

  Future<void> getArtProducts() async {
    final user = ref.read(userProvider);
    final token = user?.token;

    if (token == null) return;

    try {
      final uri = await _getNetworkUrlDetails(Network.artProducts);
      final response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List<dynamic>;
        artProducts = data.map((e) => Product.fromJson(e)).toList();
        ProductStore().setArtProducts(artProducts);
      } else if (response.statusCode == 401) {
        AuthLogin(ref).logout(ref.context);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getCollectiblesProducts() async {
    final user = ref.read(userProvider);
    final token = user?.token;

    if (token == null) return;

    try {
      final uri = await _getNetworkUrlDetails(Network.collectiblesProducts);
      final response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List<dynamic>;
        collectiblesProducts = data.map((e) => Product.fromJson(e)).toList();
        ProductStore().setCollectiblesProducts(collectiblesProducts);
      } else if (response.statusCode == 401) {
        AuthLogin(ref).logout(ref.context);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
