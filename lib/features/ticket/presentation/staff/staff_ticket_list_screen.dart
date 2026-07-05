import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../staff/staff_ticket_detail_screen.dart'; 
import '../user/create_ticket_screen.dart'; 

class StaffTicketListScreen extends StatelessWidget {
  const StaffTicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final colorScheme = Theme.of(context).colorScheme;
    final currentUserId = supabase.auth.currentUser?.id;

    if (currentUserId == null) {
      return const Center(child: Text('Sesi telah berakhir.'));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTicketScreen(),
            ),
          );
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Buat Tiket',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // CCTV StreamBuilder untuk Staff Ahli
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('tickets')
            .stream(primaryKey: ['id'])
            // HAPUS filter dari database karena stream tidak support .or()
            .order('created_at', ascending: false), 
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allTickets = snapshot.data ?? [];

          // =======================================================
          // FILTER LOKAL: Saring tiket hanya yang miliknya / buatannya
          // =======================================================
          final tickets = allTickets.where((ticket) {
            final isAssignedToMe = ticket['assigned_to'] == currentUserId;
            final isCreatedByMe = ticket['user_id'] == currentUserId;
            return isAssignedToMe || isCreatedByMe;
          }).toList();
          // =======================================================

          if (tickets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 64,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada tiket yang ditugaskan kepada Anda.',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 16, bottom: 80), 
            itemCount: tickets.length, 
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              
              final ticketId = ticket['id'].toString();
              final title = ticket['title'] ?? 'Tiket #$ticketId';
              final status = ticket['status']?.toString().toLowerCase() ?? 'open';
              
              bool isDone = status == 'closed' || status == 'selesai';
              final pelapor = ticket['nama_pelapor'] ?? 'Mahasiswa'; 

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 0,
                color: colorScheme.surfaceVariant.withOpacity(0.5),
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
                    title, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pelapor: $pelapor', 
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Status: ${status.toUpperCase()}', 
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StaffTicketDetailScreen( 
                          ticketId: ticketId, 
                          initialIsDone: isDone,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}