import 'package:blue_art_mad2/lists/productsList.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Text("Favorite Products", style: TextStyle(color: CustomColors.getThemeColor(context, 'titleLarge'), fontWeight: FontWeight.bold, fontSize: 30)),
          SizedBox(height: 15),
          Center(
            child: Column(
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(FavoritList.length, (index) {
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
                                    image: DecorationImage(image: AssetImage(FavoritList[index].imageURL), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withAlpha(30), BlendMode.darken)),
                                  ),
                                ),

                                // Product Details Section
                                Container(
                                  height: 120,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))),

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                                        child: Text(
                                          FavoritList[index].title,
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
                                            final formatter = NumberFormat("#,##0.0", "en_US");
                                            final itemPrice = FavoritList[index].price.splitMapJoin(',', onMatch: (_) => '');
                                            final itemDiscount = FavoritList[index].discount.splitMapJoin('%', onMatch: (_) => '');
                                            final discount = int.parse(itemDiscount);
                                            final price = int.parse(itemPrice);
                                            final quantityPrice = (price - ((price / 100) * discount)) * FavoritList[index].quality;
                                            return Text("LRK ${formatter.format(quantityPrice)}", style: TextStyle(color: CustomColors.getThemeColor(context, 'titleLarge'), fontWeight: FontWeight.w500, fontSize: 20));
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: CustomColors.getThemeColor(context, 'onTertiary')),
                                          child: Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 1), child: Text("Remove")),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            Item.removeFavorit(FavoritList[index]);
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
