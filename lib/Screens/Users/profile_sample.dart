import 'package:extend_my_pay_admin_panel/Model/user_profile.dart';
import 'package:extend_my_pay_admin_panel/Provider/profile_provider.dart';
import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileListScreen extends StatelessWidget {
  const ProfileListScreen({super.key});

  final List<String> statusOptions = const ['pending', 'approved', 'rejected'];

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      screenTitle: "All User Profiles",
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Selector<ProfileProvider, bool>(
          selector: (_, provider) => provider.isLoading,
          builder: (context, isLoading, _) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Selector<ProfileProvider, List<UserProfile>>(
              selector: (_, provider) => provider.profiles,
              builder: (context, profiles, _) {
                if (profiles.isEmpty) {
                  return Center(
                    child: Text(
                      "No user profiles found.",
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
                    final safeStatus = statusOptions.contains(profile.status)
                        ? profile.status
                        : null;

                    return _ProfileCard(
                      profile: profile,
                      statusOptions: statusOptions,
                      safeStatus: safeStatus,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final List<String> statusOptions;
  final String? safeStatus;

  const _ProfileCard({
    required this.profile,
    required this.statusOptions,
    required this.safeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _showFullImageDialog(context, profile.profileImageUrl),
                  child: CircleAvatar(
                    radius: 35.r,
                    backgroundImage: NetworkImage(profile.profileImageUrl),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${profile.firstName} ${profile.lastName}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF941A),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text("Email: ${profile.email}", style: TextStyle(fontSize: 14.sp)),
                      Text("Phone: ${profile.phone}", style: TextStyle(fontSize: 14.sp)),
                      if (safeStatus != null)
                        Text("Status: ${safeStatus![0].toUpperCase()}${safeStatus?.substring(1)}",
                            style: TextStyle(fontSize: 14.sp, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF941A),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => _buildProfileDialog(context, profile),
                    );
                  },
                  child: Text("View", style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                ),
                SizedBox(width: 16.w),
                DropdownButton<String>(
                  value: safeStatus,
                  hint: Text("Select Status", style: TextStyle(fontSize: 14.sp)),
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
  }

  Widget _buildProfileDialog(BuildContext context, UserProfile profile) {
    return AlertDialog(
      title: const Text('User Details'),
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => _showFullImageDialog(context, profile.profileImageUrl),
                  child: CircleAvatar(
                    radius: 40.r,
                    backgroundImage: NetworkImage(profile.profileImageUrl),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _infoText("Name", "${profile.firstName} ${profile.lastName}"),
              _infoText("Email", profile.email),
              _infoText("Phone", profile.phone),
              _infoText("DOB", profile.dob),
              _infoText("Address", profile.address),
              _infoText("Status", profile.status),
              _infoText("UID", profile.uid),
              SizedBox(height: 16.h),
              const Text("ID Front:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () => _showFullImageDialog(context, profile.idFrontUrl),
                child: Image.network(profile.idFrontUrl, height: 150.h),
              ),
              SizedBox(height: 16.h),
              const Text("ID Back:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () => _showFullImageDialog(context, profile.idBackUrl),
                child: Image.network(profile.idBackUrl, height: 150.h),
              ),
            ],
          ),
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
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 14.sp))),
        ],
      ),
    );
  }

  void _showFullImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.all(10.w),
        child: InteractiveViewer(
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.all(10.w),
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
