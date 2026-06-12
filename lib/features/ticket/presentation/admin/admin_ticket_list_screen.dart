import 'package:flutter/material.dart';
import 'admin_ticket_detail_screen.dart';

class AdminTicketListScreen extends StatelessWidget {
  const AdminTicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      itemCount: 10,
      itemBuilder: (context, index) {
        bool isDone = index % 4 == 0;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: isDone
                  ? Colors.green.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
              child: Icon(
                isDone ? Icons.check_circle : Icons.pending,
                color: isDone ? Colors.green : Colors.orange,
              ),
            ),
            title: Text(
              'Keluhan Jaringan WiFi #${index + 200}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pelapor: Faza (Mahasiswa)',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isDone ? 'Status: Selesai' : 'Status: Menunggu Respon',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminTicketDetailScreen(
                    ticketId: '${index + 200}',
                    initialIsDone: isDone,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
