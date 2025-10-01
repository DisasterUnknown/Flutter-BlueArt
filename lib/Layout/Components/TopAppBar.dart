// ignore_for_file: file_names

import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(int) onTabSelect;
  const TopAppBar({required this.onTabSelect, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.getThemeColor(context, 'primary'),
      foregroundColor: CustomColors.getThemeColor(context, 'onPrimary'),
      title: GestureDetector(
        child: Text(
          'BlueArt',
          style: TextStyle(
            color: CustomColors.getThemeColor(context, 'textColor'),
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
        onTap: () {
          onTabSelect(0);
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: Icon(
              Icons.account_circle,
              color: CustomColors.getThemeColor(context, 'textColor'),
              size: 30.0,
            ),
            onPressed: () {
              onTabSelect(9);
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
