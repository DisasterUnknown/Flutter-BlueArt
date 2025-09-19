import 'package:blue_art_mad2/Pages/cartPage.dart';
import 'package:blue_art_mad2/Pages/favoritesPage.dart';
import 'package:blue_art_mad2/Pages/homePage.dart';
import 'package:blue_art_mad2/Pages/viewCategoriesPage.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';
import 'package:blue_art_mad2/layout/Components/TopAppBar.dart';
import 'package:blue_art_mad2/layout/Components/BottomNavBar.dart';
import 'package:blue_art_mad2/layout/Components/AppDrawer.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final List<int> _oldSelectedIndex = [0];
  int _currentIndex = 0;

  List<Widget> get _screens {
    return [
      const HomePage(),
      const CartPage(),
      const FavoritesPage(),
      const Viewcategoriespage(),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  // Recording the page navigation
  void _onPageNav(int index) {
    setState(() {
      _oldSelectedIndex.add(index);
    });
  }

  // Page Back navigation logic
  void _onGoBack() {
    setState(() {
      _currentIndex = _oldSelectedIndex[_oldSelectedIndex.length - 2];
      _oldSelectedIndex.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: PopScope(
          canPop: _oldSelectedIndex.length == 1,
          // ignore: deprecated_member_use
          onPopInvoked: (didpop) {
            if (!didpop && _oldSelectedIndex.length != 1) {
              setState(() {
                _onGoBack();
              });
            }
          },

          child: Scaffold(
            backgroundColor: CustomColors.getThemeColor(context, 'surface'),
            appBar: TopAppBar(),
            drawer: AppDrawer(),
            body: _screens[_currentIndex],
            // Bottum Nav Bar Component
            bottomNavigationBar: isLandscape
                ? null
                : CustomBottomNavBar(
                    currentIndex: _currentIndex,
                    onTap: (index) => {
                      setState(() {
                        _currentIndex = index;
                        _onPageNav(index);
                      }),
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
