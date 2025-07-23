import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extend_my_pay_admin_panel/Model/user_profile.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> updateUserStatus(String uid, String status) async {
  await _firestore.collection('profile').doc(uid).update({
    'status': status,
  });
}


  Stream<List<UserProfile>> getUserProfiles() {
    return _firestore.collection('profile').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }


Future<void> sendNotificationToUser({
  required String uid,
  required String title,
  required String description,
}) async {
  await _firestore.collection('notifications').doc(uid).set({
    'uid': uid,
    'title': title,
    'description': description,
    'timestamp': FieldValue.serverTimestamp(),
    'status': 'unread',
  });
}

}
