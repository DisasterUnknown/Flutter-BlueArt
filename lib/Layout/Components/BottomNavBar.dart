import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(String) onCategorySelect;
  final Function(int) onItemTapped;
  const BottomNavBar({required this.selectedIndex, required this.onItemTapped, required this.onCategorySelect});

  @override
  Widget build(BuildContext context) {
    bool isValidIndex = selectedIndex >= 0 && selectedIndex <= 3;
    print(selectedIndex);

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

      // If the nav is in the nav list!!
      selectedItemColor: isValidIndex ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.surface,
      unselectedItemColor: Theme.of(context).colorScheme.surface,
      type: BottomNavigationBarType.fixed,
      // Page Bottom Navigation
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorits'),
        BottomNavigationBarItem(icon: Icon(Icons.shop_2_outlined), label: 'Products'),
      ],
      currentIndex: isValidIndex ? selectedIndex : 0,
      onTap: (int index) {
        if (index == 2) {
          onCategorySelect('');
        }
        onItemTapped(index);
      },
    );
  }
}
