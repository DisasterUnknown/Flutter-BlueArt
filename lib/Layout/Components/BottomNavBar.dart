import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    bool isValidIndex = selectedIndex >= 0 && selectedIndex <= 2;

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

      // If the nav is in the nav list!!
      selectedItemColor: isValidIndex 
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.onPrimary,
      unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
      type: BottomNavigationBarType.fixed,
      // Page Bottom Navigation
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shop_2_outlined), label: 'Products',),
        BottomNavigationBarItem(icon: Icon(Icons.login_outlined), label: 'Logout',),
      ],
      currentIndex: isValidIndex ? selectedIndex : 0,
      onTap: onItemTapped,
    );
  }
}
