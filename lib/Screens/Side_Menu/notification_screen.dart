import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    Provider.of<UserProvider>(context, listen: false).loadUsers();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<NotificationProvider>(context, listen: false);

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
          : Padding(
              padding: EdgeInsets.all(24.w),
              child: Center(
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 36.h),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 700.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Compose Notification",
                              style: TextStyle(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFF941A),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                "Send to All Users",
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              activeColor: const Color(0xFFFF941A),
                              value: sendToAll,
                              onChanged: (value) {
                                setState(() {
                                  sendToAll = value ?? false;
                                  if (sendToAll) selectedUserId = null;
                                });
                              },
                            ),
                            if (!sendToAll) ...[
                              SizedBox(height: 16.h),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "Select User",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                ),
                                value: selectedUserId,
                                isExpanded: true,
                                items: users
                                    .map((user) => DropdownMenuItem<String>(
                                          value: user.uid,
                                          child: Text(user.uid),
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
                            ],
                            SizedBox(height: 24.h),
                            TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: "Notification Title",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                              ),
                              style: TextStyle(fontSize: 16.sp),
                              validator: (val) => val == null || val.isEmpty ? 'Title is required' : null,
                            ),
                            SizedBox(height: 20.h),
                            TextFormField(
                              controller: _descController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: "Description",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                              ),
                              style: TextStyle(fontSize: 16.sp),
                              validator: (val) =>
                                  val == null || val.isEmpty ? 'Description is required' : null,
                            ),
                            SizedBox(height: 30.h),
                            SizedBox(
                              width: double.infinity,
                              height: 50.h,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF941A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                onPressed: notificationProvider.isLoading ? null : _submit,
                                icon: const Icon(Icons.send),
                                label: Text(
                                  notificationProvider.isLoading ? "Sending..." : "Send Notification",
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
