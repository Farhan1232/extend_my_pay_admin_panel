import 'package:extend_my_pay_admin_panel/Model/notification_template.dart';
import 'package:extend_my_pay_admin_panel/Provider/notification_template_provider.dart';
import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class NotificationTemplateScreen extends StatelessWidget {
  NotificationTemplateScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'billApprovedTitle': TextEditingController(),
    'billApprovedDesc': TextEditingController(),
    'billRejectedTitle': TextEditingController(),
    'billRejectedDesc': TextEditingController(),
    'profileApprovedTitle': TextEditingController(),
    'profileApprovedDesc': TextEditingController(),
    'profileRejectedTitle': TextEditingController(),
    'profileRejectedDesc': TextEditingController(),
  };

  Future<void> _initializeControllers(BuildContext context) async {
    final provider = Provider.of<NotificationTemplateProvider>(context, listen: false);
    await provider.loadTemplate();

    final template = provider.template;
    if (template != null) {
      final map = template.toMap();
      _controllers.forEach((key, controller) {
        controller.text = map[key] ?? '';
      });
    }
  }

  NotificationTemplate _buildTemplateFromControllers() {
    return NotificationTemplate(
      billApprovedTitle: _controllers['billApprovedTitle']!.text.trim(),
      billApprovedDesc: _controllers['billApprovedDesc']!.text.trim(),
      billRejectedTitle: _controllers['billRejectedTitle']!.text.trim(),
      billRejectedDesc: _controllers['billRejectedDesc']!.text.trim(),
      profileApprovedTitle: _controllers['profileApprovedTitle']!.text.trim(),
      profileApprovedDesc: _controllers['profileApprovedDesc']!.text.trim(),
      profileRejectedTitle: _controllers['profileRejectedTitle']!.text.trim(),
      profileRejectedDesc: _controllers['profileRejectedDesc']!.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeControllers(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return AdminLayout(
          screenTitle: "Notification Templates",
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 1000.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
  child: Column(
    mainAxisSize: MainAxisSize.min, // Prevents it from trying to fill vertical space
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _buildSection("Bill Approved", 'billApprovedTitle', 'billApprovedDesc'),
      _buildSection("Bill Rejected", 'billRejectedTitle', 'billRejectedDesc'),
      _buildSection("Profile Approved", 'profileApprovedTitle', 'profileApprovedDesc'),
      _buildSection("Profile Rejected", 'profileRejectedTitle', 'profileRejectedDesc'),
      SizedBox(height: 28.h),
      Consumer<NotificationTemplateProvider>(
        builder: (context, provider, _) {
          return ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              backgroundColor: const Color(0xFFFF941A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            icon: const Icon(Icons.save),
            label: Text(
              provider.isLoading ? "Saving..." : "Save Templates",
              style: TextStyle(
                  fontSize: 8.sp, fontWeight: FontWeight.bold),
            ),
            onPressed: provider.isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      final template = _buildTemplateFromControllers();
                      await provider.saveTemplate(template);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Templates saved successfully")),
                      );
                    }
                  },
          );
        },
      ),
    ],
  ),
),

              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String label, String titleKey, String descKey) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _controllers[titleKey],
            decoration: InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _controllers[descKey],
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
          ),
        ],
      ),
    );
  }
}
