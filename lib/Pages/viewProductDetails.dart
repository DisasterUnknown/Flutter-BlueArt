import 'dart:async';

import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:intl/intl.dart';
import 'package:blue_art_mad2/lists/productsList.dart';
import 'package:flutter/material.dart';

class ViewProductDetailsPage extends StatefulWidget {
  const ViewProductDetailsPage({super.key});

  @override
  State<ViewProductDetailsPage> createState() => _ViewProductDetailsPageState();
}

class _ViewProductDetailsPageState extends State<ViewProductDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  int _productQuantity = 1;
  bool _showMsg = false;
  String msgContent = "";
  Item? Product;

  // Scroling to the top of the page when loaded
  @override
  void didUpdateWidget(covariant) {
    super.didUpdateWidget(covariant);
    _scrollController.jumpTo(0);
  }

  // Setting the Quantity value to the value of the cart product if exist
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < CartList.length; i++) {
      if (CartList[i].id == Product?.id) {
        _productQuantity = CartList[i].quality;
        break;
      }
    }
  }

  // Display Msg
  void _handleMsgDisplay(int opption) {
    setState(() {
      _showMsg = true;
    });

    if (opption == 1) {
      msgContent = "Product Added To Cart!!";
    } else if (opption == 2) {
      msgContent = "Product Successfully Updated!!";
    } else if (opption == 3) {
      msgContent = "Product Already Exist in Cart!!";
    }

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

    return Center(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            SizedBox(height: 60),

            // Page Title (product name)
            Text(Product!.title, style: TextStyle(color: CustomColors.getThemeColor(context, 'titleLarge'), fontWeight: FontWeight.bold, fontSize: 30)),

            SizedBox(height: 60),

            // Page Img
            Stack(
              children: [
                Container(
                  height: 400,
                  width: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: CustomColors.getThemeColor(context, 'onSurfaceVariant'), width: 2),

                    // Adding the img
                    image: DecorationImage(image: AssetImage(Product!.imageURL), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withAlpha(30), BlendMode.darken)),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    child: Builder(
                      builder: (context) {
                        if (!FavoritList.any((item) => item.id == Product!.id)) {
                          return Icon(Icons.star, color: Colors.white, size: 34);
                        } else {
                          return Icon(Icons.star, color: Colors.yellowAccent, size: 34);
                        }
                      },
                    ),
                    onTap: () {
                      setState(() {
                        if (!FavoritList.any((item) => item.id == Product!.id)) {
                          Item.addFavorite(Product!);
                        } else {
                          Item.removeFavorit(Product!);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 60),

            // Product Details Section
            Container(
              width: productDetailsFormWidth,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: CustomColors.getThemeColor(context, 'surfaceContainerHighest'), width: 1.5),
                borderRadius: BorderRadius.circular(12),
                color: CustomColors.getThemeColor(context, 'surfaceContainerHighest'),
                boxShadow: [BoxShadow(blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Product Price: ", style: TextStyle(color: CustomColors.getThemeColor(context, 'bodyLarge'), fontWeight: FontWeight.bold, fontSize: 22)), Text("LKR ${Product!.price}", style: TextStyle(color: CustomColors.getThemeColor(context, 'bodyLarge'), fontWeight: FontWeight.bold, fontSize: 22))],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Discount: ", style: TextStyle(color: CustomColors.getThemeColor(context, 'bodyLarge'), fontWeight: FontWeight.bold, fontSize: 22)), Text(Product!.discount, style: TextStyle(color: CustomColors.getThemeColor(context, 'bodyLarge'), fontWeight: FontWeight.bold, fontSize: 22))],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Price: ", style: TextStyle(color: CustomColors.getThemeColor(context, 'bodyLarge'), fontWeight: FontWeight.bold, fontSize: 22)),
                        Builder(
                          builder: (context) {
                            final formatter = NumberFormat("#,##0.0", "en_US");
                            final itemPrice = Product!.price.splitMapJoin(',', onMatch: (_) => '');
                            final itemDiscount = Product!.discount.splitMapJoin('%', onMatch: (_) => '');
                            final discount = int.parse(itemDiscount);
                            final price = int.parse(itemPrice);
                            final quantityPrice = (price - ((price / 100) * discount)) * _productQuantity;
                            return Text("LKR ${formatter.format(quantityPrice)}", style: TextStyle(color: CustomColors.getThemeColor(context, 'bodyLarge'), fontWeight: FontWeight.bold, fontSize: 22));
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [Text("Quantity: ", style: TextStyle(color: CustomColors.getThemeColor(context, 'bodyLarge'), fontWeight: FontWeight.bold, fontSize: 22))]),
                        Column(
                          children: [
                            Container(
                              width: 120,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: CustomColors.getThemeColor(context, 'onPrimary'), width: 2)),
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Text(" < ", style: TextStyle(color: CustomColors.getThemeColor(context, 'bodyLarge'), fontWeight: FontWeight.bold, fontSize: 22)),
                                      onTap: () {
                                        setState(() {
                                          _productQuantity--;
                                          if (_productQuantity < 1) {
                                            _productQuantity = 1;
                                          }
                                        });
                                      },
                                    ),
                                    Text("$_productQuantity", style: TextStyle(color: CustomColors.getThemeColor(context, 'bodyLarge'), fontWeight: FontWeight.bold, fontSize: 22)),
                                    GestureDetector(
                                      child: Text(" > ", style: TextStyle(color: CustomColors.getThemeColor(context, 'bodyLarge'), fontWeight: FontWeight.bold, fontSize: 22)),
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
                        AnimatedOpacity(duration: Duration(milliseconds: 500), opacity: _showMsg ? 1.0 : 0.0, child: Text(msgContent, style: TextStyle(color: CustomColors.getThemeColor(context, 'labelSmall'), fontWeight: FontWeight.bold, fontSize: 18))),
                        GestureDetector(
                          child: Container(
                            width: 250,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: CustomColors.getThemeColor(context, 'tertiary')),
                            child: Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 11), child: Center(child: Text("Add To Cart"))),
                          ),
                          onTap: () {
                            if (!CartList.any((item) => item.id == Product!.id)) {
                              Item.addProduct(Product!, _productQuantity);
                              _handleMsgDisplay(1);
                            } else if (!CartList.any((item) => item.quality == _productQuantity)) {
                              Item.updateProduct(Product!, _productQuantity);
                              _handleMsgDisplay(2);
                            } else {
                              _handleMsgDisplay(3);
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

            // Product Description Section
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Description", style: TextStyle(color: CustomColors.getThemeColor(context, 'titleLarge'), fontWeight: FontWeight.bold, fontSize: 30)),
                SizedBox(height: 30),
                Container(width: productDescriptionFormWidth, child: Padding(padding: EdgeInsets.only(left: 20, right: 20), child: Text(Product!.discription, textAlign: TextAlign.justify))),
              ],
            ),

            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
