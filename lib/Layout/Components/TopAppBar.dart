import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int index;
  final Function(int) onItemTapped;
  const TopAppBar({required this.index, required this.onItemTapped});

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
          if (index != 3 && index != 4) {
            return IconButton(
              icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onPrimary, size: 30,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          } else {
            return IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary, size: 30,),
              onPressed: () {
                onItemTapped(0);
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
