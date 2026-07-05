import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../common/widgets/custom_app_bar.dart';

class AdminUserListScreen extends StatefulWidget {
  const AdminUserListScreen({super.key});

  @override
  State<AdminUserListScreen> createState() => _AdminUserListScreenState();
}

class _AdminUserListScreenState extends State<AdminUserListScreen> {
  final supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Sesuai konvensi: Gunakan Future untuk data profil statis
  void _fetchUsers() {
    setState(() {
      _usersFuture = supabase
          .from('profiles')
          .select()
          .order('name', ascending: true);
    });
  }

  // Fungsi untuk update role ke database
  Future<void> _updateRole(String userId, String newRole) async {
    try {
      await supabase
          .from('profiles')
          .update({'role': newRole})
          .eq('user_id', userId);
          
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Role berhasil diubah menjadi ${newRole.toUpperCase()}!')),
        );
      }
      _fetchUsers(); // Refresh daftar setelah berhasil update
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah role: $e')),
        );
      }
    }
  }

  // UI Pop-up untuk memilih role baru
  void _showRoleDialog(Map<String, dynamic> user) {
    String currentRole = user['role'] ?? 'mahasiswa';
    String userId = user['user_id'];
    
    // Sesuaikan 'nama' atau 'name' dengan kolom di databasemu
    String userName = user['nama'] ?? user['name'] ?? 'Tanpa Nama'; 
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Ubah Role', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pengguna: $userName', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...['mahasiswa', 'staff_ahli', 'admin'].map((role) {
                return RadioListTile<String>(
                  title: Text(role.toUpperCase()),
                  value: role,
                  groupValue: currentRole,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    Navigator.pop(context); // Tutup dialog
                    if (value != null && value != currentRole) {
                      _updateRole(userId, value); // Eksekusi update
                    }
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Kelola Pengguna'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final users = snapshot.data ?? [];
          
          if (users.isEmpty) {
            return const Center(child: Text('Tidak ada pengguna ditemukan.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final role = user['role'] ?? 'mahasiswa';
              final name = user['nama'] ?? user['name'] ?? 'Tanpa Nama';
              final email = user['email'] ?? 'Tanpa Email';

              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                color: colorScheme.surfaceVariant.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primary.withOpacity(0.2),
                    child: Icon(
                      role == 'admin' ? Icons.admin_panel_settings_rounded :
                      role == 'staff_ahli' ? Icons.engineering_rounded : Icons.person_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(email, style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          role.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit_rounded, color: colorScheme.onSurface.withOpacity(0.5)),
                    onPressed: () => _showRoleDialog(user),
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