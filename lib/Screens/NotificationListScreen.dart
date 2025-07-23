import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:flutter/material.dart';

class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  Future<void> markAsRead(DocumentReference docRef) async {
    await docRef.update({'status': 'read'});
  }

  Widget buildList(String title, Query query, IconData icon) {
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                leading: Icon(icon, color: Colors.teal),
                title: Text(data['message'] ?? 'No message'),
                subtitle: Text(data['timestamp']?.toDate().toString() ?? ''),
                onTap: () => markAsRead(doc.reference),
              );
            }),
            const Divider(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      screenTitle: "Admin Notifications",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildList(
              'New Bill Requests',
              FirebaseFirestore.instance.collection('bills').where('status', isEqualTo: 'unread'),
              Icons.receipt,
            ),
            buildList(
              'Profile Approvals',
              FirebaseFirestore.instance.collection('profile').where('status', isEqualTo: 'pending'),
              Icons.person,
            ),
            buildList(
              'Support Messages',
              FirebaseFirestore.instance.collection('support_and_help').where('status', isEqualTo: 'unread'),
              Icons.support_agent,
            ),
          ],
        ),
      ),
    );
  }
}
