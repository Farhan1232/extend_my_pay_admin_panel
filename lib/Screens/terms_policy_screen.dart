import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/terms_policy_provider.dart';
import '../../Widgets/admin_layout.dart';

class TermsPolicyScreen extends StatefulWidget {
  const TermsPolicyScreen({super.key});

  @override
  State<TermsPolicyScreen> createState() => _TermsPolicyScreenState();
}

class _TermsPolicyScreenState extends State<TermsPolicyScreen> {
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TermsPolicyProvider>(context, listen: false);
    provider.loadPolicy().then((_) {
      final policy = provider.policy;
      if (policy != null) {
        _descController.text = policy.description;
      }
    });
  }

  void _savePolicy() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<TermsPolicyProvider>(context, listen: false);
      await provider.savePolicy(
        '', // Title removed as requested
        _descController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TermsPolicyProvider>(context);

    return AdminLayout(
      screenTitle: "Terms & Policy",
      child: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _descController,
                    minLines: 6,
                    maxLines: 15,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _savePolicy,
                    icon: const Icon(Icons.save),
                    label: const Text("Save"),
                  ),
                ],
              ),
            ),
    );
  }
}
