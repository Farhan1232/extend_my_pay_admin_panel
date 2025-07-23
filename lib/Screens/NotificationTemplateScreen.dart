import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Widgets/admin_layout.dart';

class NotificationTemplateScreen extends StatefulWidget {
  const NotificationTemplateScreen({super.key});

  @override
  State<NotificationTemplateScreen> createState() => _NotificationTemplateScreenState();
}

class _NotificationTemplateScreenState extends State<NotificationTemplateScreen> {
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

  bool isLoading = false;

  Future<void> _loadTemplates() async {
    final doc = await FirebaseFirestore.instance.collection('notification_templates').doc('templates').get();
    if (doc.exists) {
      final data = doc.data()!;
      _controllers.forEach((key, controller) {
        controller.text = data[key] ?? '';
      });
    }
  }

  Future<void> _saveTemplates() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final data = {
        for (var entry in _controllers.entries) entry.key: entry.value.text.trim(),
      };

      await FirebaseFirestore.instance
          .collection('notification_templates')
          .doc('templates')
          .set(data);

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Templates saved successfully")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      screenTitle: "Notification Templates",
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSection("Bill Approved", 'billApprovedTitle', 'billApprovedDesc'),
              _buildSection("Bill Rejected", 'billRejectedTitle', 'billRejectedDesc'),
              _buildSection("Profile Approved", 'profileApprovedTitle', 'profileApprovedDesc'),
              _buildSection("Profile Rejected", 'profileRejectedTitle', 'profileRejectedDesc'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: isLoading ? null : _saveTemplates,
                icon: const Icon(Icons.save),
                label: Text(isLoading ? "Saving..." : "Save Templates"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String label, String titleKey, String descKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controllers[titleKey],
          decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder()),
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controllers[descKey],
          decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
          maxLines: 3,
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
