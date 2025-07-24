import 'package:flutter/material.dart';

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
      width: 220,
      color: Colors.teal.shade700,
      child: SafeArea( // ✅ Avoid top/bottom overflow on devices
        child: SingleChildScrollView( // ✅ Fixes vertical overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DrawerHeader(
                child: Text(
                  'Admin Panel',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ...items.map((item) {
                return ListTile(
                  leading: Icon(item['icon'] as IconData, color: Colors.white),
                  title: Text(item['label'] as String, style: const TextStyle(color: Colors.white)),
                  onTap: () => Navigator.pushNamed(context, item['route'] as String),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
