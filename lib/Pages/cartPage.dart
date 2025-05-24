import 'package:assignment/Lists/productsList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  final Function(int) onItemTapped;
  final Function(Item)? onProductSelect;
  final String? selectedProductCategory;
  const CartPage({super.key, required this.onItemTapped, required this.onProductSelect, required this.selectedProductCategory});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30,),
          Text("Shopping Cart", style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 15,),
          Center(
            child: Column(
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(CartList.length, (index) {
                    return Container(
                      width: 200,
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                                      image: AssetImage(
                                        CartList[index].imageURL,
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
                                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                                        child: Text(
                                          CartList[index].title,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
                                            final itemPrice = CartList[index].price.splitMapJoin(',',onMatch: (_) => '',);
                                            final itemDiscount = CartList[index].discount.splitMapJoin('%', onMatch: (_) => '');
                                            final discount = int.parse(itemDiscount);
                                            final price = int.parse(itemPrice);
                                            final quantityPrice = (price - ((price/100)*discount)) * CartList[index].quality;
                                            return Text("LRK ${formatter.format(quantityPrice)}", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),);
                                          },                                    
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: Theme.of(context).colorScheme.onTertiary,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 1),
                                            child: Text("Remove"),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            Item.removeProduct(CartList[index]);
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
                              widget.onProductSelect!(CartList[index]);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                ),

                // User Price Display Section
                SizedBox(height: 100,),
                Builder(
                  builder: (context) {
                    if (!CartList.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Text("Total Price!!", style: Theme.of(context).textTheme.titleLarge),
                            Builder(
                              builder: (context) {
                                final formatter = NumberFormat("#,##0.0", "en_US");
                                double quantityPrice = 0;

                                for (int i = 0; i < CartList.length; i++) {
                                  final itemPrice = CartList[i].price.splitMapJoin(',',onMatch: (_) => '',);
                                  final itemDiscount = CartList[i].discount.splitMapJoin('%', onMatch: (_) => '');
                                  final discount = int.parse(itemDiscount);
                                  final price = int.parse(itemPrice);
                                  quantityPrice += (price - ((price/100)*discount)) * CartList[i].quality;
                                }
                                return Text("LRK ${formatter.format(quantityPrice)}");
                              },
                            ),
                            SizedBox(height: 10,),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 5),
                                  child: Text("Check Out!"),
                                ),
                              ),
                              onTap: () {
                                widget.onItemTapped(8);
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text('');
                    }
                  },
                ) 
              ]
            ),
          ),
        SizedBox(height: 30),
        ],
      ),
    );
  }
}