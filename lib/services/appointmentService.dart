import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Book an appointment under sub-collection
  Future<void> bookAppointment({
    required String userId, // Pet owner's UID
    required String petId,
    required String vetId,
    required DateTime dateTime,
    required String reason,
  }) async {
    final booker = _auth.currentUser;
    if (booker == null) throw Exception("Not logged in");

    final docRef = _firestore
        .collection("users")
        .doc(userId)
        .collection("pets")
        .doc(petId)
        .collection("appointments")
        .doc();

    await docRef.set({
      "appointmentId": docRef.id,
      "userId": booker.uid,
      "vetId": vetId,
      "dateTime": Timestamp.fromDate(dateTime),
      "reason": reason,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// Get appointments for logged-in user (pet owner)
  Future<List<Map<String, dynamic>>> getUserAppointments({
    required String userId,
    required String petId,
  }) async {
    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("pets")
        .doc(petId)
        .collection("appointments")
        .orderBy("dateTime", descending: false)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Vet: update appointment status
  Future<void> updateAppointmentStatus({
    required String userId,
    required String petId,
    required String appointmentId,
    required String status,
  }) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("pets")
        .doc(petId)
        .collection("appointments")
        .doc(appointmentId)
        .update({"status": status});
  }
}
