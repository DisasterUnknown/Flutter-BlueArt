import 'package:assignment/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment/Layout/Components/TopAppBar.dart';
import 'package:assignment/Layout/Components/BottomNavBar.dart';
import 'package:assignment/Layout/Components/PageConnect.dart';
import 'package:assignment/Layout/Components/AppDrawer.dart';
import 'package:assignment/Lists/productsList.dart';
import 'package:flutter/rendering.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;
  Item _selectedProduct = artProductList[0];
  bool _isBottomNavVisible = true; 

  // Page Navigate index Store
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Details Page product ID Store
  void _onProductSelect(Item product) {
    setState(() {
      _selectedProduct = product;
      _selectedIndex = 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SafeArea(
        child: Scaffold(
          // Top App Bar Component
          appBar: TopAppBar(),

          // AppDrawer component
          drawer: AppDrawer(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),

          // Page Connect Component
          body: NotificationListener<UserScrollNotification>(
            // Checking the scrole direction to hide the bottum nav bar 
            onNotification: (notification) {
              if (isLandScape) {
                if (notification.direction == ScrollDirection.reverse && _isBottomNavVisible) {
                  setState(() {
                    _isBottomNavVisible = false;
                  });
                } else if (notification.direction == ScrollDirection.forward && !_isBottomNavVisible) {
                  setState(() {
                    _isBottomNavVisible = true;
                  });
                }
              }
              return false;
            },

            child: PageContent(
              index: _selectedIndex,
              onItemTapped: _onItemTapped,
              selectedProduct: _selectedProduct,
              onProductSelect: _onProductSelect,
            ),
          ),

          // Bottum Nav Bar Component
          bottomNavigationBar: BottomNavBar(
            selectedIndex:
                _selectedIndex >= 0 && _selectedIndex <= 2
                    ? _selectedIndex
                    : -1,
            onItemTapped: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
