import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: CustomColors.getThemeColor(context, 'onSurfaceVariant'),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              color: CustomColors.getThemeColor(context, 'primary'),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: CustomColors.getThemeColor(context, 'bodyLarge'),
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              title: Text(
                'Home',
                style: TextStyle(
                  color: CustomColors.getThemeColor(context, 'bodyLarge'),
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Close the drawer
              },
            ),
            ListTile(
              title: Text(
                'Products',
                style: TextStyle(
                  color: CustomColors.getThemeColor(context, 'bodyLarge'),
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // onCategorySelect('all');
                // onItemTapped(2); // Close the drawer
              },
            ),
            ListTile(
              title: Text(
                'Cart',
                style: TextStyle(
                  color: CustomColors.getThemeColor(context, 'bodyLarge'),
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // onItemTapped(1); // Close the drawer
              },
            ),
            ListTile(
              title: Text(
                'Favorites',
                style: TextStyle(
                  color: CustomColors.getThemeColor(context, 'bodyLarge'),
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // onItemTapped(2); // Close the drawer
              },
            ),
            ListTile(
              title: Text(
                'Login',
                style: TextStyle(
                  color: CustomColors.getThemeColor(context, 'bodyLarge'),
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // onItemTapped(6); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
