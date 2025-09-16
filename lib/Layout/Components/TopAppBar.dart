import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        child: Text('BlueArt', style: Theme.of(context).textTheme.bodyLarge),
        onTap: () {
          
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
