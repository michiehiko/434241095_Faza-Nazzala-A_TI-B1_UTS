import 'package:flutter/material.dart';
import '../common/widgets/custom_app_bar.dart';

class AdminTicketDetailScreen extends StatefulWidget {
  final String ticketId;
  final bool initialIsDone;

  const AdminTicketDetailScreen({
    super.key,
    required this.ticketId,
    required this.initialIsDone,
  });

  @override
  State<AdminTicketDetailScreen> createState() =>
      _AdminTicketDetailScreenState();
}

class _AdminTicketDetailScreenState extends State<AdminTicketDetailScreen> {
  late String _currentStatus;
  final List<String> _statusOptions = [
    'Menunggu Respon',
    'Sedang Dikerjakan',
    'Selesai',
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialIsDone ? 'Selesai' : 'Menunggu Respon';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'Kelola Tiket #${widget.ticketId}'),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update Status Tiket',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _currentStatus,
                          isExpanded: true,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: colorScheme.primary,
                          ),
                          items: _statusOptions.map((String status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: status == 'Selesai'
                                      ? Colors.green
                                      : (status == 'Sedang Dikerjakan'
                                            ? Colors.blue
                                            : Colors.orange),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentStatus = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Divider(color: colorScheme.outline.withOpacity(0.2)),
                    const SizedBox(height: 16),

                    Text(
                      'Informasi Pelapor',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Faza (Mahasiswa D4 IT Vokasi)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Deskripsi Masalah',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            'Lampiran Bukti dari User',
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
                                        Icons.image_not_supported_rounded,
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
                      'Tindakan / Balasan Helpdesk',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText:
                            'Tuliskan log perbaikan atau balasan ke user...',
                        filled: true,
                        fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Status tiket dan balasan berhasil disimpan!',
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save_rounded),
                  label: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
