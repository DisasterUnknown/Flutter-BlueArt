// ignore_for_file: file_names

import 'dart:convert';
import 'package:blue_art_mad2/models/products.dart';
import 'package:blue_art_mad2/services/localSharedPreferences.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';
import 'package:blue_art_mad2/states/authStateManagement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartManager {
  final WidgetRef ref;
  CartManager(this.ref);
  
  Future<List<Map<String, dynamic>>> getCart() async {
    final user = ref.read(userProvider);
    final userId = user?.id;
    if (userId == null) return [];

    final cartDataString = await LocalSharedPreferences.getString(SharedPrefValues.userCart);
    if (cartDataString == null) return [];

    final List<dynamic> cartList = jsonDecode(cartDataString);

    final userCart = cartList.firstWhere(
      (item) => item['userId'] == userId,
      orElse: () => null,
    );

    if (userCart == null) return [];
    return List<Map<String, dynamic>>.from(userCart['cartData']);
  }

  Future<void> addAndUpdateCart(Product product, int quantity) async {
    final user = ref.read(userProvider);
    final userId = user?.id;
    if (userId == null) return;

    final cartDataString = await LocalSharedPreferences.getString(SharedPrefValues.userCart);
    final List<dynamic> cartList = cartDataString != null ? jsonDecode(cartDataString) : [];

    // Find current user's cart
    int userIndex = cartList.indexWhere((item) => item['userId'] == userId);
    if (userIndex == -1) {
      // Create new user cart
      cartList.add({
        'userId': userId,
        'cartData': [
          {'id': product.id, 'quantity': quantity}
        ]
      });
    } else {
      List<dynamic> userCartData = cartList[userIndex]['cartData'];
      final productIndex = userCartData.indexWhere((item) => item['id'] == product.id);

      if (productIndex >= 0) {
        userCartData[productIndex]['quantity'] = quantity;
      } else {
        userCartData.add({'id': product.id, 'quantity': quantity});
      }
      cartList[userIndex]['cartData'] = userCartData;
    }

    await LocalSharedPreferences.saveString(SharedPrefValues.userCart, jsonEncode(cartList));
  }

  Future<void> removeFromCart(Product product) async {
    final user = ref.read(userProvider);
    final userId = user?.id;
    if (userId == null) return;

    final cartDataString = await LocalSharedPreferences.getString(SharedPrefValues.userCart);
    if (cartDataString == null) return;

    final List<dynamic> cartList = jsonDecode(cartDataString);
    final userIndex = cartList.indexWhere((item) => item['userId'] == userId);

    if (userIndex >= 0) {
      List<dynamic> userCartData = cartList[userIndex]['cartData'];
      userCartData.removeWhere((item) => item['id'] == product.id);
      cartList[userIndex]['cartData'] = userCartData;
      await LocalSharedPreferences.saveString(SharedPrefValues.userCart, jsonEncode(cartList));
    }
  }

  Future<void> clearCart() async {
    final user = ref.read(userProvider);
    final userId = user?.id;
    if (userId == null) return;

    final cartDataString = await LocalSharedPreferences.getString(SharedPrefValues.userCart);
    if (cartDataString == null) return;

    final List<dynamic> cartList = jsonDecode(cartDataString);
    cartList.removeWhere((item) => item['userId'] == userId);

    await LocalSharedPreferences.saveString(SharedPrefValues.userCart, jsonEncode(cartList));
  }
}
