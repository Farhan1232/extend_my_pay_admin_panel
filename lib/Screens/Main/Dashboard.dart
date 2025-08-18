
import 'package:flutter/material.dart';

import 'dashboard_page.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
         // AdminSidebar(),
          Expanded(
            child: DashboardScreen(),
          ),
        ],
      ),
    );
  }
}
