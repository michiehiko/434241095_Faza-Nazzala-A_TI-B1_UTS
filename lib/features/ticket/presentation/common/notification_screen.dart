import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // 1. Inisialisasi Supabase dan ambil ID user yang sedang login
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    // Safety check jika tiba-tiba user ter-logout
    if (userId == null) {
      return const Center(child: Text('Sesi telah berakhir. Silakan login kembali.'));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      // 2. Bungkus dengan StreamBuilder untuk CCTV Real-time
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('notifications')
            .stream(primaryKey: ['id'])
            .eq('user_id', userId) // Filter: Hanya ambil notif milik user ini
            .order('created_at', ascending: false), // Urutkan dari yang paling baru
        builder: (context, snapshot) {
          // Handling Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handling Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat notifikasi: ${snapshot.error}',
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }

          // Ekstrak data notifikasi
          final notifications = snapshot.data ?? [];

          // Handling State Kosong
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada notifikasi',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          // 3. Render List Jika Data Ada
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              
              // Asumsi kolom tabel: 'title', 'message', 'created_at'
              final title = notif['title'] ?? 'Pembaruan Tiket';
              final message = notif['message'] ?? 'Ada pembaruan pada tiket Anda.';
              
              // Parsing format waktu (created_at) dari Supabase ke bentuk jam/menit
              final createdAt = notif['created_at'] != null 
                  ? DateTime.parse(notif['created_at']).toLocal() 
                  : DateTime.now();
              final timeString = '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

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
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                  trailing: Text(
                    timeString,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}