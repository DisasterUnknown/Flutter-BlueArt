import 'package:blue_art_mad2/lists/productsList.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Function(int) onPageNav;
  final Function(Item)? onProductSelect;
  final Function(String)? onCategorySelect;
  const HomePage({super.key, required this.onPageNav, required this.onProductSelect, required this.onCategorySelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Margin top
          SizedBox(height: 50),

          // Art Section
          Container(
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topic
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Art",
                        style: TextStyle(
                          color: CustomColors.getThemeColor(
                            context,
                            'titleLarge',
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          "See More > ",
                          style: TextStyle(
                            color: CustomColors.getThemeColor(
                              context,
                              'bodySmall',
                            ),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        onTap: () {
                          onCategorySelect!('art');
                        },
                      ),
                    ],
                  ),
                ),

                // X axis Scrolling Area
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  height: 350,

                  // Creating the x axis Scrole Products using the Products List
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: artProductList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 250,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                          color: CustomColors.getThemeColor(context, 'surfaceContainerHighest'),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),

                        // The product Card
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return GestureDetector(
                              child: Column(
                                children: [
                                  Container(
                                    height: constraints.maxHeight * 0.7,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),

                                      // Adding the img
                                      image: DecorationImage(
                                        image: AssetImage(
                                          artProductList[index].imageURL,
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
                                    height: constraints.maxHeight * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 1.0,
                                          ),
                                          child: Text(
                                            artProductList[index].title,
                                            style: TextStyle(
                                              color: CustomColors.getThemeColor(
                                                context,
                                                'bodyMedium',
                                              ),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
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
                                          child: Text(
                                            "LKR ${artProductList[index].price}",
                                            style: TextStyle(
                                              color: CustomColors.getThemeColor(
                                                context,
                                                'bodyMedium',
                                              ),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // Navigating to the View Product Details Page
                              onTap: () {
                                onProductSelect!(artProductList[index]);},
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ===========================================================
          // ===========================================================
          // ===========================================================
          // Middle Margin
          SizedBox(height: 50),
          // ===========================================================
          // ===========================================================
          // ===========================================================

          // Action Figure Section
          Container(
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topic
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Collectables",
                        style: TextStyle(
                          color: CustomColors.getThemeColor(
                            context,
                            'titleLarge',
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          "See More > ",
                          style: TextStyle(
                            color: CustomColors.getThemeColor(
                              context,
                              'bodySmall',
                            ),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        onTap: () {
                          onCategorySelect!('figure');
                        },
                      ),
                    ],
                  ),
                ),

                // X axis Scrolling Area
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  height: 350,

                  // Creating the x axis product list for Collectables
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: figureProductList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 250,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                          color: CustomColors.getThemeColor(context, 'surfaceContainerHighest'),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),

                        // Creating the container
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return GestureDetector(
                              child: Column(
                                children: [
                                  Container(
                                    height: constraints.maxHeight * 0.7,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),

                                      // Adding the img
                                      image: DecorationImage(
                                        image: AssetImage(
                                          figureProductList[index].imageURL,
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
                                    height: constraints.maxHeight * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 1.0,
                                          ),
                                          child: Text(
                                            figureProductList[index].title,
                                            style: TextStyle(
                                              color: CustomColors.getThemeColor(
                                                context,
                                                'bodyMedium',
                                              ),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
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
                                          child: Text(
                                            "LKR ${figureProductList[index].price}",
                                            style: TextStyle(
                                              color: CustomColors.getThemeColor(
                                                context,
                                                'bodyMedium',
                                              ),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // Navigating to the View Product Details Page
                              onTap: () {
                                onProductSelect!(figureProductList[index]);},
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Margin Bottum
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
