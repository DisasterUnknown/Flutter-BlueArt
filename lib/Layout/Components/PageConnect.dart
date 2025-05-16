import 'package:assignment/Pages/homePage.dart';
import 'package:assignment/Pages/loginPage.dart';
import 'package:assignment/Pages/registerPage.dart';
import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  final int index;
  final Function(int) onItemTapped;
  const PageContent({required this.index, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    // Page Content Section
    // Keep State Page Section
    final List<Widget> stateNotLossPages = [
      HomePage(onItemTapped: onItemTapped),
      Text('Index 1: Business'),
    ];

    // Pages where the state should remove
    if (index == 2) {
      return LoginPage(onItemTapped: onItemTapped);
    } else if (index == 3) {
      return RegisterPage(onItemTapped: onItemTapped);
    } else if (index >= 0 && index < stateNotLossPages.length) {
      return IndexedStack(index: index, children: stateNotLossPages);
    } else {
      return Center(child: Text('Page not found'));
    }
  }
}
