import 'package:assignment/Lists/productsList.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Function(int) onItemTapped;
  final Function(Item)? onProductSelect;
  const HomePage({super.key, required this.onItemTapped, required this.onProductSelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Margin top
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),

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
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      GestureDetector(
                        child: Text("See More > "), 
                        onTap: () {
                          onItemTapped(1);
                        }),
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
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 1.0,
                                          ),
                                          child: Text(
                                            artProductList[index].title,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
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
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w500,
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
                                onProductSelect!(figureProductList[index]);
                              },
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      GestureDetector(
                        child: Text("See More > "), 
                        onTap: () {
                          onItemTapped(1);
                        }),
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
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 1.0,
                                          ),
                                          child: Text(
                                            figureProductList[index].title,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
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
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w500,
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
                                onProductSelect!(figureProductList[index]);
                              },
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        ],
      ),
    );
  }
}
