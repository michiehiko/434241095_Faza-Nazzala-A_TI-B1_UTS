import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final supabase = Supabase.instance.client;
    final currentUserId = supabase.auth.currentUser?.id;

    if (currentUserId == null) {
      return const Center(child: Text('Sesi telah berakhir.'));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        // CCTV: Pantau tiket yang DITUGASKAN ke staff ini saja
        stream: supabase
            .from('tickets')
            .stream(primaryKey: ['id'])
            .eq('assigned_to', currentUserId), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tickets = snapshot.data ?? [];

          // Kalkulasi Statistik
          int totalTiket = tickets.length;
          int menungguRespon = 0;
          int sedangDikerjakan = 0;
          int selesai = 0;

          for (var ticket in tickets) {
            final status = ticket['status']?.toString().toLowerCase() ?? 'open';
            if (status == 'closed' || status == 'selesai') {
              selesai++;
            } else if (status == 'in_progress' || status == 'sedang dikerjakan') {
              sedangDikerjakan++;
            } else {
              menungguRespon++;
            }
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistik Kinerja',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pantau perkembangan tiket yang ditugaskan kepada Anda secara real-time.',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Grid Kartu Statistik
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildStatCard(
                      context,
                      title: 'Total\nTiket',
                      count: totalTiket.toString(),
                      icon: Icons.confirmation_number_outlined,
                      color: colorScheme.primary,
                    ),
                    _buildStatCard(
                      context,
                      title: 'Menunggu\nRespon',
                      count: menungguRespon.toString(),
                      icon: Icons.pending_actions_rounded,
                      color: Colors.orange,
                    ),
                    _buildStatCard(
                      context,
                      title: 'Sedang\nDikerjakan',
                      count: sedangDikerjakan.toString(),
                      icon: Icons.engineering_outlined,
                      color: Colors.blue,
                    ),
                    _buildStatCard(
                      context,
                      title: 'Selesai\nDitangani',
                      count: selesai.toString(),
                      icon: Icons.check_circle_outline_rounded,
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget pendukung untuk mencetak kartu agar kode lebih rapi
  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Text(
                count,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.7),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}