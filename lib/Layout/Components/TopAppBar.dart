import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.getThemeColor(context, 'primary'), 
      foregroundColor: CustomColors.getThemeColor(context, 'onPrimary'),
      title: GestureDetector(
        child: Text(
          'BlueArt',
          style: TextStyle(
            color: CustomColors.getThemeColor(context, 'bodyLarge'),
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
