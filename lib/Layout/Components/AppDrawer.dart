import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const AppDrawer({required this.selectedIndex, required this.onItemTapped});

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
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Menu', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),

            
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                onItemTapped(0); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Business'),
              onTap: () {
                Navigator.pop(context);
                onItemTapped(1); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Uni'),
              onTap: () {
                Navigator.pop(context);
                onItemTapped(2); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
