import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class AdminHeader extends StatelessWidget {
  final String title;

  const AdminHeader({super.key, required this.title});

  /// Fetch unread count from multiple collections
  Stream<int> getTotalUnreadCount() {
    final billsStream = FirebaseFirestore.instance
        .collection('bills')
        .where('status', isEqualTo: 'unread')
        .snapshots();

    final profileStream = FirebaseFirestore.instance
        .collection('profile')
        .where('status', isEqualTo: 'pending')
        .snapshots();

    final supportStream = FirebaseFirestore.instance
        .collection('support_and_help')
        .where('status', isEqualTo: 'unread')
        .snapshots();

    return StreamZip([
      billsStream,
      profileStream,
      supportStream,
    ]).map((snapshots) {
      return snapshots.fold(0, (sum, snapshot) => sum + snapshot.docs.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.teal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 🧾 Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          /// 🔔 Notification + Logout + Admin Icon
          Row(
            children: [
              StreamBuilder<int>(
                stream: getTotalUnreadCount(),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.white),
                        tooltip: 'Notifications',
                        onPressed: () {
                          Navigator.pushNamed(context, '/admin_notifications');
                        },
                      ),
                      if (count > 0)
                        Positioned(
                          right: 4,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              count.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                tooltip: 'Logout',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.admin_panel_settings, color: Colors.teal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
