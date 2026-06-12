import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http; 

class TicketService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- TARUH DATA CLOUDINARY KAMU DI SINI ---
  final String _cloudName = 'dg23odyei'; 
  final String _uploadPreset = 'T78UGAS31';

  // Mesin upload Cloudinary Versi Kebal Slash (Multipart)
  Future<String?> _uploadImage(Uint8List imageBytes, String fileName) async {
    try {
      var uri = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');
      
      // Kita pakai mode pengiriman form/file murni (Multipart)
      var request = http.MultipartRequest('POST', uri);

      // Masukin kunci pintu Cloudinary-nya
      request.fields['upload_preset'] = _uploadPreset;

      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        // Tambahin waktu saat ini biar namanya selalu unik tiap detik!
        filename: 'bukti_${DateTime.now().millisecondsSinceEpoch}.jpg', 
      );

      request.files.add(multipartFile);

      // Mulai proses pengiriman
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Cek apakah server membalas dengan status 200 (Sukses)
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

  // Fungsi membuat tiket tetap sama persis!
  Future<bool> createTicket({
    required String title,
    required String category,
    required String description,
    Uint8List? imageBytes,
    String? fileName,
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      String? imageUrl;
      
      if (imageBytes != null && fileName != null) {
        imageUrl = await _uploadImage(imageBytes, fileName);
      }

      Map<String, dynamic> ticketData = {
        'title': title,
        'category': category,
        'description': description,
        'status': 'Open',
        'userId': currentUser.uid,
        'userEmail': currentUser.email,
        'imageUrl': imageUrl, 
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _db.collection('tickets').add(ticketData);
      return true;
    } catch (e) {
      print("Error Create Ticket: " + e.toString());
      return false;
    }
  }
}