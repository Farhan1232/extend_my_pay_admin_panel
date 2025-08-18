import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

        return Container(
          margin: EdgeInsets.only(bottom: 24.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF941A),
                ),
              ),
              SizedBox(height: 12.h),
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFFF941A).withOpacity(0.1),
                      child: Icon(icon, color: Color(0xFFFF941A)),
                    ),
                    title: Text(
                      data['message'] ?? 'No message',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      data['timestamp']?.toDate().toString() ?? '',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                    onTap: () => markAsRead(doc.reference),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      screenTitle: "Admin Notifications",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
