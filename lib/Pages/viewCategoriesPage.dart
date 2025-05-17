import 'package:assignment/Lists/productsList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Viewcategoriespage extends StatelessWidget {
  final Function(Item)? onProductSelect;
  final String? selectedProductCategory;
  const Viewcategoriespage({super.key, required this.onProductSelect, required this.selectedProductCategory});

  // Checking what products to show?
  List<Item> _displayProductList() {
    if (selectedProductCategory == 'art') {
      return artProductList;
    } else if (selectedProductCategory == 'figure') {
      return figureProductList;
    } else {
      return [];
    }
  }

  // Checking the Page Topic Name
  String _pageTitle() {
    if (selectedProductCategory == 'art') {
      return 'Art';
    } else if (selectedProductCategory == 'figure') {
      return 'Action Figures';
    } else {
      return '';
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
          SizedBox(height: 30,),
          Text(pageTitle, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 15,),
          Center(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(displayProductList.length, (index) {
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
                                    displayProductList[index].imageURL,
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
                              height: 100,
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
                                      displayProductList[index].title,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                                    child: Text("LRK ${displayProductList[index].price}", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),),
                                  )
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
              },
            ),
                    ),
          ),
        SizedBox(height: 30),
        ],
      ),
    );
  }
}