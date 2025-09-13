import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

/// ----------------------
/// Pet Model
/// ----------------------
class Pet {
  final String petId;
  final String userId;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String photoUrl;
  final DateTime? createdAt;
  final List<dynamic> medicalRecords;

  Pet({
    required this.petId,
    required this.userId,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.photoUrl,
    required this.createdAt,
    required this.medicalRecords,
  });

  /// Factory: Convert Firestore doc → Pet object
  factory Pet.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Pet(
      petId: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      species: data['species'] ?? '',
      breed: data['breed'] ?? '',
      age: data['age'] ?? 0,
      photoUrl: data['photoUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      medicalRecords: data['medicalRecords'] ?? [],
    );
  }

  /// Convert Pet object → Map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      "petId": petId,
      "userId": userId,
      "name": name,
      "species": species,
      "breed": breed,
      "age": age,
      "photoUrl": photoUrl,
      "createdAt": createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      "medicalRecords": medicalRecords,
    };
  }
}

/// ----------------------
/// Pet Service
/// ----------------------
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
      return data['secure_url']; // Cloudinary image URL
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

    final pet = Pet(
      petId: docRef.id,
      userId: user.uid,
      name: name,
      species: species,
      breed: breed,
      age: int.tryParse(age) ?? 0,
      photoUrl: photoUrl ?? '',
      createdAt: DateTime.now(),
      medicalRecords: [],
    );

    await docRef.set(pet.toMap());
  }

  /// Get Pet Profile
  Future<Pet?> getPetProfile(String petId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('pets').doc(petId).get();
      if (doc.exists) return Pet.fromFirestore(doc);
      return null;
    } catch (e) {
      print('GetPetProfileError: $e');
      return null;
    }
  }
}
