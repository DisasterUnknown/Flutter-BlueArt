import 'package:assignment/theme.dart';
import 'package:flutter/material.dart';
import 'package:assignment/Layout/Components/TopAppBar.dart';
import 'package:assignment/Layout/Components/BottomNavBar.dart';
import 'package:assignment/Layout/Components/PageConnect.dart';
import 'package:assignment/Layout/Components/AppDrawer.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          body: PageContent(index: _selectedIndex, onItemTapped: _onItemTapped),

          // Bottum Nav Bar Component
          bottomNavigationBar: BottomNavBar(
            selectedIndex: _selectedIndex >= 0 && _selectedIndex <= 2 ? _selectedIndex : -1,
            onItemTapped: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
