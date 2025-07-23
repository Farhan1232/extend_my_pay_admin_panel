// lib/Screens/Admin/users_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Controller/user_controller.dart';
import '../../Model/user_model.dart';
import '../../Provider/user_provider.dart';
import '../../Widgets/admin_layout.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final UserController _controller = UserController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).loadUsers();
  }

  void _showUserDetails(UsersModel user) {
    String selectedStatus = user.status;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("${user.firstName} ${user.lastName}"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user.email.isNotEmpty) Text("Email: ${user.email}"),
              if (user.phone.isNotEmpty) Text("Phone: ${user.phone}"),
              if (user.name.isNotEmpty) Text("Full Name: ${user.name}"),
              if (user.dob.isNotEmpty) Text("DOB: ${user.dob}"),
              Text("UID: ${user.uid}"),
              Text("Status: ${user.status}"),
              const SizedBox(height: 8),
              Text("Address: ${user.address ?? 'No address found'}"),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: "Change Status",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'approved', child: Text('Approved')),
                  DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
                ],
                onChanged: (val) {
                  if (val != null) selectedStatus = val;
                },
              ),
              const SizedBox(height: 10),
              if (user.profileImageUrl != null) ...[
                const Text("Profile Image:"),
                const SizedBox(height: 6),
                Image.network(user.profileImageUrl!, height: 100),
              ],
              if (user.idFrontUrl != null) ...[
                const SizedBox(height: 10),
                const Text("ID Front:"),
                const SizedBox(height: 6),
                Image.network(user.idFrontUrl!, height: 100),
              ],
              if (user.idBackUrl != null) ...[
                const SizedBox(height: 10),
                const Text("ID Back:"),
                const SizedBox(height: 6),
                Image.network(user.idBackUrl!, height: 100),
              ],
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
              Navigator.pop(context); // Close dialog early to avoid UI lag
              await _controller.updateUserStatus(user.uid, selectedStatus);

              if (selectedStatus == 'approved' || selectedStatus == 'rejected') {
                await _controller.sendNotification(
                  uid: user.uid,
                  type: selectedStatus, // either "approved" or "rejected"
                );
              }

              await Provider.of<UserProvider>(context, listen: false).loadUsers();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Status updated to $selectedStatus")),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return AdminLayout(
      screenTitle: "All Users",
      child: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.users.isEmpty
              ? const Center(child: Text("No users found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.users.length,
                  itemBuilder: (context, index) {
                    final user = provider.users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: user.profileImageUrl != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(user.profileImageUrl!),
                              )
                            : const CircleAvatar(child: Icon(Icons.person)),
                        title: Text("${user.firstName} ${user.lastName}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email: ${user.email}"),
                            Text("UID: ${user.uid}", style: const TextStyle(fontSize: 12)),
                            Text("Status: ${user.status}", style: const TextStyle(fontSize: 12)),
                            if (user.address != null)
                              Text("Location: ${user.address}", style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _showUserDetails(user),
                          child: const Text("View"),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
