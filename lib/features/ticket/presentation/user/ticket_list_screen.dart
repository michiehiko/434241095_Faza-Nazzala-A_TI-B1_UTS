import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'create_ticket_screen.dart';
import 'ticket_detail_screen.dart';

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    // Ambil data user dari Supabase Auth
    final currentUser = supabase.auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,

      // Tipe data StreamBuilder disesuaikan
      body: StreamBuilder<List<Map<String, dynamic>>>(
        // Stream Supabase yang udah difilter dan diurutkan otomatis!
        stream: supabase
            .from('tickets')
            .stream(primaryKey: ['id'])
            .eq(
              'user_id',
              currentUser?.id ?? '',
            ) // Filter khusus tiket user ini
            .order(
              'created_at',
              ascending: false,
            ), // Langsung urut dari yang terbaru
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan memuat data.'));
          }

          // Cek kosong atau tidak pakai isEmpty
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Belum ada keluhan yang dibuat.',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            );
          }

          // Data list dokumennya langsung siap pakai (nggak perlu diparsing .docs lagi)
          var docs = snapshot.data!;

          // 4. Tampilkan list data asli
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16, bottom: 80),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              // Supabase langsung ngasih bentuk Map, jadi gak perlu .data() lagi
              var ticket = docs[index];

              // Ambil ID tiket langsung dari nama kolom 'id' di tabel SQL
              String ticketId = ticket['id'];

              bool isDone = ticket['status'] == 'Selesai';
              String title = ticket['title'] ?? 'Tanpa Judul';
              String statusText = ticket['status'] ?? 'Open';

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
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Status: $statusText',
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
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.4),
                  ),
                  onTap: () {
                    // Pindah ke halaman detail sambil bawa ID dokumennya
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketDetailScreen(
                          ticketId: ticketId, // Lempar ID-nya
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
