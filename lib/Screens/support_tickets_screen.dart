import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Provider/support_provider.dart';
import '../Model/support_ticket_model.dart';
import '../Widgets/admin_layout.dart';

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SupportProvider>(context, listen: false).loadTickets();
  }

  void _showDetailsDialog(SupportTicket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ticket.subject),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${ticket.description}"),
            const SizedBox(height: 10),
            Text("UID: ${ticket.uid}",
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(
              "Date: ${ticket.timestamp.toLocal()}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close current dialog
              _showRespondDialog(ticket.uid);
            },
            child: const Text("Respond"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showRespondDialog(String uid) {
    final _titleController = TextEditingController();
    final _descController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Send Notification"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Title is required" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Description is required" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await FirebaseFirestore.instance.collection('notifications').add({
                  'title': _titleController.text.trim(),
                  'description': _descController.text.trim(),
                  'uid': uid,
                  'timestamp': Timestamp.now(),
                });

                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Notification sent")),
                );
              }
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SupportProvider>(context);

    return AdminLayout(
      screenTitle: "Support Tickets",
      child: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.tickets.isEmpty
              ? const Center(child: Text("No support tickets found."))
              : ListView.builder(
                  itemCount: provider.tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = provider.tickets[index];

                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ticket.subject,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "UID: ${ticket.uid}",
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                            Text(
                              "Date: ${ticket.timestamp.toLocal()}",
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () => _showDetailsDialog(ticket),
                                child: const Text("View"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
