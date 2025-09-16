import 'package:blue_art_mad2/Lists/productsList.dart';
import 'package:blue_art_mad2/Pages/cartPage.dart';
import 'package:blue_art_mad2/Pages/checkOutPage.dart';
import 'package:blue_art_mad2/Pages/homePage.dart';
import 'package:blue_art_mad2/Pages/loginPage.dart';
import 'package:blue_art_mad2/Pages/registerPage.dart';
import 'package:blue_art_mad2/Pages/viewCategoriesPage.dart';
import 'package:blue_art_mad2/Pages/viewProductDetails.dart';
import 'package:blue_art_mad2/Pages/favoritesPage.dart';
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
      HomePage(),
      CartPage(),
      FavoritesPage(),
      Viewcategoriespage(),
      ViewProductDetailsPage(),
      Viewcategoriespage(),
    ];

    // Pages where the state should remove
    if (index == 6) {
      return LoginPage();
    } else if (index == 7) {
      return RegisterPage();
    } else if (index == 8) {
      return CheckOutPage();
    } else if (index >= 0 && index < stateNotLossPages.length) {
      return IndexedStack(index: index, children: stateNotLossPages);
    } else {
      return Center(child: Text('Page not found'));
    }
  }
}
