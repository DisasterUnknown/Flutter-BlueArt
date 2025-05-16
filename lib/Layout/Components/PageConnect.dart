import 'package:assignment/Lists/productsList.dart';
import 'package:assignment/Pages/homePage.dart';
import 'package:assignment/Pages/loginPage.dart';
import 'package:assignment/Pages/registerPage.dart';
import 'package:assignment/Pages/viewProductDetails.dart';
import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  final int index;
  final Function(int) onItemTapped;
  final Function(Item)? onProductSelect;
  final Item? selectedProductID;

  const PageContent({required this.index, required this.onItemTapped, this.selectedProductID, this.onProductSelect});

  @override
  Widget build(BuildContext context) {
    // Page Content Section
    // Keep State Page Section
    final List<Widget> stateNotLossPages = [
      HomePage(onItemTapped: onItemTapped, onProductSelect: onProductSelect),
      Text('Index 1: Business'),
    ];


    // Pages where the state should remove
    if (index == 2) {
      return LoginPage(onItemTapped: onItemTapped);
    } else if (index == 3) {
      return RegisterPage(onItemTapped: onItemTapped);
    } else if (index == 4) {
      return ViewProductDetailsPage(ProductID: selectedProductID,);
    } else if (index >= 0 && index < stateNotLossPages.length) {
      return IndexedStack(index: index, children: stateNotLossPages);
    } else {
      return Center(child: Text('Page not found'));
    }
  }
}
