import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/admin_user_model.dart';
import '../Provider/auth_provider.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> loginAdmin(String email, String password, AppAuthProvider provider) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      final doc = await _firestore.collection("admin_Access").doc(uid).get();

      if (doc.exists) {
        final userModel = UserModel(uid: uid, email: email);
        provider.setUser(userModel);
        return true;
      } else {
        await _auth.signOut();
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  Future<void> sendResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> logout(AppAuthProvider provider) async {
    await _auth.signOut();
    provider.logout();
  }

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
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteAdmin(String uid) async {
    try {
      await _firestore.collection("admin_Access").doc(uid).delete();
      return true;
    } catch (_) {
      return false;
    }
  }




  
}
