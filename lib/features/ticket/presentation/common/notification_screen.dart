import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            color: colorScheme.surfaceVariant.withOpacity(0.4),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: colorScheme.primary,
                ),
              ),
              title: Text(
                'Update Tiket #${105 - index}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Tim Helpdesk telah merespon keluhan Anda. Silakan cek detail tiket.',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
              trailing: Text(
                '${index * 10 + 5}m',
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
