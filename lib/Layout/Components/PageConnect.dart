// ignore_for_file: file_names
import 'package:blue_art_mad2/Pages/cartPage.dart';
import 'package:blue_art_mad2/Pages/checkOutPage.dart';
import 'package:blue_art_mad2/Pages/favoritesPage.dart';
import 'package:blue_art_mad2/Pages/homePage.dart';
import 'package:blue_art_mad2/Pages/viewCategoriesPage.dart';
import 'package:blue_art_mad2/Pages/viewProductDetails.dart';
import 'package:blue_art_mad2/language/systemLanguageManager.dart';
import 'package:blue_art_mad2/models/products.dart';
import 'package:blue_art_mad2/pages/profilePage.dart';
import 'package:blue_art_mad2/pages/settingsPage.dart';
import 'package:flutter/material.dart';

typedef NetworkToggleCallback = void Function(String status);

class PageContent extends StatelessWidget {
  final int index;
  final Function(int) onPageNav;
  final Function(Product)? onProductSelect;
  final Function(String)? onCategorySelect;
  final Product? selectedProduct;
  final String? selectedProductCategory;
  final NetworkToggleCallback? onNetworkToggle;

  const PageContent({
    super.key,
    required this.index,
    required this.onPageNav,
    this.selectedProduct,
    this.onProductSelect,
    this.selectedProductCategory,
    this.onCategorySelect,
    this.onNetworkToggle,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> stateNotLossPages = [
      HomePage(onPageNav: onPageNav, onProductSelect: onProductSelect, onCategorySelect: onCategorySelect),
      CartPage(onPageNav: onPageNav, onProductSelect: onProductSelect, selectedProductCategory: selectedProductCategory),
      FavoritesPage(onPageNav: onPageNav, onProductSelect: onProductSelect, selectedProductCategory: selectedProductCategory),
      Viewcategoriespage(onProductSelect: onProductSelect, selectedProductCategory: selectedProductCategory),
      ViewProductDetailsPage(selectedProduct: selectedProduct),
      Viewcategoriespage(onProductSelect: onProductSelect, selectedProductCategory: selectedProductCategory),
    ];

    if (index == 8) {
      return CheckOutPage(onPageNav: onPageNav);
    } else if (index == 9) {
      return ProfilePage();
    } else if (index == 10) {
      return SettingsPage(onNetworkToggle: onNetworkToggle); // PASS callback
    } else if (index >= 0 && index < stateNotLossPages.length) {
      return IndexedStack(index: index, children: stateNotLossPages);
    } else {
      return Center(child: Text(CustomLanguages.getTextSync('pageNotFound')));
    }
  }
}
