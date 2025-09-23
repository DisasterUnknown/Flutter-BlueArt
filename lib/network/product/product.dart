import 'dart:convert';

import 'package:blue_art_mad2/models/products.dart';
import 'package:blue_art_mad2/network/core.dart';
import 'package:blue_art_mad2/states/authStateManagement.dart';
import 'package:blue_art_mad2/store/liveStore/productLiveStore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as https;
import 'package:http/http.dart' as http;

class NetworkProducts {
  final https.Client client;
  final WidgetRef ref;

  List<Product> artProducts = [];
  List<Product> collectiblesProducts = [];

  NetworkProducts(this.ref, {https.Client? client})
    : client = client ?? http.Client();

  Future<void> getArtProducts() async {
    final user = ref.read(userProvider);
    final token = user?.token;

    if (token == null) return;

    final uri = Uri.https(Network.authority, Network.getArtProducts);
    final response = await client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List<dynamic>;
      artProducts = data.map((e) => Product.fromJson(e)).toList();
      ProductStore().setArtProducts(artProducts);
    }
  }

  Future<void> getCollectiblesProducts() async {
    final user = ref.read(userProvider);
    final token = user?.token;

    if (token == null) return;

    final uri = Uri.https(Network.authority, Network.getColectablesProducts);
    final response = await client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List<dynamic>;
      collectiblesProducts = data.map((e) => Product.fromJson(e)).toList();
      ProductStore().setCollectiblesProducts(collectiblesProducts);
    }
  }
}
