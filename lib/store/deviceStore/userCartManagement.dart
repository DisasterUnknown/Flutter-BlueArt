import 'dart:convert';

import 'package:blue_art_mad2/models/products.dart';
import 'package:blue_art_mad2/services/localSharedPreferences.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';

class CartManager {
  Future<List<Map<String, dynamic>>> getCart() async {
    final cartDataString = await LocalSharedPreferences.getString(SharedPrefValues.userCart);

    if (cartDataString == null) return [];
    final List<dynamic> cartList = jsonDecode(cartDataString);

    return List<Map<String, dynamic>>.from(cartList);
  }


  Future<void> addAndUpdateCart(Product product, int quantity) async {
    final cartDataString = await LocalSharedPreferences.getString(SharedPrefValues.userCart);
    final List<dynamic> cartList = cartDataString != null ? jsonDecode(cartDataString) : [];

    final index = cartList.indexWhere((item) => item['id'] == product.id);
    if (index >= 0) {
      cartList[index]['quantity'] = quantity;
    } else {
      cartList.add({'id': product.id, 'quantity': quantity});
    }

    await LocalSharedPreferences.saveString(SharedPrefValues.userCart, jsonEncode(cartList));
  }


  Future<void> removeFromCart(Product product) async {
    final cartDataString = await LocalSharedPreferences.getString(SharedPrefValues.userCart);
    if (cartDataString == null) return;

    final List<dynamic> cartList = jsonDecode(cartDataString);
    cartList.removeWhere((item) => item['id'] == product.id);

    await LocalSharedPreferences.saveString(SharedPrefValues.userCart, jsonEncode(cartList));
  }


  Future<void> clearCart() async {
    await LocalSharedPreferences.removeKey(SharedPrefValues.userCart);
  }
}
