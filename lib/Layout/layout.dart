import 'package:assignment/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment/Layout/Components/TopAppBar.dart';
import 'package:assignment/Layout/Components/BottomNavBar.dart';
import 'package:assignment/Layout/Components/PageConnect.dart';
import 'package:assignment/Layout/Components/AppDrawer.dart';
import 'package:assignment/Lists/productsList.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;
  String _selectedProductCategory = '';
  Item _selectedProduct = artProductList[0];

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
      _selectedIndex = 3;
    });
  }

  // Getting the user Selected Category type
  void _onCategorySelect(String category) {
    setState(() {
      _selectedProductCategory = category;
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
        // System back btn functionality
        child: PopScope(
          canPop: _selectedIndex == 0,
          onPopInvoked: (didpop) {
            if (!didpop && _selectedIndex != 0) {
              setState(() {
                if (_selectedIndex == 7) {
                  _selectedIndex = 6;
                } else if (_selectedIndex == 8) {
                  _selectedIndex = 1;
                } else {
                  _selectedIndex = 0;
                }
              });
            }
          },
          child: Scaffold(
            // Top App Bar Component
            appBar: TopAppBar(index: _selectedIndex, onItemTapped: _onItemTapped,),
          
            // AppDrawer component
            drawer: AppDrawer(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
              onCategorySelect: _onCategorySelect,
            ),
          
            // Page Connect Component
            body: PageContent(
              index: _selectedIndex,
              onItemTapped: _onItemTapped,
              selectedProduct: _selectedProduct,
              onProductSelect: _onProductSelect,
              selectedProductCategory: _selectedProductCategory,
              onCategorySelect: _onCategorySelect,
            ),
          
            // Bottum Nav Bar Component
            bottomNavigationBar: isLandScape
              ? null
              : BottomNavBar(
                selectedIndex:
                    _selectedIndex >= 0 && _selectedIndex <= 2
                        ? _selectedIndex
                        : -1,
                onItemTapped: _onItemTapped,
                onCategorySelect: _onCategorySelect,
            ),
          ),
        ),
      ),
    );
  }
}
