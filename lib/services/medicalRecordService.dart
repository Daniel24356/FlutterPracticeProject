import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicalRecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //  Add a medical record (Vet only)
  Future<void> addMedicalRecord({
    required String petId,
    required String diagnosis,
    required String treatment,
    required List<String> medications,
    required String notes,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in");

    final docRef = _firestore.collection("medicalRecords").doc();

    await docRef.set({
      "recordId": docRef.id,
      "petId": petId,
      "vetId": user.uid,
      "diagnosis": diagnosis,
      "treatment": treatment,
      "medications": medications,
      "date": FieldValue.serverTimestamp(),
      "notes": notes,
    });
  }

  //  Get medical records for a pet
  Future<List<Map<String, dynamic>>> getPetRecords(String petId) async {
    final snapshot = await _firestore
        .collection("medicalRecords")
        .where("petId", isEqualTo: petId)
        .orderBy("date", descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
