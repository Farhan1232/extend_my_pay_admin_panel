import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/notification_provider.dart';
import '../../Provider/user_provider.dart';
import '../../Model/user_model.dart';
import '../../Widgets/admin_layout.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String? selectedUserId;
  bool sendToAll = false;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).loadUsers(); // fetch users
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final provider =
          Provider.of<NotificationProvider>(context, listen: false);

      await provider.sendNotification(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        uid: sendToAll ? null : selectedUserId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notification sent successfully")),
      );

      _titleController.clear();
      _descController.clear();
      setState(() {
        selectedUserId = null;
        sendToAll = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final users = userProvider.users;

    return AdminLayout(
      screenTitle: "Send Notification",
      child: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text("Send to All Users"),
                    value: sendToAll,
                    onChanged: (value) {
                      setState(() {
                        sendToAll = value ?? false;
                        if (sendToAll) selectedUserId = null;
                      });
                    },
                  ),
                  if (!sendToAll)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select User (UID)",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedUserId,
                      isExpanded: true,
                      items: users
                          .map((user) => DropdownMenuItem<String>(
                                value: user.uid,
                                child: Text("${user.uid}"),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedUserId = value;
                        });
                      },
                      validator: (value) =>
                          sendToAll || value != null ? null : "Please select a user",
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: notificationProvider.isLoading ? null : _submit,
                    icon: const Icon(Icons.send),
                    label: Text(notificationProvider.isLoading
                        ? "Sending..."
                        : "Send Notification"),
                  )
                ],
              ),
            ),
    );
  }
}
