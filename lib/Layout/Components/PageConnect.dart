import 'package:assignment/Lists/productsList.dart';
import 'package:assignment/Pages/cartPage.dart';
import 'package:assignment/Pages/checkOutPage.dart';
import 'package:assignment/Pages/homePage.dart';
import 'package:assignment/Pages/loginPage.dart';
import 'package:assignment/Pages/registerPage.dart';
import 'package:assignment/Pages/viewCategoriesPage.dart';
import 'package:assignment/Pages/viewProductDetails.dart';
import 'package:assignment/Pages/favoritesPage.dart';
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
      CartPage(onItemTapped: onItemTapped, onProductSelect: onProductSelect, selectedProductCategory: selectedProductCategory),
      FavoritesPage(onItemTapped: onItemTapped, onProductSelect: onProductSelect, selectedProductCategory: selectedProductCategory),
      Viewcategoriespage(onProductSelect: onProductSelect, selectedProductCategory: selectedProductCategory),
      ViewProductDetailsPage(Product: selectedProduct),
      Viewcategoriespage(onProductSelect: onProductSelect, selectedProductCategory: selectedProductCategory),
    ];

    // Pages where the state should remove
    if (index == 6) {
      return LoginPage(onItemTapped: onItemTapped);
    } else if (index == 7) {
      return RegisterPage(onItemTapped: onItemTapped);
    } else if (index == 8) {
      return CheckOutPage();
    } else if (index >= 0 && index < stateNotLossPages.length) {
      return IndexedStack(index: index, children: stateNotLossPages);
    } else {
      return Center(child: Text('Page not found'));
    }
  }
}
