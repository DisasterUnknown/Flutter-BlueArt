import 'package:blue_art_mad2/layout/Components/PageConnect.dart';
import 'package:blue_art_mad2/lists/productsList.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';
import 'package:blue_art_mad2/layout/Components/TopAppBar.dart';
import 'package:blue_art_mad2/layout/Components/BottomNavBar.dart';
import 'package:blue_art_mad2/layout/Components/AppDrawer.dart';

class Layout extends StatefulWidget {
  final int initialTabIndex;
  const Layout({super.key, this.initialTabIndex = 0});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final List<int> _history = [];
  int _currentIndex = 0;
  Item? _selectedProduct;
  String _selectedProductCategory = '';

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
    _history.add(_currentIndex);
  }

  void _onProductSelect(Item product) {
    setState(() {
      _selectedProduct = product;
      _currentIndex = 4;
    });
  }

  void _onCategorySelect(String category) {
    setState(() {
      _selectedProductCategory = category;
      _currentIndex = 5;
    });
  }

  void _onPageNav(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
        _history.add(index);
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_history.length > 1) {
      setState(() {
        _history.removeLast();
        _currentIndex = _history.last;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: CustomColors.getThemeColor(context, 'surface'),
          appBar: TopAppBar(),
          drawer: AppDrawer(onTabSelect: _onPageNav),
          body: PageContent(
            index: _currentIndex,
            onPageNav: _onPageNav,
            selectedProduct: _selectedProduct,
            onProductSelect: _onProductSelect,
            selectedProductCategory: _selectedProductCategory,
            onCategorySelect: _onCategorySelect,
          ),
          bottomNavigationBar: isLandscape
              ? null
              : CustomBottomNavBar(currentIndex: _currentIndex >= 0 && _currentIndex <= 3 ? _currentIndex : -1, onPageNav: _onPageNav, onCategorySelect: _onCategorySelect),
        ),
      ),
    );
  }
}
