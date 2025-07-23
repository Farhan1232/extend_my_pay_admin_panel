import 'package:flutter/material.dart';
import 'package:extend_my_pay_admin_panel/Screens/admin_sidebar.dart';
import 'admin_header.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  final String screenTitle;

  const AdminLayout({
    super.key,
    required this.child,
    required this.screenTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AdminHeader(title: screenTitle),
          Expanded(
            child: Row(
              children: [
                const AdminSidebar(),
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
