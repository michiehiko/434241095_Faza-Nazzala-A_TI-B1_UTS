import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../common/widgets/custom_app_bar.dart';

class TicketDetailScreen extends StatelessWidget {
  final String ticketId;

  const TicketDetailScreen({
    super.key,
    required this.ticketId,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final supabase = Supabase.instance.client; 

    // Pastikan ID tiket aman dikonversi ke Integer jika databasemu pakai INT untuk foreign key
    final safeTicketId = int.tryParse(ticketId) ?? ticketId;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Detail Tiket'),
      
      // CCTV 1: Memantau tabel 'tickets'
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('tickets')
            .stream(primaryKey: ['id'])
            .eq('id', ticketId)
            .limit(1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data tiket tidak ditemukan.'));
          }

          var ticket = snapshot.data!.first;
          bool isDone = ticket['status'] == 'closed' || ticket['status'] == 'selesai';
          String title = ticket['title'] ?? 'Tanpa Judul';
          String desc = ticket['description'] ?? 'Tidak ada deskripsi.';
          String? imageUrl = ticket['image_url']; 
          
          String dateString = 'Waktu tidak diketahui';
          if (ticket['created_at'] != null) {
            DateTime dt = DateTime.parse(ticket['created_at']).toLocal();
            String hours = dt.hour.toString().padLeft(2, '0');
            String minutes = dt.minute.toString().padLeft(2, '0');
            dateString = '${dt.day}/${dt.month}/${dt.year}, $hours:$minutes WIB';
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDone
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ticket['status']?.toString().toUpperCase() ?? 'OPEN',
                            style: TextStyle(
                              color: isDone ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dilaporkan pada: $dateString',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deskripsi Masalah',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                desc,
                                style: TextStyle(
                                  height: 1.5,
                                  color: colorScheme.onSurface.withOpacity(0.8),
                                ),
                              ),

                              if (imageUrl != null && imageUrl.toString().isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Divider(color: colorScheme.outline.withOpacity(0.2)),
                                const SizedBox(height: 12),
                                Text(
                                  'Lampiran',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrl, 
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                      height: 180,
                                      color: colorScheme.surfaceVariant,
                                      child: const Center(
                                        child: Icon(Icons.broken_image_rounded, size: 40),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'Tanggapan Helpdesk',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // ==========================================
                        // CCTV 2: Memantau tabel 'comments'
                        // ==========================================
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: supabase
                              .from('comments')
                              .stream(primaryKey: ['id'])
                              .eq('ticket_id', safeTicketId) // Filter komentar khusus tiket ini
                              .order('created_at', ascending: true), // Urut dari terlama ke terbaru
                          builder: (context, commentSnapshot) {
                            if (commentSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final comments = commentSnapshot.data ?? [];

                            if (comments.isEmpty) {
                              return Text(
                                'Belum ada tanggapan dari tim IT.',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                              );
                            }

                            // Render list balasan menggunakan Column
                            return Column(
                              children: comments.map((comment) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colorScheme.outline.withOpacity(0.3),
                                    ),
                                    color: colorScheme.surfaceVariant.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    comment['message'] ?? '',
                                    style: TextStyle(color: colorScheme.onSurface),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                        // ==========================================
                      ],
                    ),
                  ),
                ),

                // Kolom chat balasan (Note: ini UI-nya masih statis sesuai aslinya, 
                // siap disambung fungsinya kalau mahasiswa juga diizinkan balas pesan Admin)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      top: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Tulis balasan...',
                            filled: true,
                            fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: colorScheme.primary,
                        child: IconButton(
                          icon: Icon(Icons.send_rounded, color: colorScheme.onPrimary, size: 20),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}