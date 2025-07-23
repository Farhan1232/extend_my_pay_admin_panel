import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/user_provider.dart';
import 'bill_list_screen.dart';


class UserBillsListSelectorScreen extends StatefulWidget {
  const UserBillsListSelectorScreen({super.key});

  @override
  State<UserBillsListSelectorScreen> createState() => _UserBillsListSelectorScreenState();
}

class _UserBillsListSelectorScreenState extends State<UserBillsListSelectorScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return AdminLayout(
      screenTitle: "Select User to View Bills",
      child: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.users.length,
              itemBuilder: (context, index) {
                final user = provider.users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: user.profileImageUrl != null
                        ? CircleAvatar(backgroundImage: NetworkImage(user.profileImageUrl!))
                        : const CircleAvatar(child: Icon(Icons.person)),
                    title: Text("${user.firstName} ${user.lastName}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${user.email}"),
                        Text("UID: ${user.uid}", style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    trailing: ElevatedButton(
                      child: const Text("View Bills"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BillListScreen(uid: user.uid),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
