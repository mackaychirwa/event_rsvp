import 'package:flutter/material.dart';
import '../../screens/settings/settings.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 0.0,
      actions: [
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
          child: Transform.translate(
            offset: const Offset(-10, 0),
            child: const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.black,
              child: Icon(Icons.person, size: 15, color: Colors.white)
            ),
          ),
        ),
      ],
    );
  }
}