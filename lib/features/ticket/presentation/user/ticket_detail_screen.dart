import 'package:flutter/material.dart';
import '../common/widgets/custom_app_bar.dart';

class TicketDetailScreen extends StatelessWidget {
  final String ticketId;
  final bool isDone;

  const TicketDetailScreen({
    super.key,
    required this.ticketId,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'Detail Tiket #$ticketId'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDone
                            ? Colors.green.withOpacity(0.2)
                            : Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isDone ? 'Selesai' : 'Menunggu Respon',
                        style: TextStyle(
                          color: isDone ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Keluhan Jaringan WiFi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dilaporkan pada: 21 Apr 2026, 08:30 WIB',
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
                            'Koneksi WiFi di area Lab Komputer lantai 2 tiba-tiba terputus sejak pagi. Tidak ada SSID yang muncul di daftar jaringan.',
                            style: TextStyle(
                              height: 1.5,
                              color: colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),

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
                              'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?q=80&w=600&auto=format&fit=crop',
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 180,
                                    color: colorScheme.surfaceVariant,
                                    child: const Center(
                                      child: Icon(
                                        Icons.wifi_off_rounded,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
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
                          'Kabel *switch* utama sudah diganti dan *router* sudah di-*restart*. Jaringan sudah kembali normal. Silakan dicek kembali.',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                  ],
                ),
              ),
            ),

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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
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
                      icon: Icon(
                        Icons.send_rounded,
                        color: colorScheme.onPrimary,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
