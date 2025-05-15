import 'package:assignment/Pages/loginPage.dart';
import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  final int index;
  final Function(int) onItemTapped;
  const PageContent({required this.index, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    // Page Content Section
    return IndexedStack(index: index, children: [
      Text('Index 0: Home'),
      Text('Index 1: Business'),
      LoginPage(onItemTapped: onItemTapped),
      Text("Register Page"),
    ]);
  }
}