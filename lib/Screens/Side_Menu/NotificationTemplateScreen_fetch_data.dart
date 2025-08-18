import 'package:extend_my_pay_admin_panel/Provider/notification_template_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationTemplate_fetch_data_Screen extends StatelessWidget {
  const NotificationTemplate_fetch_data_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Templates")),
      body: FutureBuilder(
        future: Provider.of<NotificationTemplateProvider>(context, listen: false).loadTemplate(),
        builder: (context, snapshot) {
          final template = Provider.of<NotificationTemplateProvider>(context).template;

          if (template == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("✅ Bill Approved: ${template.billApprovedTitle}"),
              Text("📄 ${template.billApprovedDesc}"),
              const SizedBox(height: 16),
              Text("❌ Bill Rejected: ${template.billRejectedTitle}"),
              Text("📄 ${template.billRejectedDesc}"),
              const SizedBox(height: 16),
              Text("✅ Profile Approved: ${template.profileApprovedTitle}"),
              Text("📄 ${template.profileApprovedDesc}"),
              const SizedBox(height: 16),
              Text("❌ Profile Rejected: ${template.profileRejectedTitle}"),
              Text("📄 ${template.profileRejectedDesc}"),
            ],
          );
        },
      ),
    );
  }
}
