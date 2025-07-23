import 'package:extend_my_pay_admin_panel/Model/user_profile.dart';
import 'package:extend_my_pay_admin_panel/Provider/profile_provider.dart';
import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileListScreen extends StatelessWidget {
  const ProfileListScreen({super.key});

  final List<String> statusOptions = const ['pending', 'approved', 'rejected'];

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      screenTitle: "All User Profiles",
      child: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.profiles.isEmpty) {
            return const Center(child: Text("No user profiles found."));
          }

          return ListView.builder(
            itemCount: provider.profiles.length,
            itemBuilder: (context, index) {
              final profile = provider.profiles[index];
              final safeStatus = statusOptions.contains(profile.status) ? profile.status : null;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: GestureDetector(
                          onTap: () {
                            _showFullImageDialog(context, profile.profileImageUrl);
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(profile.profileImageUrl),
                          ),
                        ),
                        title: Text(
                          '${profile.firstName} ${profile.lastName}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email: ${profile.email}"),
                            Text("Phone: ${profile.phone}"),
                            if (safeStatus != null)
                              Text("Status: ${safeStatus[0].toUpperCase()}${safeStatus.substring(1)}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => _buildProfileDialog(context, profile),
                              );
                            },
                            child: const Text("View"),
                          ),
                          const SizedBox(width: 16),
                          DropdownButton<String>(
                            value: safeStatus,
                            hint: const Text("Select Status"),
                            items: statusOptions.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status[0].toUpperCase() + status.substring(1)),
                              );
                            }).toList(),
                            onChanged: (newStatus) {
                              if (newStatus != null) {
                                Provider.of<ProfileProvider>(context, listen: false)
                                    .updateStatus(profile.uid, newStatus);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileDialog(BuildContext context, UserProfile profile) {
    return AlertDialog(
      title: const Text('User Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () => _showFullImageDialog(context, profile.profileImageUrl),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(profile.profileImageUrl),
              ),
            ),
            const SizedBox(height: 16),
            _infoText("Name", "${profile.firstName} ${profile.lastName}"),
            _infoText("Email", profile.email),
            _infoText("Phone", profile.phone),
            _infoText("DOB", profile.dob),
            _infoText("Address", profile.address),
            _infoText("Status", profile.status),
            _infoText("Status", profile.uid),
            const SizedBox(height: 16),
            const Text("ID Front:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showFullImageDialog(context, profile.idFrontUrl),
              child: Image.network(profile.idFrontUrl, height: 150),
            ),
            const SizedBox(height: 16),
            const Text("ID Back:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showFullImageDialog(context, profile.idBackUrl),
              child: Image.network(profile.idBackUrl, height: 150),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }

  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showFullImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: InteractiveViewer(
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.all(10),
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
