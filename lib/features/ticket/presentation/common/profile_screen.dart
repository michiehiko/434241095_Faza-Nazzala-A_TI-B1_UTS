import 'package:flutter/material.dart';
import '../../../auth/presentation/login_screen.dart';
import 'widgets/info_tile.dart';

class ProfileScreen extends StatelessWidget {
  final bool isAdmin;

  const ProfileScreen({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: colorScheme.primary.withOpacity(0.1),
                          child: Icon(
                            isAdmin
                                ? Icons.support_agent_rounded
                                : Icons.person_outline_rounded,
                            size: 50,
                            color: colorScheme.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            size: 16,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isAdmin ? 'Akito Yamada, S.T.' : 'Murata Fuma',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isAdmin ? 'IT Helpdesk Support' : 'Mahasiswa',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              Text(
                isAdmin ? 'Informasi Staff' : 'Informasi Profil',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    InfoTile(
                      icon: Icons.badge_outlined,
                      title: isAdmin ? 'NIP / ID Staff' : 'NIM',
                      subtitle: isAdmin ? '19850123xxxx' : '152026xxxx',
                    ),
                    Divider(
                      height: 1,
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                    InfoTile(
                      icon: isAdmin
                          ? Icons.domain_rounded
                          : Icons.school_outlined,
                      title: isAdmin ? 'Unit Kerja' : 'Program Studi',
                      subtitle: isAdmin
                          ? 'Direktorat Sistem Informasi (DSI)'
                          : 'Teknik Informatika',
                    ),
                    Divider(
                      height: 1,
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                    InfoTile(
                      icon: Icons.email_outlined,
                      title: isAdmin ? 'Email Instansi' : 'Email Kampus',
                      subtitle: isAdmin
                          ? 'helpdesk@unair.ac.id'
                          : 'muratafuma@student.campus.ac.id',
                    ),
                    Divider(
                      height: 1,
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                    InfoTile(
                      icon: Icons.phone_outlined,
                      title: 'Nomor WhatsApp',
                      subtitle: isAdmin
                          ? '+62 811-0000-9999'
                          : '+62 812-3456-7890',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Pengaturan Sistem',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.settings_outlined,
                        color: colorScheme.onSurface,
                      ),
                      title: Text(
                        'Pengaturan Akun',
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      onTap: () {},
                    ),
                    Divider(
                      height: 1,
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.help_outline_rounded,
                        color: colorScheme.onSurface,
                      ),
                      title: Text(
                        'Pusat Bantuan (FAQ)',
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      onTap: () {},
                    ),
                    Divider(
                      height: 1,
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.info_outline_rounded,
                        color: colorScheme.onSurface,
                      ),
                      title: Text(
                        'Tentang Aplikasi',
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      trailing: Text(
                        'v1.0.0',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                  ),
                  label: const Text(
                    'Keluar Aplikasi',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
