import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Model/support_ticket_model.dart';
import '../../Provider/support_provider.dart';
import '../../Widgets/admin_layout.dart';

class SupportTicketsScreen extends StatelessWidget {
  const SupportTicketsScreen({super.key});

  void _showDetailsDialog(BuildContext context, SupportTicket ticket) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(ticket.subject),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${ticket.description}"),
            SizedBox(height: 10.h),
            Text("UID: ${ticket.uid}",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            Text(
              "Date: ${ticket.timestamp.toLocal()}",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showRespondDialog(context, ticket.uid);
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

  void _showRespondDialog(BuildContext context, String uid) {
    final _titleController = TextEditingController();
    final _descController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
              SizedBox(height: 10.h),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF941A),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await FirebaseFirestore.instance.collection('notifications').add({
                  'title': _titleController.text.trim(),
                  'description': _descController.text.trim(),
                  'uid': uid,
                  'timestamp': Timestamp.now(),
                });

                Navigator.pop(context);
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
    return Consumer<SupportProvider>(
      builder: (context, provider, _) {
        if (!provider.isLoading && provider.tickets.isEmpty) {
          provider.loadTickets();
        }

        return AdminLayout(
          screenTitle: "Support Tickets",
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.tickets.isEmpty
                    ? const Center(child: Text("No support tickets found."))
                    : ListView.builder(
                        itemCount: provider.tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = provider.tickets[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.subject,
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFF941A)),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    "UID: ${ticket.uid}",
                                    style: TextStyle(
                                        fontSize: 13.sp, color: Colors.black54),
                                  ),
                                  Text(
                                    "Date: ${ticket.timestamp.toLocal()}",
                                    style: TextStyle(
                                        fontSize: 13.sp, color: Colors.black54),
                                  ),
                                  SizedBox(height: 12.h),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFFF941A),
                                      ),
                                      onPressed: () =>
                                          _showDetailsDialog(context, ticket),
                                      child: const Text("View"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        );
      },
    );
  }
}
