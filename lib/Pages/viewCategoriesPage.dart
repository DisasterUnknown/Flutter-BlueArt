// ignore_for_file: file_names

import 'dart:convert';
import 'dart:math';

import 'package:blue_art_mad2/models/products.dart';
import 'package:blue_art_mad2/store/liveStore/productLiveStore.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';

class Viewcategoriespage extends StatelessWidget {
  final Function(Product)? onProductSelect;
  final String? selectedProductCategory;
  const Viewcategoriespage({super.key, required this.onProductSelect, required this.selectedProductCategory});

  // Checking what products to show?
  List<Product> _displayProductList() {
    if (selectedProductCategory == 'art') {
      return ProductStore().artProducts;
    } else if (selectedProductCategory == 'figure') {
      return ProductStore().collectiblesProducts;
    } else {
      List<Product> productsList = [...ProductStore().artProducts, ...ProductStore().collectiblesProducts];
      productsList.shuffle(Random());
      return productsList;
    }
  }

  // Checking the Page Topic Name
  String _pageTitle() {
    if (selectedProductCategory == 'art') {
      return 'Art';
    } else if (selectedProductCategory == 'figure') {
      return 'Action Figures';
    } else {
      return 'Products';
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayProductList = _displayProductList();
    final pageTitle = _pageTitle();

    // return Text("${displayProductList[0].title}");
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(pageTitle, style: TextStyle(color: CustomColors.getThemeColor(context, 'textColor'), fontWeight: FontWeight.bold, fontSize: 30)),
          SizedBox(height: 15),
          Center(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(displayProductList.length, (index) {
                return Container(
                  width: 200,
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  decoration: BoxDecoration(
                    color: CustomColors.getThemeColor(context, 'surfaceContainerHighest'),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
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
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),

                                // Adding the img
                                image: DecorationImage(
                                  image: MemoryImage(base64Decode(displayProductList[index].images[0].content.split(',').last)),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black.withAlpha(30), BlendMode.darken),
                                ),
                              ),
                            ),

                            // Product Details Section
                            Container(
                              height: 100,
                              decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                                    child: Text(
                                      displayProductList[index].name,
                                      style: TextStyle(color: CustomColors.getThemeColor(context, 'titleMedium'), fontWeight: FontWeight.bold, fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                                    child: Text("LRK ${displayProductList[index].price}", style: TextStyle(color: CustomColors.getThemeColor(context, 'textColor'), fontWeight: FontWeight.w500, fontSize: 20)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Navigating to the View Product Details Page
                        onTap: () {
                          onProductSelect!(displayProductList[index]);
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
