// ignore_for_file: file_names

import 'dart:convert';

import 'package:blue_art_mad2/models/products.dart';
import 'package:blue_art_mad2/services/localSharedPreferences.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';
import 'package:blue_art_mad2/store/deviceStore/userCartManagement.dart';
import 'package:blue_art_mad2/store/liveStore/productLiveStore.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

class CartPage extends ConsumerStatefulWidget {
  final Function(int) onPageNav;
  final Function(Product)? onProductSelect;
  final String? selectedProductCategory;
  const CartPage({
    super.key,
    required this.onPageNav,
    required this.onProductSelect,
    required this.selectedProductCategory,
  });

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  List<Map<String, dynamic>> _cartList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final data = await CartManager(ref).getCart();
    setState(() {
      _cartList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            "Shopping Cart",
            style: TextStyle(
              color: CustomColors.getThemeColor(context, 'textColor'),
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Column(
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(_cartList.length, (
                    index,
                  ) {
                    return Container(
                      width: 200,
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      decoration: BoxDecoration(
                        color: CustomColors.getThemeColor(
                          context,
                          'surfaceContainerHighest',
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),

                      // Product Card
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return GestureDetector(
                            child: Column(
                              children: [
                                Container(
                                  height: 230,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),

                                    // Adding the img
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        base64Decode(ProductStore().getProductById(_cartList[index]['id'])!.images[0].content.split(',').last),
                                      ),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withAlpha(30),
                                        BlendMode.darken,
                                      ),
                                    ),
                                  ),
                                ),

                                // Product Details Section
                                Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 1.0,
                                        ),
                                        child: Text(
                                          ProductStore().getProductById(_cartList[index]['id'])!.name,
                                          style: TextStyle(
                                            color: CustomColors.getThemeColor(
                                              context,
                                              'titleMedium',
                                            ),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 1.0,
                                        ),
                                        child: Builder(
                                          builder: (context) {
                                            final formatter = NumberFormat("#,##0.0", "en_US");
                                            final itemPrice = ProductStore()
                                                .getProductById(_cartList[index]['id'])!
                                                .price
                                                .splitMapJoin(
                                                  ',',
                                                  onMatch: (_) => '',
                                                );
                                            final itemDiscount = ProductStore()
                                                .getProductById(_cartList[index]['id'])!
                                                .discount
                                                .splitMapJoin(
                                                  '%',
                                                  onMatch: (_) => '',
                                                );
                                            final discount = double.parse(itemDiscount);
                                            final price = double.parse(itemPrice);
                                            final quantityPrice = (price - ((price / 100) * discount)) * _cartList[index]['quantity'].toInt();
                                            return Text(
                                              "LRK ${formatter.format(quantityPrice)}",
                                              style: TextStyle(
                                                color: CustomColors.getThemeColor(
                                                  context,
                                                  'textColor',
                                                ),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            color: CustomColors.getThemeColor(
                                              context,
                                              'onTertiary',
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 5,
                                              bottom: 1,
                                            ),
                                            child: Text(
                                              "Remove",
                                              style: TextStyle(
                                                color: CustomColors.getThemeColor(
                                                  context,
                                                  'textColor',
                                                ),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          await CartManager(ref).removeFromCart(
                                            ProductStore().getProductById(_cartList[index]['id'])!,
                                          );
                                          await _loadCart();

                                          setState(() {});

                                          final isVibrate = await LocalSharedPreferences.getString(SharedPrefValues.isVibrate);

                                          if (await Vibration.hasVibrator() && isVibrate?.toLowerCase() == 'true') {
                                            Vibration.vibrate(duration: 200);
                                          }
                                        },
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Navigating to the View Product Details Page
                            onTap: () {
                              widget.onProductSelect!(ProductStore().getProductById(_cartList[index]['id'])!);
                            },
                          );
                        },
                      ),
                    );
                  }),
                ),

                // User Price Display Section
                SizedBox(height: 100),
                Builder(
                  builder: (context) {
                    if (_cartList.isNotEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              "Total Price!!",
                              style: TextStyle(
                                color: CustomColors.getThemeColor(
                                  context,
                                  'textColor',
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                final formatter = NumberFormat(
                                  "#,##0.0",
                                  "en_US",
                                );
                                double quantityPrice = 0;

                                for (int i = 0; i < _cartList.length; i++) {
                                  final itemPrice = ProductStore().getProductById(_cartList[i]['id'])!.price;
                                  final itemDiscount = ProductStore().getProductById(_cartList[i]['id'])!.discount;
                                  final discount = double.parse(itemDiscount);
                                  final price = double.parse(itemPrice);
                                  quantityPrice += (price - ((price / 100) * discount)) * _cartList[i]['quantity'];
                                }
                                return Text(
                                  "LRK ${formatter.format(quantityPrice)}",
                                  style: TextStyle(
                                    color: CustomColors.getThemeColor(
                                      context,
                                      'textColor',
                                    ),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: CustomColors.getThemeColor(
                                    context,
                                    'tertiary',
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    top: 10,
                                    bottom: 5,
                                  ),
                                  child: Text(
                                    "Check Out!",
                                    style: TextStyle(
                                      color: CustomColors.getThemeColor(
                                        context,
                                        'textColor',
                                      ),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                widget.onPageNav(8);
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text('');
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
