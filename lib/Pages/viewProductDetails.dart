import 'dart:async';

import 'package:intl/intl.dart';
import 'package:assignment/Lists/productsList.dart';
import 'package:flutter/material.dart';

class ViewProductDetailsPage extends StatefulWidget {
  final Item? Product;
  const ViewProductDetailsPage({super.key, required this.Product});

  @override
  State<ViewProductDetailsPage> createState() => _ViewProductDetailsPageState();
}

class _ViewProductDetailsPageState extends State<ViewProductDetailsPage> {
  int _productQuantity = 1;
  bool _showMsg = false;

  // Display Msg 
  void _handleMsgDisplay() {
    setState(() {
      _showMsg = true;
    });

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
        child: Column(
          children: [
            SizedBox(height: 60),

            // Page Title (product name)
            Text(
              widget.Product!.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            SizedBox(height: 60),

            // Page Img
            Container(
              height: 400,
              width: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  width: 2,
                ),

                // Adding the img
                image: DecorationImage(
                  image: AssetImage(widget.Product!.imageURL),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withAlpha(30),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),

            SizedBox(height: 60),

            // Product Details Section
            Container(
              width: productDetailsFormWidth,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                          Text("Product Price: ", style: Theme.of(context).textTheme.bodyLarge,),
                          Text("LKR ${widget.Product!.price}", style: Theme.of(context).textTheme.bodyLarge,)
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Discount: ", style: Theme.of(context).textTheme.bodyLarge,),
                          Text(widget.Product!.discount, style: Theme.of(context).textTheme.bodyLarge,)
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Price: ", style: Theme.of(context).textTheme.bodyLarge,),
                          Builder(
                            builder: (context) {
                              final formatter = NumberFormat("#,##0.0", "en_US");
                              final itemPrice = widget.Product!.price.splitMapJoin(',',onMatch: (_) => '',);
                              final itemDiscount = widget.Product!.discount.splitMapJoin('%', onMatch: (_) => '');
                              final discount = int.parse(itemDiscount);
                              final price = int.parse(itemPrice);
                              final quantityPrice = (price - ((price/100)*discount)) * _productQuantity;
                              return Text("LKR ${formatter.format(quantityPrice)}", style: Theme.of(context).textTheme.bodyLarge,);
                            }
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text("Quantity: ", style: Theme.of(context).textTheme.bodyLarge,),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        child: Text(" < ", style: Theme.of(context).textTheme.bodyLarge,),
                                        onTap: () {
                                          setState(() {
                                            _productQuantity++;
                                            if (_productQuantity > 100) {
                                              _productQuantity = 100;
                                            }
                                          });
                                        },
                                      ),
                                      Text("$_productQuantity", style: Theme.of(context).textTheme.bodyLarge,),
                                      GestureDetector(
                                        child: Text(" > ", style: Theme.of(context).textTheme.bodyLarge,),
                                        onTap: () {
                                          setState(() {
                                            _productQuantity--;
                                            if (_productQuantity < 1) {
                                              _productQuantity = 1;
                                            }
                                          });
                                        },  
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 45,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: _showMsg ? 1.0 : 0.0,
                            child: Text("Product Added To Cart!!", style: Theme.of(context).textTheme.labelSmall,)
                          ),
                          GestureDetector(
                            child: Container(
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 11),
                                child: Center(
                                  child: Text("Add To Cart")
                                ),
                              ),
                            ),
                            onTap: () {
                              _handleMsgDisplay();
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
                Text("Description", style: Theme.of(context).textTheme.titleLarge,),
                SizedBox(height: 30),
                Container(
                  width: productDescriptionFormWidth,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(widget.Product!.discription, textAlign: TextAlign.justify,),
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
