import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/terms_policy_model.dart';

class TermsPolicyController {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('terms_and_policy');

  final CollectionReference _notificationCollection =
      FirebaseFirestore.instance.collection('notifications');

  Future<TermsPolicyModel?> fetchPolicy() async {
    final snapshot = await _collection.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return TermsPolicyModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> savePolicy(String title, String description, [String? id]) async {
    if (id != null && id.isNotEmpty) {
      await _collection.doc(id).update({'title': title, 'description': description});
    } else {
      await _collection.add({'title': title, 'description': description});
    }

    // 👇 Send notification after updating
    await _notificationCollection.add({
      'title': 'Terms & Policy Updated',
      'message':
          'Owner has updated the terms and policy of our application. Please read them carefully.',
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'info', // you can use this later for UI filtering
      'readBy': [],   // you can mark which users read it
    });
  }
}
