import 'package:flutter/material.dart';
import '../common/widgets/custom_app_bar.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Hardware (PC/Laptop)';

  final List<String> _categories = [
    'Hardware (PC/Laptop)',
    'Software (Aplikasi/OS)',
    'Jaringan (WiFi/LAN)',
    'Lainnya',
  ];

  bool _isUploading = false;
  bool _isFileAttached = false;

  void _simulateUpload() {
    setState(() {
      _isUploading = true;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isUploading = false;
        _isFileAttached = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Buat Tiket Baru'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Formulir Keluhan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Isi detail masalah Anda dengan lengkap.',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Judul Masalah',
                    filled: true,
                    fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.title_rounded),
                  ),
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    filled: true,
                    fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.category_rounded),
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Detail',
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Lampiran Bukti',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _isFileAttached
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?q=80&w=100&auto=format&fit=crop',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'IMG_20260422_WiFi_Error.jpg',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '1.2 MB',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurface.withOpacity(
                                        0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isFileAttached = false;
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    : InkWell(
                        onTap: _isUploading ? null : _simulateUpload,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              if (_isUploading)
                                const CircularProgressIndicator()
                              else ...[
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Klik untuk upload foto/file',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tiket berhasil dikirim!'),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'KIRIM TIKET',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
