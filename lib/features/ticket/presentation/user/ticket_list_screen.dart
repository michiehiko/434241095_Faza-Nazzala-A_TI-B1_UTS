import 'package:flutter/material.dart';
import 'create_ticket_screen.dart';
import 'ticket_detail_screen.dart';

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 80),
        itemCount: 10,
        itemBuilder: (context, index) {
          bool isDone = index % 3 == 0;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            color: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.5),
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
                'Keluhan Jaringan WiFi #${index + 100}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  isDone ? 'Status: Selesai' : 'Status: Menunggu Respon',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
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
                    builder: (context) => TicketDetailScreen(
                      ticketId: '${index + 100}',
                      isDone: isDone,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTicketScreen()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }
}
