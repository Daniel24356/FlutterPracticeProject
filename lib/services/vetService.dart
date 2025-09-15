import 'package:cloud_firestore/cloud_firestore.dart';

class VetService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Create a new record under a specific visit
  Future<void> addRecord({
    required String petId,
    required String visitId,
    required String title,
    required List<String> notes,
  }) async {
    try {
      await _db
          .collection("pets")
          .doc(petId)
          .collection("visits")
          .doc(visitId)
          .collection("records")
          .add({
        "title": title,
        "notes": notes,
        "createdAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to add record: $e");
    }
  }

  /// Add a prescription under a specific visit/record
  Future<void> addPrescription({
    required String petId,
    required String visitId,
    required String recordId,
    required String name,
    required String notes,
  }) async {
    try {
      await _db
          .collection("pets")
          .doc(petId)
          .collection("visits")
          .doc(visitId)
          .collection("records")
          .doc(recordId)
          .collection("prescriptions")
          .add({
        "name": name,
        "notes": notes,
        "date": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to add prescription: $e");
    }
  }

  /// Upload a file reference (after uploading to Firebase Storage/Cloudinary)
  Future<void> addUploadedFile({
    required String petId,
    required String fileUrl,
  }) async {
    try {
      await _db.collection("pets").doc(petId).collection("files").add({
        "url": fileUrl,
        "uploadedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to save file: $e");
    }
  }

  /// Fetch all visits for a pet
  Stream<QuerySnapshot<Map<String, dynamic>>> getVisits(String petId) {
    return _db
        .collection("pets")
        .doc(petId)
        .collection("visits")
        .orderBy("date", descending: true)
        .snapshots();
  }
}
