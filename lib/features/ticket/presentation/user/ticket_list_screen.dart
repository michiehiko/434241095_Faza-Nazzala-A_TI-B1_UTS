import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_ticket_screen.dart';
import 'ticket_detail_screen.dart';

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data user yang lagi login sekarang
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,
      
      // Bungkus body dengan StreamBuilder buat dapet data real-time
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tickets')
            .where('userId', isEqualTo: currentUser?.uid) // Filter khusus tiket user ini
            .snapshots(),
        builder: (context, snapshot) {
          // 1. Kondisi saat lagi loading ngambil data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Kondisi kalau error
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan memuat data.'));
          }

          // 3. Kondisi kalau data masih kosong
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Belum ada keluhan yang dibuat.',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
              ),
            );
          }

          // Ambil data list dokumennya
          var docs = snapshot.data!.docs;

          // Urutkan manual dari yang terbaru ke terlama berdasarkan 'createdAt'
          docs.sort((a, b) {
            var aTime = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
            var bTime = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
            if (aTime == null || bTime == null) return 0;
            return bTime.compareTo(aTime);
          });

          // 4. Tampilkan list data asli
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16, bottom: 80),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              // Ekstrak datanya per baris
              var ticket = docs[index].data() as Map<String, dynamic>;
              String ticketId = docs[index].id; // Ambil ID unik Firestore

              bool isDone = ticket['status'] == 'Selesai';
              String title = ticket['title'] ?? 'Tanpa Judul';
              String statusText = ticket['status'] ?? 'Open';

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
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
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