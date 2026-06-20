import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Panggil variabel global supabase yang udah kita bikin di main.dart
  final supabase = Supabase.instance.client;

  // 1. Fungsi Registrasi (Buat Akun Baru)
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String nomorInduk, 
  }) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final User? user = res.user;

      if (user != null) {
        await supabase.from('profiles').insert({
          'id': user.id, 
          'email': email,
          'name': name,
          'nomor_induk': nomorInduk, // <-- Masukin ke kolom baru
          'role': 'mahasiswa', 
        });
        return true;
      }
      return false;
    } catch (e) {
      print("Error Register: ${e.toString()}");
      return false;
    }
  }

  // 2. Fungsi Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      return res.user != null;
    } catch (e) {
      print("Error Login: ${e.toString()}");
      return false;
    }
  }

  // 3. Fungsi Logout
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  // 4. Cek siapa yang lagi login sekarang (berguna buat nampilin profil)
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }
}