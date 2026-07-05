import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../common/widgets/stat_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Inisialisasi client Supabase
    final supabase = Supabase.instance.client;

    return SafeArea(
      // Menggunakan StreamBuilder untuk Real-time live update ("CCTV")
      child: StreamBuilder<List<Map<String, dynamic>>>(
        // Membaca seluruh tabel 'tickets' secara real-time
        stream: supabase.from('tickets').stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          // 1. Tampilkan loading jika data masih diambil
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Tangani jika terjadi error koneksi/database
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }

          // 3. Ekstrak data list tiket (jika kosong, kembalikan list kosong)
          final List<Map<String, dynamic>> tickets = snapshot.data ?? [];

          // 4. Kalkulasi Statistik secara lokal di frontend
          final int totalTickets = tickets.length;

          // Menghitung tiket yang masih 'open' atau sedang diproses sebagai Perlu Tindakan
          final int perluTindakan = tickets.where((ticket) {
            final status = ticket['status'].toString().toLowerCase();
            // Asumsi sementara: semua yang bukan status akhir masuk ke sini
            return status == 'open' || status == 'in_progress'; 
          }).length;

          final int tiketSelesai = tickets.where((ticket) {
            final status = ticket['status'].toString().toLowerCase();
            return status == 'closed'; // Nanti disesuaikan dengan status akhirmu
          }).length;

          // 5. Render UI
          return SingleChildScrollView(
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

                StatCard(
                  title: 'Total Tiket Masuk',
                  count: totalTickets.toString(),
                  icon: Icons.analytics_outlined,
                  iconColor: Colors.blue,
                ),
                const SizedBox(height: 12),

                StatCard(
                  title: 'Perlu Tindakan',
                  count: perluTindakan.toString(),
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.orange,
                ),
                const SizedBox(height: 12),

                StatCard(
                  title: 'Tiket Selesai',
                  count: tiketSelesai.toString(),
                  icon: Icons.task_alt_rounded,
                  iconColor: Colors.green,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}