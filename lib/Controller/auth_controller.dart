import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/admin_user_model.dart';
import '../Provider/auth_provider.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔐 Login admin and check against admin_Access collection
  Future<bool> loginAdmin(String email, String password, AppAuthProvider provider) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // ✅ Check if user is in admin_Access collection
      final doc = await _firestore.collection("admin_Access").doc(uid).get();

      if (doc.exists) {
        final userModel = UserModel(uid: uid, email: email);
        provider.setUser(userModel);
        return true;
      } else {
        await _auth.signOut(); // Not authorized
        return false;
      }
    } catch (e) {
      print('🔴 Login error: $e');
      return false;
    }
  }

  /// 📧 Send password reset email
  Future<void> sendResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('🔴 Error sending reset link: $e');
      rethrow;
    }
  }

  /// 🚪 Logout current user
  Future<void> logout(AppAuthProvider provider) async {
    await _auth.signOut();
    provider.logout();
  }

  /// ➕ Create a new admin user
  Future<bool> createNewAdmin(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      await _firestore.collection("admin_Access").doc(uid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('🔴 Error creating admin: $e');
      return false;
    }
  }

  /// ❌ Delete an admin from Firestore (not from Firebase Auth)
  Future<bool> deleteAdmin(String uid) async {
    try {
      await _firestore.collection("admin_Access").doc(uid).delete();
      return true;
    } catch (e) {
      print('🔴 Error deleting admin: $e');
      return false;
    }
  }
}
