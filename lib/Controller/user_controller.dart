import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extend_my_pay_admin_panel/Model/user_model.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all users
  Future<List<UsersModel>> fetchAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('profile').get();
      return querySnapshot.docs
          .map((doc) => UsersModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  /// Update user's status
  Future<void> updateUserStatus(String uid, String newStatus) async {
    try {
      await _firestore.collection('profile').doc(uid).update({
        'status': newStatus,
      });
    } catch (e) {
      print("Error updating user status: $e");
    }
  }

  /// Send notification to the user based on type (approved or rejected)
  Future<void> sendNotification({required String uid, required String type}) async {
    try {
      final templateDoc = await _firestore
          .collection('notification_templates')
          .doc('templates')
          .get();

      if (!templateDoc.exists) {
        print("Notification templates not found.");
        return;
      }

      final data = templateDoc.data() as Map<String, dynamic>;

      String title = '';
      String description = '';

      if (type == 'approved') {
        title = data['profileApprovedTitle'] ?? 'Profile Approved';
        description = data['profileApprovedDesc'] ?? 'Your profile has been approved.';
      } else if (type == 'rejected') {
        title = data['profileRejectedTitle'] ?? 'Profile Rejected';
        description = data['profileRejectedDesc'] ?? 'Your profile has been rejected.';
      } else {
        return; // Do not send notifications for other types
      }

      await _firestore.collection('notifications').add({
        'uid': uid,
        'title': title,
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}
