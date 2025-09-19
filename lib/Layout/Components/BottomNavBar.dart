import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Ensures the nav bar is not obscured by system UI (e.g., notches)
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Main navigation bar container
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    // Google Nav Bar widget
                    child: GNav(
                      selectedIndex:
                          currentIndex, // Currently selected tab index
                      onTabChange: onTap, // Callback when a tab is selected
                      gap: 6, // Gap between icon and text
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      tabBackgroundGradient: const LinearGradient(
                        colors: [Color(0xFFFF7E5F), Color(0xFFFEB47B)],
                      ),
                      backgroundColor: Colors.transparent, // Nav bar background
                      activeColor:
                          Colors.white, // Icon/text color for selected tab
                      color:
                          Colors.white70, // Icon/text color for unselected tabs
                      iconSize: 24, // Icon size
                      curve: Curves.easeInOut, // Animation curve
                      tabs: [
                        // Define each tab with icon and label
                        GButton(icon: Icons.home_outlined, text: 'Home'),
                        GButton(icon: Icons.shopping_cart_outlined, text: 'Cart'),
                        GButton(icon: Icons.favorite_outline, text: 'Favorites'),
                        GButton(icon: Icons.category_outlined, text: 'Products'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
