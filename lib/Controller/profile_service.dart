import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extend_my_pay_admin_panel/Model/user_profile.dart';

class ProfileService {
  final CollectionReference _profileCollection =
      FirebaseFirestore.instance.collection('profiles');

  Future<List<UserProfile>> fetchAllProfiles() async {
    try {
      final snapshot = await _profileCollection.get();
      return snapshot.docs
          .map((doc) => UserProfile.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch profiles: $e');
    }
  }
}
