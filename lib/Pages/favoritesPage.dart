import 'dart:convert';

import 'package:blue_art_mad2/models/products.dart';
import 'package:blue_art_mad2/store/firebaseStore/firebaseDB.dart';
import 'package:blue_art_mad2/store/liveStore/productLiveStore.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  final Function(int) onPageNav;
  final Function(Product)? onProductSelect;
  final String? selectedProductCategory;
  const FavoritesPage({super.key, required this.onPageNav, required this.onProductSelect, required this.selectedProductCategory});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  List<String> favorites = [];

  @override
  void didUpdateWidget(covariant FavoritesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final firebaseDB = FirebaseDBService(ref);
    final favs = await firebaseDB.getFavorites();
    setState(() => favorites = favs);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            "Favorite Products",
            style: TextStyle(color: CustomColors.getThemeColor(context, 'titleLarge'), fontWeight: FontWeight.bold, fontSize: 30),
          ),
          SizedBox(height: 15),
          Center(
            child: Column(
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(favorites.length, (index) {
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
                                      image: MemoryImage(base64Decode(ProductStore().getProductById(int.parse(favorites[index]))!.images[0].content.split(',').last)),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(Colors.black.withAlpha(30), BlendMode.darken),
                                    ),
                                  ),
                                ),

                                // Product Details Section
                                Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                  ),

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                                        child: Text(
                                          ProductStore().getProductById(int.parse(favorites[index]))!.name,
                                          style: TextStyle(color: CustomColors.getThemeColor(context, 'titleMedium'), fontWeight: FontWeight.bold, fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                                        child: Builder(
                                          builder: (context) {
                                            final product = ProductStore().getProductById(int.parse(favorites[index]))!;
                                            final formatter = NumberFormat("#,##0.0", "en_US");
                                            final itemPrice = product.price.splitMapJoin(',', onMatch: (_) => '');
                                            final itemDiscount = product.discount.splitMapJoin('%', onMatch: (_) => '');
                                            final discount = double.parse(itemDiscount);
                                            final price = double.parse(itemPrice);
                                            final realPrice = (price - ((price / 100) * discount));
                                            return Text(
                                              "LRK ${formatter.format(realPrice)}",
                                              style: TextStyle(color: CustomColors.getThemeColor(context, 'titleLarge'), fontWeight: FontWeight.w500, fontSize: 20),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: CustomColors.getThemeColor(context, 'onTertiary')),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 1),
                                            child: Text(
                                              "Remove",
                                              style: TextStyle(color: CustomColors.getThemeColor(context, 'bodySmall'), fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            FirebaseDBService(ref).removeFavorite(favorites[index]);
                                            _loadFavorites();
                                          });
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
                              widget.onProductSelect!(ProductStore().getProductById(int.parse(favorites[index]))!);
                            },
                          );
                        },
                      ),
                    );
                  }),
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
