import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/notification_template.dart';

class NotificationTemplateController {
  final _firestore = FirebaseFirestore.instance;

  Future<NotificationTemplate?> fetchTemplate() async {
    try {
      final doc = await _firestore.collection('notification_templates').doc('templates').get();
      if (doc.exists) {
        return NotificationTemplate.fromMap(doc.data()!);
      }
    } catch (_) {}
    return null;
  }

  Future<void> saveTemplate(NotificationTemplate template) async {
    await _firestore
        .collection('notification_templates')
        .doc('templates')
        .set(template.toMap());
  }
}
