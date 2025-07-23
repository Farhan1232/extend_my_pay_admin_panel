import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/notification_model.dart';

class NotificationController {
  final _firestore = FirebaseFirestore.instance;

  Future<void> sendNotification(NotificationModel notification) async {
    await _firestore.collection('notifications').add(notification.toMap());
  }
}
