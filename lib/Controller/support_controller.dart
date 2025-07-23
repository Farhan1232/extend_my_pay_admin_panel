import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/support_ticket_model.dart';

class SupportController {
  final _collection = FirebaseFirestore.instance.collection('support_and_help');

  Future<List<SupportTicket>> fetchTickets() async {
    final query = await _collection.orderBy('timestamp', descending: true).get();
    return query.docs.map((doc) => SupportTicket.fromFirestore(doc.data(), doc.id)).toList();
  }
}
