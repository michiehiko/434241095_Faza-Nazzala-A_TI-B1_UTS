// lib/features/ticket/presentation/common/widgets/info_tile.dart
import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(
        title, 
        style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6))
      ),
      subtitle: Text(
        subtitle, 
        style: TextStyle(fontSize: 16, color: colorScheme.onSurface, fontWeight: FontWeight.w500)
      ),
    );
  }
}