import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showMenu;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showMenu = true,
    this.actionIcon,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 50,
      backgroundColor: Colors.green,
      elevation: 0,
      centerTitle: true,
      leading: showMenu
          ? Builder(
        builder: (c) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 30,),
          onPressed: () => Scaffold.of(c).openDrawer(),
        ),
      )
          : IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      actions: actionIcon != null
          ? [
        IconButton(
          icon: Icon(actionIcon, color: Colors.white, size: 30,),
          onPressed: onActionPressed,
        ),
      ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
