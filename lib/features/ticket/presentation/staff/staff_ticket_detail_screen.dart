import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../common/widgets/custom_app_bar.dart'; 

class StaffTicketDetailScreen extends StatefulWidget {
  final String ticketId;
  final bool initialIsDone;

  const StaffTicketDetailScreen({
    super.key,
    required this.ticketId,
    required this.initialIsDone,
  });

  @override
  State<StaffTicketDetailScreen> createState() =>
      _StaffTicketDetailScreenState();
}

class _StaffTicketDetailScreenState extends State<StaffTicketDetailScreen> {
  late Future<Map<String, dynamic>> _ticketFuture;
  final supabase = Supabase.instance.client;
  
  final TextEditingController _balasanController = TextEditingController();
  bool _isReplying = false;
  bool _isClosing = false;
  
  String? _ticketOwnerId; 
  String _dbStatus = 'open'; 

  @override
  void initState() {
    super.initState();
    _ticketFuture = _fetchTicketDetail();
  }

  @override
  void dispose() {
    _balasanController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchTicketDetail() async {
    final data = await supabase
        .from('tickets')
        .select()
        .eq('id', widget.ticketId)
        .single();
    
    _ticketOwnerId = data['user_id']?.toString(); 
    _dbStatus = data['status']?.toString().toLowerCase() ?? 'open';
    
    return data;
  }

  // =========================================================================
  // FUNGSI SAKTI: Kirim notif dengan pengecekan profil (ANTI ERROR 23503)
  // =========================================================================
  Future<void> _safeSendNotification(String? targetUserId, String message) async {
    if (targetUserId == null) return;
    try {
      // Cek apakah user benar-benar ada di tabel profiles
      final profileCheck = await supabase
          .from('profiles')
          .select('id')
          .eq('id', targetUserId)
          .maybeSingle();

      if (profileCheck != null) {
        await supabase.from('notifications').insert({
          'user_id': targetUserId,
          'ticket_id': widget.ticketId,
          'title': 'Update Tiket #${widget.ticketId}',
          'message': message,
          'is_read': false,
        });
      }
    } catch (e) {
      print("Gagal kirim notif ke $targetUserId: $e");
    }
  }

  Future<void> _handleKirimBalasan() async {
    if (_balasanController.text.trim().isEmpty) return;
    setState(() => _isReplying = true);

    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) throw "Sesi login berakhir";

      // 1. Simpan Komentar (User ID Dijamin Masuk!)
      await supabase.from('comments').insert({
        'ticket_id': widget.ticketId, 
        'user_id': currentUserId, 
        'message': _balasanController.text.trim(),
      });
      
      // 2. Kirim Notif ke Mahasiswa (Pelapor)
      await _safeSendNotification(
        _ticketOwnerId, 
        'Teknisi membalas: "${_balasanController.text.trim()}"',
      );

      // 3. Kirim Notif ke Semua Admin
      final admins = await supabase.from('profiles').select('id').eq('role', 'admin');
      for (var admin in admins) {
        await _safeSendNotification(
          admin['id']?.toString(), 
          'Teknisi membalas Tiket #${widget.ticketId}: "${_balasanController.text.trim()}"',
        );
      }

      if (mounted) {
        _balasanController.clear();
        setState(() {
          _ticketFuture = _fetchTicketDetail();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Balasan berhasil dikirim!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim balasan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isReplying = false);
    }
  }

  Future<void> _handleTutupTiket() async {
    setState(() => _isClosing = true);

    try {
      await supabase
          .from('tickets')
          .update({'status': 'closed'})
          .eq('id', widget.ticketId);

      // Notif ke Mahasiswa
      await _safeSendNotification(
        _ticketOwnerId, 
        'Tiket #${widget.ticketId} telah SELESAI dikerjakan dan ditutup oleh Teknisi.',
      );
      
      // Notif ke Admin
      final admins = await supabase.from('profiles').select('id').eq('role', 'admin');
      for (var admin in admins) {
        await _safeSendNotification(
          admin['id']?.toString(), 
          'Tiket #${widget.ticketId} telah DITUTUP (Selesai) oleh Staff Ahli.',
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tiket berhasil diselesaikan (Closed)!')),
        );
        Navigator.pop(context); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menutup tiket: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isClosing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'Kelola Tiket #${widget.ticketId}'),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _ticketFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error memuat tiket: ${snapshot.error}'));
            }

            final data = snapshot.data!;
            final pelapor = data['nama_pelapor'] ?? 'Mahasiswa';
            final deskripsi = data['description'] ?? 'Tidak ada deskripsi.';
            final imageUrl = data['image_url']; 
            
            bool isClosed = _dbStatus == 'closed' || _dbStatus == 'selesai';

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status Saat Ini:', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isClosed ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isClosed ? Colors.green : Colors.blue),
                              ),
                              child: Text(
                                isClosed ? 'CLOSED (Selesai)' : 'IN PROGRESS',
                                style: TextStyle(fontWeight: FontWeight.bold, color: isClosed ? Colors.green : Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Divider(color: colorScheme.outline.withOpacity(0.2)),
                        const SizedBox(height: 16),

                        Text('Informasi Pelapor', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6))),
                        const SizedBox(height: 4),
                        Text(pelapor, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                        const SizedBox(height: 16),

                        Text('Deskripsi Masalah', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
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
                              Text(deskripsi, style: TextStyle(height: 1.5, color: colorScheme.onSurface.withOpacity(0.8))),
                              if (imageUrl != null && imageUrl.toString().isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Divider(color: colorScheme.outline.withOpacity(0.2)),
                                const SizedBox(height: 12),
                                Text('Lampiran Bukti dari User', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface.withOpacity(0.6))),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(imageUrl, width: double.infinity, height: 180, fit: BoxFit.cover),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text('Riwayat Tanggapan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                        const SizedBox(height: 16),
                        
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: supabase
                              .from('comments')
                              .stream(primaryKey: ['id'])
                              .eq('ticket_id', widget.ticketId) 
                              .order('created_at', ascending: true), 
                          builder: (context, commentSnapshot) {
                            if (commentSnapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                            final comments = commentSnapshot.data ?? [];
                            if (comments.isEmpty) return Text('Belum ada tanggapan.', style: TextStyle(fontStyle: FontStyle.italic, color: colorScheme.onSurface.withOpacity(0.5)));

                            return Column(
                              children: comments.map((comment) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
                                    color: colorScheme.surfaceVariant.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(comment['message'] ?? '', style: TextStyle(color: colorScheme.onSurface)),
                                );
                              }).toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        if (!isClosed) ...[
                          Text('Kirim Balasan', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _balasanController, 
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintText: 'Tulis respon...',
                                    filled: true,
                                    fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              IconButton.filled(
                                onPressed: _isReplying ? null : _handleKirimBalasan,
                                icon: _isReplying 
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                                  : const Icon(Icons.send_rounded),
                                style: IconButton.styleFrom(backgroundColor: colorScheme.primary, padding: const EdgeInsets.all(16)),
                              )
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ),

                if (!isClosed)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: colorScheme.surface, border: Border(top: BorderSide(color: colorScheme.outline.withOpacity(0.2)))),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _isClosing ? null : _handleTutupTiket, 
                        icon: _isClosing 
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                            : const Icon(Icons.check_circle_rounded),
                        label: Text(_isClosing ? 'Memproses...' : 'Selesaikan Pekerjaan (Close)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, 
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
        ),
      ),
    );
  }
}