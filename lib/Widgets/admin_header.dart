import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Color(0xFFFF941A),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.r,
            offset: Offset(0, 3),
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 🧾 Title
          Text(
            title,
            style: TextStyle(
              fontSize: 22.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
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
                      // IconButton(
                      //   icon: Icon(Icons.notifications_none, color: Colors.white, size: 26.sp),
                      //   tooltip: 'Notifications',
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, '/admin_notifications');
                      //   },
                      // ),
                      if (count > 0)
                        Positioned(
                          right: 4.w,
                          top: -4.h,
                          child: Container(
                            padding: EdgeInsets.all(5.r),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4.r,
                                ),
                              ],
                            ),
                            child: Text(
                              count.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              SizedBox(width: 8.w),
              IconButton(
                icon: Icon(Icons.logout, color: Colors.white, size: 24.sp),
                tooltip: 'Logout',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.r,
                    )
                  ],
                ),
                child: Icon(Icons.admin_panel_settings, color: Color(0xFFFF941A), size: 24.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
