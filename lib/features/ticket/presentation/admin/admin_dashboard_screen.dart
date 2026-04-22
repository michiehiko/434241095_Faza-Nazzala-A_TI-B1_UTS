import 'package:flutter/material.dart';
import '../common/widgets/stat_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview Sistem Helpdesk',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pantauan real-time seluruh keluhan IT',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            ),
            const SizedBox(height: 24),

            const StatCard(
              title: 'Total Tiket Masuk',
              count: '156',
              icon: Icons.analytics_outlined,
              iconColor: Colors.blue,
            ),
            const SizedBox(height: 12),

            const StatCard(
              title: 'Perlu Tindakan',
              count: '24',
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.orange,
            ),
            const SizedBox(height: 12),

            const StatCard(
              title: 'Tiket Selesai',
              count: '132',
              icon: Icons.task_alt_rounded,
              iconColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
