import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isRead;

  AdminNotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isRead,
  });

  factory AdminNotificationModel.fromFirestore(String id, Map<String, dynamic> data) {
    return AdminNotificationModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }
}
