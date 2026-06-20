import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Panggil mesin Supabase dan cek user yang lagi aktif
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;

    return SafeArea(
      // Bungkus padding utama dengan StreamBuilder (CCTV Realtime)
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('tickets')
            .stream(primaryKey: ['id'])
            .eq('user_id', currentUser?.id ?? ''), // Khusus tiket user ini
        builder: (context, snapshot) {
          // Kalau lagi loading nunggu data dari internet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Variabel default kalau datanya kosong/error
          int totalTiket = 0;
          int tiketAktif = 0;

          // Kalau data sukses ditarik, kita hitung!
          if (snapshot.hasData) {
            final docs = snapshot.data!;
            totalTiket = docs.length; // Hitung total semua tiket
            
            // Hitung yang aktif (statusnya belum 'Selesai')
            tiketAktif = docs.where((tiket) => tiket['status'] != 'Selesai').length;
          }

          // DI BAWAH INI ADALAH UI ASLI KAMU 100%
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ringkasan Tiket Anda',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.confirmation_number,
                      color: Colors.blue,
                      size: 40,
                    ),
                    title: const Text('Total Tiket'),
                    subtitle: const Text('Semua tiket yang pernah dibuat'),
                    // Masukin variabel totalTiket ke sini!
                    trailing: Text(
                      '$totalTiket', 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.pending_actions,
                      color: Colors.orange,
                      size: 40,
                    ),
                    title: const Text('Tiket Aktif'),
                    subtitle: const Text('Menunggu respon helpdesk'),
                    // Masukin variabel tiketAktif ke sini!
                    trailing: Text(
                      '$tiketAktif', 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
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