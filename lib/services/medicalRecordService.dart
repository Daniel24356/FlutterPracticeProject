import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicalRecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Add a medical record (Vet only) under sub-collection
  Future<void> addMedicalRecord({
    required String userId, // Pet owner's UID
    required String petId,
    required String diagnosis,
    required String treatment,
    required List<String> medications,
    required String notes,
    String? category, // Optional: e.g., "Vaccinations", "Surgeries"
  }) async {
    final vet = _auth.currentUser;
    if (vet == null) throw Exception("Not logged in");

    final docRef = _firestore
        .collection("users")
        .doc(userId)
        .collection("pets")
        .doc(petId)
        .collection("healthRecords")
        .doc();

    await docRef.set({
      "recordId": docRef.id,
      "vetId": vet.uid,
      "diagnosis": diagnosis,
      "treatment": treatment,
      "medications": medications,
      "category": category ?? "Medications",
      "date": FieldValue.serverTimestamp(),
      "notes": notes,
    });
  }

  /// Get medical records for a pet from sub-collection
  Future<List<Map<String, dynamic>>> getPetRecords({
    required String userId,
    required String petId,
  }) async {
    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("pets")
        .doc(petId)
        .collection("healthRecords")
        .orderBy("date", descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
