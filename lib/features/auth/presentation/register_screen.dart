import 'package:flutter/material.dart';
import '../../ticket/presentation/common/widgets/custom_app_bar.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: ''),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buat Akun Baru',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Daftar untuk mulai menggunakan layanan IT Helpdesk.',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
              ),
              const SizedBox(height: 40),

              TextField(
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                decoration: InputDecoration(
                  labelText: 'NIM / ID Mahasiswa',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Kampus',
                  hintText: 'contoh@student.unair.ac.id',
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: const Icon(Icons.visibility_off_outlined),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pendaftaran berhasil! Silakan Login.'),
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
                    'DAFTAR SEKARANG',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Sudah punya akun? Masuk di sini',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
