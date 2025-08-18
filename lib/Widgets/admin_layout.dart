import 'package:extend_my_pay_admin_panel/Screens/sidebar/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'admin_header.dart';

class AdminLayout extends StatefulWidget {
  final Widget child;
  final String screenTitle;

  const AdminLayout({
    super.key,
    required this.child,
    required this.screenTitle,
  });

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  bool showSidebar = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.of(context).size.width;
    if (width < 600 && showSidebar) {
      setState(() {
        showSidebar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header stays same
          AdminHeader(title: widget.screenTitle),
          Expanded(
            child: Row(
              children: [
                if (showSidebar) const AdminSidebar(),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.grey[100],
                        padding: const EdgeInsets.all(16),
                        child: widget.child,
                      ),
                      // Three-dot toggle button
                      Positioned(
                        top: 1.h,
                        left: 14.w,
                        child: IconButton(
                          icon: Icon(Icons.menu, size: 28.sp),

                          onPressed: () {
                            setState(() {
                              showSidebar = !showSidebar;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
