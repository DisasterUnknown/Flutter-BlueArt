// ignore_for_file: file_names

import 'dart:convert';

import 'package:blue_art_mad2/network/core.dart';
import 'package:blue_art_mad2/services/localSharedPreferences.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';
import 'package:blue_art_mad2/states/authStateManagement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as https;
import 'package:http/http.dart' as http;

class Checkout {
  final Function(int) onPageNav;
  final https.Client client;
  final WidgetRef ref;

  Checkout(this.ref, {required this.onPageNav, https.Client? client,}) : client = client ?? http.Client();

  Future<String> userCheckOut(String phoneNumber, String address, String shippingMethod, String cardHolderName, String cardNumber, String cvc) async {
    final user = ref.read(userProvider);
    final cartJsonString = await LocalSharedPreferences.getString(SharedPrefValues.userCart);

    final List<dynamic> userCart = cartJsonString != null
        ? (json.decode(cartJsonString) as List<dynamic>).firstWhere(
                (entry) => entry['userId'].toString() == user?.id.toString(),
                orElse: () => {'cartData': []},
              )['cartData']
              as List<dynamic>
        : [];

    if (user == null || user.token == null) {
      throw Exception('User is not logged in');
    }

    final response = await client.put(
      Uri.parse(await Network.checkOutUrl()),
      headers: <String, String>{
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phoneNumber': phoneNumber,
        'address': address,
        'shippingMethod': shippingMethod,
        'cardHolderName': cardHolderName,
        'cardNumber': cardNumber,
        'CVC': cvc,
        'cart': userCart,
      }),
    );

    final result = json.decode(response.body);

    if (response.statusCode == 200) {
      await LocalSharedPreferences.removeKey(SharedPrefValues.userCart);
      onPageNav(0);
    }

    return result.message;
  }
}
