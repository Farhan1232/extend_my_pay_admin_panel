import 'package:cloud_firestore/cloud_firestore.dart';

class SupportTicket {
  final String subject;
  final String description;
  final DateTime timestamp;
  final String uid;
  final String docId;

  SupportTicket({
    required this.subject,
    required this.description,
    required this.timestamp,
    required this.uid,
    required this.docId,
  });

  factory SupportTicket.fromFirestore(Map<String, dynamic> data, String docId) {
    return SupportTicket(
      subject: data['subject'] ?? '',
      description: data['description'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      uid: data['uid'] ?? '',
      docId: docId,
    );
  }
}
