import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PetService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cloudinary config (replace with your own values)
  final String cloudName = "dkpatcwoz";
  final String uploadPreset = "pet_photos";

  /// Upload file to Cloudinary
  Future<String?> _uploadImageToCloudinary(File image) async {
    final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath("file", image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = jsonDecode(resStr);
      return data['secure_url']; // ✅ Cloudinary image URL
    } else {
      throw Exception("Cloudinary upload failed: ${response.statusCode}");
    }
  }

  /// Add pet to Firestore
  Future<void> addPet({
    required String name,
    required String species,
    required String breed,
    required String age,
    File? photo,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in");

    String? photoUrl;
    if (photo != null) {
      photoUrl = await _uploadImageToCloudinary(photo);
    }

    final docRef = _firestore.collection("pets").doc();

    await docRef.set({
      "petId": docRef.id,
      "userId": user.uid,
      "name": name,
      "species": species,
      "breed": breed,
      "age": int.tryParse(age) ?? 0,
      "createdAt": FieldValue.serverTimestamp(),
      "medicalRecords": [],
      "photoUrl": photoUrl ?? "",
    });
  }
}
