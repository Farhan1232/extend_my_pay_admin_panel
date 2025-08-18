import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.dashboard, 'label': 'Dashboard', 'route': '/dashboard'},
      {'icon': Icons.people, 'label': 'Users', 'route': '/profile_sample'},
      {'icon': Icons.receipt_long, 'label': 'Bills', 'route': '/user-bills-selector'},
      {'icon': Icons.notifications, 'label': 'Notifications', 'route': '/notifications'},
      {'icon': Icons.description, 'label': 'Terms & Policy', 'route': '/terms-policy'},
      {'icon': Icons.help, 'label': 'Support & Help', 'route': '/support'},
      {'icon': Icons.admin_panel_settings, 'label': 'Admin Access', 'route': '/admin-access'},
      {'icon': Icons.notification_add_outlined, 'label': 'Const Notification', 'route': '/notification-templates'},
      {'icon': Icons.payment, 'label': 'Payment Charges', 'route': '/payment-charge'},
      {'icon': Icons.post_add, 'label': 'Poster', 'route': '/poster'},
    ];

    return Container(
      width: 250.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF941A), Colors.teal.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 0),
            blurRadius: 10,
          )
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.admin_panel_settings, color: Colors.white, size: 28.sp),
                  SizedBox(width: 10.w),
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.3), height: 30.h),
              ...items.map((item) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ListTile(
                    leading: Icon(item['icon'] as IconData, color: const Color.fromARGB(255, 225, 247, 35), size: 22.sp),
                    title: Text(
                      item['label'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () => Navigator.pushNamed(context, item['route'] as String),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    hoverColor: Colors.white.withOpacity(0.15),
                    tileColor: Colors.transparent,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}