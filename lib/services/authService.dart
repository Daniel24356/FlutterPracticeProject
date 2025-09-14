import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloudinaryService.dart'; // <-- import your service

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String profilePicUrl;
  final DateTime? createdAt;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.profilePicUrl,
    this.createdAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? '',
      profilePicUrl: data['profilePicUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "profilePicUrl": profilePicUrl,
      "createdAt": createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinary = CloudinaryService();

  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save extra info in Firestore
      final userProfile = UserProfile(
        uid: result.user!.uid,
        name: name,
        email: email,
        phone: phone,
        role: role,
        profilePicUrl: "", // default empty
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(result.user!.uid)
          .set(userProfile.toMap());

      return result.user;
    } catch (e) {
      print('Sign Up Error: $e');
      return null;
    }
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Password Reset Error: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(uid).get();
      if (doc.exists) return UserProfile.fromFirestore(doc);
      return null;
    } catch (e) {
      print('GetUserProfile Error: $e');
      return null;
    }
  }

  Future<UserProfile?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await getUserProfile(user.uid);
  }

  Future<String?> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['role'] as String?;
      }
      return null;
    } catch (e) {
      print('GetUserRole Error: $e');
      return null;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in");

    await _firestore.collection("users").doc(user.uid).update(data);
  }

  Future<void> updateProfilePicture(File image) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in");

    final photoUrl = await _cloudinary.uploadImage(image);

    if (photoUrl != null) {
      await _firestore.collection("users").doc(user.uid).update({
        "profilePicUrl": photoUrl,
      });
    }
  }
}
