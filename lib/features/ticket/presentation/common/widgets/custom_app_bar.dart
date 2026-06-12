import 'package:flutter/material.dart';

// Harus pakai implements PreferredSizeWidget biar Flutter tahu ini buat header atas
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions; // Buat naruh tombol tambahan (opsional)

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      actions: actions,
    );
  }

  // Wajib ada untuk AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}