import 'package:flutter/material.dart';
import '../Widgets/admin_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      screenTitle: "Dashboard",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Welcome to your admin dashboard.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          // Add dashboard widgets/statistics here in future
        ],
      ),
    );
  }
}
