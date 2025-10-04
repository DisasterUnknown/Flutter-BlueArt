// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';

import 'package:blue_art_mad2/models/products.dart';
import 'package:blue_art_mad2/services/localSharedPreferences.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';
import 'package:blue_art_mad2/store/deviceStore/userCartManagement.dart';
import 'package:blue_art_mad2/store/firebaseStore/firebaseDB.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ViewProductDetailsPage extends ConsumerStatefulWidget {
  final Product? selectedProduct;
  const ViewProductDetailsPage({super.key, required this.selectedProduct});

  @override
  ConsumerState<ViewProductDetailsPage> createState() => _ViewProductDetailsPageState();
}

class _ViewProductDetailsPageState extends ConsumerState<ViewProductDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  int _productQuantity = 1;
  bool _showMsg = false;
  String msgContent = "";
  Product? product;
  MemoryImage? productImage;
  List<String> favorites = [];

  // Scroling to the top of the page when loaded
  @override
  void didUpdateWidget(covariant ViewProductDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadProductQuantity();
    _loadFavorites();

    if (widget.selectedProduct != oldWidget.selectedProduct) {
      setState(() {
        product = widget.selectedProduct;
        productImage = MemoryImage(
          base64Decode(product!.images[0].content.split(',').last),
        );
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
        _productQuantity = 1;
      }
    });
  }

  Future<void> _loadFavorites() async {
    final firebaseDB = FirebaseDBService(ref);
    final favs = await firebaseDB.getFavorites();
    setState(() => favorites = favs);
  }

  Future<void> _loadProductQuantity() async {
    if (product == null) return;
    final cartDataList = await CartManager(ref).getCart();

    for (var item in cartDataList) {
      if (item['id'] == product!.id) {
        setState(() {
          _productQuantity = item['quantity'];
        });
        break;
      }
    }
  }

  // Display Msg
  void _handleMsgDisplay() {
    setState(() {
      _showMsg = true;
    });

    msgContent = "Product Added To Cart!!";

    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showMsg = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final productDetailsFormWidth = screenWidth > 600 ? 500.0 : screenWidth * 0.8;
    final productDescriptionFormWidth = screenWidth > 600 ? screenWidth * 0.75 : screenWidth * 1.0;

    if (product == null) {
      return Center(child: Text("No product selected"));
    }

    return Center(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            SizedBox(height: 60),

            // Page Title (product name)
            Text(
              product!.name,
              style: TextStyle(
                color: CustomColors.getThemeColor(context, 'textColor'),
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),

            SizedBox(height: 60),

            // Page Img
            Stack(
              children: [
                Container(
                  height: 400,
                  width: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: CustomColors.getThemeColor(
                        context,
                        'onSurfaceVariant',
                      ),
                      width: 2,
                    ),

                    // Adding the img
                    image: DecorationImage(
                      image: productImage!,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withAlpha(30),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    child: Builder(
                      builder: (context) {
                        final isFavorite = favorites.contains((product!.id).toString());

                        return Icon(
                          Icons.star,
                          color: isFavorite ? Colors.yellowAccent : Colors.white,
                          size: 34,
                        );
                      },
                    ),
                    onTap: () async {
                      final firebaseDB = FirebaseDBService(ref);

                      final favorites = await firebaseDB.getFavorites();
                      final isFavorite = favorites.contains((product!.id).toString());

                      if (!isFavorite) {
                        firebaseDB.addFavorite((product!.id).toString());
                      } else {
                        firebaseDB.removeFavorite((product!.id).toString());
                      }

                      final isVibrate = await LocalSharedPreferences.getString(SharedPrefValues.isVibrate);

                      if (await Vibration.hasVibrator() && isVibrate?.toLowerCase() == 'true') {
                        Vibration.vibrate(duration: 200);
                      }

                      setState(() {
                        _loadFavorites();
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 60),

            // product Details Section
            Container(
              width: productDetailsFormWidth,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: CustomColors.getThemeColor(
                    context,
                    'surfaceContainerHighest',
                  ),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
                color: CustomColors.getThemeColor(
                  context,
                  'surfaceContainerHighest',
                ),
                boxShadow: [BoxShadow(blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Product Price: ",
                          style: TextStyle(
                            color: CustomColors.getThemeColor(
                              context,
                              'textColor',
                            ),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            String cleaned = product!.price.replaceAll(
                              RegExp(r'[^0-9.]'),
                              '',
                            );
                            double value = double.parse(cleaned);

                            final formatter = NumberFormat('#,###');
                            return Text(
                              "LKR ${formatter.format(value)}",
                              style: TextStyle(
                                color: CustomColors.getThemeColor(
                                  context,
                                  'textColor',
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Discount: ",
                          style: TextStyle(
                            color: CustomColors.getThemeColor(
                              context,
                              'textColor',
                            ),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            String cleaned = product!.discount.replaceAll(
                              RegExp(r'[^0-9.]'),
                              '',
                            );
                            double value = double.parse(cleaned);

                            return Text(
                              "${value.toInt()}%",
                              style: TextStyle(
                                color: CustomColors.getThemeColor(
                                  context,
                                  'textColor',
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Price: ",
                          style: TextStyle(
                            color: CustomColors.getThemeColor(
                              context,
                              'textColor',
                            ),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            final formatter = NumberFormat("#,##0.0", "en_US");
                            final itemPrice = product!.price.splitMapJoin(
                              ',',
                              onMatch: (_) => '',
                            );
                            final itemDiscount = product!.discount.splitMapJoin(
                              '%',
                              onMatch: (_) => '',
                            );
                            final discount = double.parse(itemDiscount);
                            final price = double.parse(itemPrice);
                            final quantityPrice = (price - ((price / 100) * discount)) * _productQuantity;
                            return Text(
                              "LKR ${formatter.format(quantityPrice)}",
                              style: TextStyle(
                                color: CustomColors.getThemeColor(
                                  context,
                                  'textColor',
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Quantity: ",
                              style: TextStyle(
                                color: CustomColors.getThemeColor(
                                  context,
                                  'textColor',
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: CustomColors.getThemeColor(
                                    context,
                                    'onPrimary',
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  top: 2,
                                  bottom: 1,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Text(
                                        " < ",
                                        style: TextStyle(
                                          color: CustomColors.getThemeColor(
                                            context,
                                            'textColor',
                                          ),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _productQuantity--;
                                          if (_productQuantity < 1) {
                                            _productQuantity = 1;
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      "$_productQuantity",
                                      style: TextStyle(
                                        color: CustomColors.getThemeColor(
                                          context,
                                          'textColor',
                                        ),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        " > ",
                                        style: TextStyle(
                                          color: CustomColors.getThemeColor(
                                            context,
                                            'textColor',
                                          ),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _productQuantity++;
                                          if (_productQuantity > 100) {
                                            _productQuantity = 100;
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 45),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: _showMsg ? 1.0 : 0.0,
                          child: Text(
                            msgContent,
                            style: TextStyle(
                              color: CustomColors.getThemeColor(
                                context,
                                'labelSmall',
                              ),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: CustomColors.getThemeColor(
                                context,
                                'tertiary',
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 12,
                                bottom: 11,
                              ),
                              child: Center(
                                child: Text(
                                  "Add To Cart",
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
                          ),
                          onTap: () async {
                            final isVibrate = await LocalSharedPreferences.getString(SharedPrefValues.isVibrate);
                            CartManager(ref).addAndUpdateCart(product!, _productQuantity);
                            _handleMsgDisplay();
                            if (await Vibration.hasVibrator() && isVibrate?.toLowerCase() == 'true') {
                              Vibration.vibrate(duration: 200);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 60),

            // product Description Section
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Description",
                  style: TextStyle(
                    color: CustomColors.getThemeColor(context, 'textColor'),
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: productDescriptionFormWidth,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      product!.description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: CustomColors.getThemeColor(context, "textColor"),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
