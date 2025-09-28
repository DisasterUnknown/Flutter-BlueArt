import 'package:blue_art_mad2/layout/Components/PageConnect.dart';
import 'package:blue_art_mad2/models/products.dart';
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
  Product? _selectedProduct;
  String _selectedProductCategory = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();

    _currentIndex = widget.initialTabIndex;
    _history.add(_currentIndex);
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    await NetworkProducts(ref).getArtProducts();
    await NetworkProducts(ref).getCollectiblesProducts();
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _onProductSelect(Product product) {
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
          appBar: TopAppBar(onTabSelect: _onPageNav),
          drawer: AppDrawer(onTabSelect: _onPageNav),
          body: _isLoading
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Spinner
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 6,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            CustomColors.getThemeColor(context, 'onPrimary'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Loading text
                      Text(
                        "Loading products...",
                        style: TextStyle(
                          color: CustomColors.getThemeColor(
                            context,
                            'onPrimary',
                          ),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : PageContent(
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
