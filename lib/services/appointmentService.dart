import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  Book an appointment
  Future<void> bookAppointment({
    required String petId,
    required String vetId,
    required DateTime dateTime,
    required String reason,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in");

    final docRef = _firestore.collection("appointments").doc();

    await docRef.set({
      "appointmentId": docRef.id,
      "petId": petId,
      "userId": user.uid,
      "vetId": vetId,
      "dateTime": Timestamp.fromDate(dateTime),
      "reason": reason,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  //  Get appointments for logged-in user (pet owner)
  Future<List<Map<String, dynamic>>> getUserAppointments() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in");

    final snapshot = await _firestore
        .collection("appointments")
        .where("userId", isEqualTo: user.uid)
        .orderBy("dateTime", descending: false)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  //  Vet: update appointment status
  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    await _firestore.collection("appointments").doc(appointmentId).update({
      "status": status,
    });
  }
}
