import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    Future.microtask(() =>
        Provider.of<UserProvider>(context, listen: false).loadUsers());
  }

  @override
  Widget build(BuildContext context) {

    return AdminLayout(
      screenTitle: "User Bills Management",
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            _buildHeader(),
            SizedBox(height: 24.h),
            Expanded(
              child: _buildUserList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select User to View Bills',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Browse and manage user bills by selecting a user below',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.blueGrey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildUserList() {
    return Selector<UserProvider, bool>(
      selector: (_, provider) => provider.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          );
        }

        return Selector<UserProvider, List>(
          selector: (_, provider) => provider.users,
          builder: (context, users, _) {
            if (users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group_off, size: 48.sp, color: Colors.blueGrey[300]),
                    SizedBox(height: 16.h),
                    Text(
                      'No users found',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.blueGrey[400],
                      ),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _calculateCrossAxisCount(context),
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.6,
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return _buildUserCard(user);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildUserCard(user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BillListScreen(uid: user.uid),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  user.profileImageUrl != null
                      ? CircleAvatar(
                          radius: 24.r,
                          backgroundImage: NetworkImage(user.profileImageUrl!),
                        )
                      : CircleAvatar(
                          radius: 24.r,
                          backgroundColor: Colors.blueAccent.withOpacity(0.2),
                          child: Icon(Icons.person, size: 24.sp, color: Colors.blueAccent),
                        ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user.firstName} ${user.lastName}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.blueGrey[600],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "UID: ${user.uid}",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.blueAccent,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 238, 136, 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BillListScreen(uid: user.uid),
                      ),
                    );
                  },
                  child: Text(
                    "View Bills",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 4;
    if (screenWidth > 900) return 3;
    if (screenWidth > 600) return 2;
    return 1;
  }
}