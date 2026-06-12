import 'dart:typed_data'; // <-- Penting buat Web
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../common/widgets/custom_app_bar.dart';
import '../../services/ticket_service.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String _selectedCategory = 'Hardware (PC/Laptop)';
  final List<String> _categories = [
    'Hardware (PC/Laptop)',
    'Software (Aplikasi/OS)',
    'Jaringan (WiFi/LAN)',
    'Lainnya',
  ];

  bool _isSubmitting = false;

  // Gunakan Uint8List untuk Web, jangan File dari dart:io
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  
  final ImagePicker _picker = ImagePicker();
  final TicketService _ticketService = TicketService();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, 
      );

      if (pickedFile != null) {
        // Ekstrak datanya jadi kepingan Bytes supaya aman dibaca Chrome
        final bytes = await pickedFile.readAsBytes();
        
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageName = pickedFile.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka file picker.')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageName = null;
    });
  }

  void _submitTicket() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan Deskripsi harus diisi!')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    bool success = await _ticketService.createTicket(
      title: _titleController.text.trim(),
      category: _selectedCategory,
      description: _descController.text.trim(),
      imageBytes: _selectedImageBytes, // Kirim bytes
      fileName: _selectedImageName,    // Kirim nama file
    );

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tiket beserta bukti berhasil dikirim!')),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim tiket. Coba lagi.')),
        );
      }
    }
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
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _titleController,
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
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() { _selectedCategory = newValue!; });
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _descController,
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
                  'Lampiran Bukti (Opsional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _selectedImageBytes != null
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              // Karena Web, kita pakai Image.memory alih-alih Image.file
                              child: Image.memory(
                                _selectedImageBytes!,
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
                                    _selectedImageName ?? 'gambar_terpilih.jpg',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Siap diupload',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, color: Colors.red),
                              onPressed: _removeImage,
                            ),
                          ],
                        ),
                      )
                    : InkWell(
                        onTap: _pickImage,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, color: colorScheme.primary, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                'Pilih foto/file',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitTicket,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSubmitting
                        ? CircularProgressIndicator(color: colorScheme.onPrimary)
                        : const Text(
                            'KIRIM TIKET',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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