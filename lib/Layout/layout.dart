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
  final List<int> _oldSelectedIndex = [0];
  int _selectedIndex = 0;
  String _selectedProductCategory = '';
  Item _selectedProduct = artProductList[0];

  // Page Navigate index Store
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _oldSelectedIndex.add(_selectedIndex);
    });
  }

  // Details Page product ID Store
  void _onProductSelect(Item product) {
    setState(() {
      _selectedProduct = product;
      _selectedIndex = 4;
      _oldSelectedIndex.add(_selectedIndex);
    });
  }

  // Getting the user Selected Category type
  void _onCategorySelect(String category) {
    setState(() {
      _selectedProductCategory = category;
      _selectedIndex = 5;
      _oldSelectedIndex.add(_selectedIndex);
    });
  }

  // Page Back navigation logic
  void _onGoBack() {
    setState(() {
      _selectedIndex = _oldSelectedIndex[_oldSelectedIndex.length - 2];
      _oldSelectedIndex.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        // System back btn functionality
        child: PopScope(
          canPop: _oldSelectedIndex.length == 1,
          onPopInvoked: (didpop) {
            if (!didpop && _oldSelectedIndex.length != 1) {
              setState(() {
                _onGoBack();
              });
            }
          },

          child: Scaffold(
            // Top App Bar Component
            appBar: TopAppBar(index: _selectedIndex, onItemTapped: _onItemTapped, onGoBack: _onGoBack),

            // AppDrawer component
            drawer: AppDrawer(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped, onCategorySelect: _onCategorySelect),

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
            bottomNavigationBar:
                isLandScape ? null : BottomNavBar(selectedIndex: _selectedIndex >= 0 && _selectedIndex <= 3 ? _selectedIndex : -1, onItemTapped: _onItemTapped, onCategorySelect: _onCategorySelect),
          ),
        ),
      ),
    );
  }
}
