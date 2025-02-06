import 'package:flutter/material.dart';

class item_arrow extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const item_arrow({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Icon(
              icon,
            ),
          ],
        ),
      ),
    );
  }
}
