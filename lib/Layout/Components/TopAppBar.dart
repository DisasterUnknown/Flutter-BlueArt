import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int index;
  final Function(int) onItemTapped;
  final Function() onGoBack;
  const TopAppBar({required this.index, required this.onItemTapped, required this.onGoBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        child: Text('BlueArt', style: Theme.of(context).textTheme.bodyLarge),
        onTap: () {
          onItemTapped(0);
        },
      ),
      leading: Builder(
        builder: (BuildContext context) {
          if (index != 3 && index != 4 && index != 7 && index != 8) {
            return IconButton(
              icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onPrimary, size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          } else {
            return IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary, size: 30),
              onPressed: () {
                if (index == 7) {
                  onItemTapped(6);
                } else if (index == 8) {
                  onItemTapped(1);
                } else {
                  onGoBack();
                }
              },
            );
          }
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
