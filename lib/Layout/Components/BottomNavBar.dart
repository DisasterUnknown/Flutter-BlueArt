import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(String) onCategorySelect;
  final Function(int) onPageNav;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onPageNav,
    required this.onCategorySelect,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
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
                    child: GNav(
                      selectedIndex: currentIndex,
                      onTabChange: (index) {
                        if (index == 3) {
                          onCategorySelect('');
                        }
                        onPageNav(index);
                      },
                      gap: 6,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      tabBackgroundGradient: const LinearGradient(
                        colors: [Color(0xFFFF7E5F), Color(0xFFFEB47B)],
                      ),
                      backgroundColor: Colors.transparent,
                      activeColor: Colors.white,
                      color: Colors.white70,
                      iconSize: 24,
                      curve: Curves.easeInOut,
                      tabs: const [
                        GButton(icon: Icons.home_outlined, text: 'Home'),
                        GButton(
                          icon: Icons.shopping_cart_outlined,
                          text: 'Cart',
                        ),
                        GButton(
                          icon: Icons.favorite_outline,
                          text: 'Favorites',
                        ),
                        GButton(
                          icon: Icons.category_outlined,
                          text: 'Products',
                        ),
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
