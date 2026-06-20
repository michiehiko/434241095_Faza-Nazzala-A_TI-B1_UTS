import 'dart:convert';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'package:http/http.dart' as http; 

class TicketService {
  // Panggil mesin Supabase
  final supabase = Supabase.instance.client;

  final String _cloudName = 'dg23odyei'; 
  final String _uploadPreset = 'T78UGAS31';

  // Mesin upload Cloudinary Versi Kebal Slash (Multipart) - TETAP SAMA
  Future<String?> _uploadImage(Uint8List imageBytes, String fileName) async {
    try {
      var uri = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');
      
      var request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = _uploadPreset;

      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'bukti_${DateTime.now().millisecondsSinceEpoch}.jpg', 
      );

      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse['secure_url']; 
      } else {
        print("Gagal upload ke Cloudinary: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error Upload Image: " + e.toString());
      return null;
    }
  }

  // Fungsi membuat tiket versi Supabase
  Future<bool> createTicket({
    required String title,
    required String category,
    required String description,
    Uint8List? imageBytes,
    String? fileName,
  }) async {
    try {
      // Ambil data user yang sedang login dari Supabase Auth
      final User? currentUser = supabase.auth.currentUser;
      if (currentUser == null) return false;

      String? imageUrl;
      
      // Proses upload gambar kalau ada
      if (imageBytes != null && fileName != null) {
        imageUrl = await _uploadImage(imageBytes, fileName);
      }

      // Susun data sesuai dengan NAMA KOLOM di tabel Supabase (snake_case)
      Map<String, dynamic> ticketData = {
        'title': title,
        'category': category,
        'description': description,
        'status': 'Open',
        'user_id': currentUser.id, // Sesuaikan dengan UUID user
        'image_url': imageUrl, 
        // createdAt nggak perlu dikirim karena di SQL kita udah set DEFAULT NOW()
      };

      // Tembak data ke tabel 'tickets'
      await supabase.from('tickets').insert(ticketData);
      
      return true;
    } catch (e) {
      print("Error Create Ticket: " + e.toString());
      return false;
    }
  }
}