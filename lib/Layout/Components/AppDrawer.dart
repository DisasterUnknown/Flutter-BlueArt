import 'package:blue_art_mad2/network/auth/login.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget  {
  final void Function(int) onTabSelect;

  const AppDrawer({required this.onTabSelect, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: CustomColors.getThemeColor(context, 'bodyLarge'),
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
              ),
            ),

            // Home tab
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
                onTabSelect(0);
              },
            ),

            // Cart tab
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
                onTabSelect(1);
              },
            ),

            // Favorites tab
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
                onTabSelect(2);
              },
            ),

            // Products tab
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
                onTabSelect(3);
              },
            ),

            // Login page (outside Layout)
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(
                  color: CustomColors.getThemeColor(context, 'bodyLarge'),
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              onTap: () async {
                await AuthLogin(ref).logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
