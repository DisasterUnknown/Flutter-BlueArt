// ignore_for_file: file_names, deprecated_member_use
import 'package:blue_art_mad2/network/auth/login.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  final void Function(int) onTabSelect;

  const AppDrawer({required this.onTabSelect, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = CustomColors.getThemeColor(context, 'textColor');
    final bgColor = CustomColors.getThemeColor(context, 'onSurfaceVariant');
    final primary = CustomColors.getThemeColor(context, 'primary');

    return Drawer(
      elevation: 8,
      child: Container(
        color: bgColor,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Main Menu',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Top navigation section
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    _drawerItem(
                      context,
                      icon: Icons.home_rounded,
                      title: 'Home',
                      onTap: () {
                        Navigator.pop(context);
                        onTabSelect(0);
                      },
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.shopping_cart_rounded,
                      title: 'Cart',
                      onTap: () {
                        Navigator.pop(context);
                        onTabSelect(1);
                      },
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.favorite_rounded,
                      title: 'Favorites',
                      onTap: () {
                        Navigator.pop(context);
                        onTabSelect(2);
                      },
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.storefront_rounded,
                      title: 'Products',
                      onTap: () {
                        Navigator.pop(context);
                        onTabSelect(3);
                      },
                    ),
                  ],
                ),
              ),

              // Divider + bottom section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  color: Colors.grey.shade600.withOpacity(0.4),
                  thickness: 1,
                ),
              ),

              // Bottom items
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    _drawerItem(
                      context,
                      icon: Icons.settings_rounded,
                      title: 'Settings',
                      onTap: () {
                        Navigator.pop(context);
                        onTabSelect(10);
                      },
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      color: Colors.redAccent,
                      onTap: () async {
                        await AuthLogin(ref).logout(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final textColor = color ?? CustomColors.getThemeColor(context, 'textColor');
    final hoverColor = CustomColors.getThemeColor(context, 'primary').withOpacity(0.15);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: hoverColor,
      hoverColor: hoverColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
