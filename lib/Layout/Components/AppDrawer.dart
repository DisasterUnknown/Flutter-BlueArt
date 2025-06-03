import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Function(String) onCategorySelect;
  const AppDrawer({required this.selectedIndex, required this.onItemTapped, required this.onCategorySelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(16.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [Text('Menu', style: Theme.of(context).textTheme.bodyLarge)]),
            ),

            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                onItemTapped(0); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Products'),
              onTap: () {
                Navigator.pop(context);
                onCategorySelect('all');
                onItemTapped(2); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                onItemTapped(1); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                onItemTapped(2); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Login'),
              onTap: () {
                Navigator.pop(context);
                onItemTapped(6); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
