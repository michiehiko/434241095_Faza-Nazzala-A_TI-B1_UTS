import 'dart:convert';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'package:http/http.dart' as http; 

class TicketService {
  final supabase = Supabase.instance.client;

  final String _cloudName = 'dg23odyei'; 
  final String _uploadPreset = 'T78UGAS31';

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

  Future<bool> createTicket({
    required String title,
    required String category,
    required String description,
    Uint8List? imageBytes,
    String? fileName,
  }) async {
    try {
      final User? currentUser = supabase.auth.currentUser;
      if (currentUser == null) return false;

      // FIX 1: Cari profil pelapor menggunakan 'id'
      final profileData = await supabase
          .from('profiles')
          .select('name')
          .eq('id', currentUser.id) 
          .single();
          
      final String namaPelapor = profileData['name'] ?? 'Mahasiswa';

      String? imageUrl;
      if (imageBytes != null && fileName != null) {
        imageUrl = await _uploadImage(imageBytes, fileName);
      }

      Map<String, dynamic> ticketData = {
        'title': title,
        'category': category,
        'description': description,
        'status': 'open',
        'user_id': currentUser.id, 
        'image_url': imageUrl, 
        'nama_pelapor': namaPelapor, 
      };

      final insertedTicket = await supabase
          .from('tickets')
          .insert(ticketData)
          .select('id')
          .single();
          
      final newTicketId = insertedTicket['id'];

      // FIX 2: Cari Admin menggunakan 'id' (Bukan user_id)
      final adminList = await supabase
          .from('profiles')
          .select('id') 
          .eq('role', 'admin'); 

      if (adminList.isNotEmpty) {
        final List<Map<String, dynamic>> notificationsToInsert = adminList.map((admin) {
          return {
            'user_id': admin['id'], // FIX 3: Masukkan ID admin yang benar
            'ticket_id': newTicketId,
            'message': 'Tiket Baru (#$newTicketId) masuk dari $namaPelapor: $title',
          };
        }).toList();

        await supabase.from('notifications').insert(notificationsToInsert);
      }
      
      return true;
    } catch (e) {
      print("Error Create Ticket: " + e.toString());
      return false;
    }
  }
}