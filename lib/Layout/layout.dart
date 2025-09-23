import 'package:blue_art_mad2/layout/Components/PageConnect.dart';
import 'package:blue_art_mad2/lists/productsList.dart';
import 'package:blue_art_mad2/network/product/product.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';
import 'package:blue_art_mad2/layout/Components/TopAppBar.dart';
import 'package:blue_art_mad2/layout/Components/BottomNavBar.dart';
import 'package:blue_art_mad2/layout/Components/AppDrawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Layout extends ConsumerStatefulWidget {
  final int initialTabIndex;
  const Layout({super.key, this.initialTabIndex = 0});

  @override
  ConsumerState<Layout> createState() => _LayoutState();
}

class _LayoutState extends ConsumerState<Layout> {
  final List<int> _history = [];
  int _currentIndex = 0;
  Item? _selectedProduct;
  String _selectedProductCategory = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();

    _currentIndex = widget.initialTabIndex;
    _history.add(_currentIndex);
  }

  Future<void> _loadProducts() async {
    await NetworkProducts(ref).getArtProducts();
    await NetworkProducts(ref).getCollectiblesProducts();
    print("Getting data!!");
    setState(() {});
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

      if (index == 0 || index == 3) {
        _loadProducts();
      }
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
              : CustomBottomNavBar(
                  currentIndex: _currentIndex >= 0 && _currentIndex <= 3
                      ? _currentIndex
                      : -1,
                  onPageNav: _onPageNav,
                  onCategorySelect: _onCategorySelect,
                ),
        ),
      ),
    );
  }
}
