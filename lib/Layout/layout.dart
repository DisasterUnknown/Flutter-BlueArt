// ignore_for_file: deprecated_member_use, sized_box_for_whitespace, unrelated_type_equality_checks, use_build_context_synchronously
import 'package:blue_art_mad2/services/shakeDectector.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:blue_art_mad2/layout/Components/PageConnect.dart';
import 'package:blue_art_mad2/models/products.dart';
import 'package:blue_art_mad2/network/product/product.dart';
import 'package:blue_art_mad2/store/DBHelper.dart';
import 'package:blue_art_mad2/store/liveStore/productLiveStore.dart';
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
  ShakeDetector? _shakeDetector;

  @override
  void initState() {
    super.initState();
    _loadProducts();

    _currentIndex = widget.initialTabIndex;
    _history.add(_currentIndex);

    _shakeDetector = ShakeDetector(
      onShake: () async {
        if (_currentIndex != 0) return;

        // Check internet
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          debugPrint("No internet connection. Shake ignored.");
          return;
        }

        debugPrint("Device shaken! Updating DB...");
        _refreshProducts();
      },
    );
  }

  Future<void> _refreshProducts() async {
    try {
      // Fetch from API
      setState(() => _isLoading = true);
      await NetworkProducts(ref).getArtProducts();
      await NetworkProducts(ref).getCollectiblesProducts();

      // Update offline SQFlite DB
      await ProductDBHelper.updateAllProducts(ProductStore().artProducts, 'art_products');
      await ProductDBHelper.updateAllProducts(ProductStore().collectiblesProducts, 'collectibles_products');
      setState(() => _isLoading = false);

      debugPrint("DB & live store updated successfully!");
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Refresh failed: $e");
    }
  }

  @override
  void dispose() {
    _shakeDetector?.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);

    // Load DB first
    final dbArt = await ProductDBHelper.getProducts('art_products');
    final dbCollectibles = await ProductDBHelper.getProducts('collectibles_products');

    // If DB is not empty
    if (dbArt.isNotEmpty || dbCollectibles.isNotEmpty) {
      ProductStore().setArtProducts(dbArt);
      ProductStore().setCollectiblesProducts(dbCollectibles);
      setState(() => _isLoading = false);
      _fetchAndUpdateProducts();
    } else {
      // If DB is empty
      await _fetchAndUpdateProducts();
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchAndUpdateProducts() async {
    try {
      await NetworkProducts(ref).getArtProducts();
      await NetworkProducts(ref).getCollectiblesProducts();

      await ProductDBHelper.updateAllProducts(ProductStore().artProducts, 'art_products');
      await ProductDBHelper.updateAllProducts(ProductStore().collectiblesProducts, 'collectibles_products');
    } catch (e) {
      debugPrint('API fetch failed: $e');

      final artEmpty = (await ProductDBHelper.getProducts('art_products')).isEmpty;
      final colEmpty = (await ProductDBHelper.getProducts('collectibles_products')).isEmpty;

      if (artEmpty && colEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No products available. Please try again later.')),
        );
      }
    }
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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

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
                  currentIndex: _currentIndex >= 0 && _currentIndex <= 3 ? _currentIndex : -1,
                  onPageNav: _onPageNav,
                  onCategorySelect: _onCategorySelect,
                ),
        ),
      ),
    );
  }
}
