import 'package:assignment/Lists/productsList.dart';
import 'package:assignment/Pages/homePage.dart';
import 'package:assignment/Pages/loginPage.dart';
import 'package:assignment/Pages/registerPage.dart';
import 'package:assignment/Pages/viewCategoriesPage.dart';
import 'package:assignment/Pages/viewProductDetails.dart';
import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  final int index;
  final Function(int) onItemTapped;
  final Function(Item)? onProductSelect;
  final Function(String)? onCategorySelect;
  final Item? selectedProduct;
  final String? selectedProductCategory;

  const PageContent({required this.index, required this.onItemTapped, this.selectedProduct, this.onProductSelect, this.selectedProductCategory, this.onCategorySelect});

  @override
  Widget build(BuildContext context) {
    // Page Content Section
    // Keep State Page Section
    final List<Widget> stateNotLossPages = [
      HomePage(onItemTapped: onItemTapped, onProductSelect: onProductSelect, onCategorySelect: onCategorySelect),
      Text('Index 1: Business'),
    ];


    // Pages where the state should remove
    if (index == 2) {
      return LoginPage(onItemTapped: onItemTapped);
    } else if (index == 3) {
      return RegisterPage(onItemTapped: onItemTapped);
    } else if (index == 4) {
      return ViewProductDetailsPage(Product: selectedProduct,);
    } else if (index == 5) {
      return Viewcategoriespage(onProductSelect: onProductSelect, selectedProductCategory: selectedProductCategory,);
    } else if (index >= 0 && index < stateNotLossPages.length) {
      return IndexedStack(index: index, children: stateNotLossPages);
    } else {
      return Center(child: Text('Page not found'));
    }
  }
}
