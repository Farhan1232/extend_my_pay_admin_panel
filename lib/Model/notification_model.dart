import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String title;
  final String description;
  final String? uid; // nullable; if null, it’s for all users
  final DateTime timestamp;

  NotificationModel({
    required this.title,
    required this.description,
    this.uid,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'uid': uid,
      'timestamp': timestamp,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      uid: map['uid'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
