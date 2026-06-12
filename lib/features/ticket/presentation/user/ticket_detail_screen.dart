import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../common/widgets/custom_app_bar.dart';

class TicketDetailScreen extends StatelessWidget {
  final String ticketId;

  // Kita hapus parameter isDone dari sini karena statusnya bakal ditarik langsung dari database
  const TicketDetailScreen({
    super.key,
    required this.ticketId,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Detail Tiket'),
      // Pasang StreamBuilder khusus buat baca 1 dokumen
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tickets')
            .doc(ticketId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Data tiket tidak ditemukan.'));
          }

          // Ekstrak data tiketnya
          var ticket = snapshot.data!.data() as Map<String, dynamic>;
          bool isDone = ticket['status'] == 'Selesai';
          String title = ticket['title'] ?? 'Tanpa Judul';
          String desc = ticket['description'] ?? 'Tidak ada deskripsi.';
          String? imageUrl = ticket['imageUrl'];
          
          // Format tanggalnya biar cantik
          String dateString = 'Waktu tidak diketahui';
          if (ticket['createdAt'] != null) {
            DateTime dt = (ticket['createdAt'] as Timestamp).toDate();
            // Format jadi HH:MM
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
                            ticket['status'] ?? 'Open',
                            style: TextStyle(
                              color: isDone ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          title, // Data asli
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dilaporkan pada: $dateString', // Data asli
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
                                desc, // Data asli
                                style: TextStyle(
                                  height: 1.5,
                                  color: colorScheme.onSurface.withOpacity(0.8),
                                ),
                              ),

                              // Tampilkan blok gambar HANYA jika ada URL gambar
                              if (imageUrl != null) ...[
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
                        if (!isDone)
                          Text(
                            'Belum ada tanggapan dari tim IT.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colorScheme.outline.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              // NOTE: Nanti ini juga bisa ditarik dari kolom 'reply' di database
                              'Keluhan telah kami tindak lanjuti dan sistem sudah kembali normal. Silakan dicek kembali.',
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Kolom chat balasan biarkan statis dulu
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