import 'package:extend_my_pay_admin_panel/Provider/bill_provider.dart';
import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'bill_detail_screen.dart';

class BillListScreen extends StatelessWidget {
  final String uid;

  const BillListScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billProvider = Provider.of<BillProvider>(context, listen: false);

    return AdminLayout(
      screenTitle: "User Bills",
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h), // Adds space at top
  ElevatedButton.icon(
    icon: const Icon(Icons.arrow_back),
    label: const Text("Back"),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFF941A),
      foregroundColor: Colors.white,
      elevation: 2,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
    ),
    onPressed: () => Navigator.of(context).pop(),
  ),
         SizedBox(height: 20.h,),
          Expanded(
            child: FutureBuilder(
              future: billProvider.fetchBills(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Consumer<BillProvider>(
                  builder: (ctx, provider, _) {
                    final userBills = provider.bills
                        .where((bill) => bill.uid == uid)
                        .toList();

                    if (userBills.isEmpty) {
                      return const Center(child: Text("No bills found for this user."));
                    }

                    return ListView.builder(
                      itemCount: userBills.length,
                      itemBuilder: (ctx, i) {
                        final bill = userBills[i];
                        return Card(
                          margin: EdgeInsets.all(10.w),
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                              "Category: ${bill.category}",
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Code: ${bill.code}", style: TextStyle(fontSize: 14.sp)),
                                  Text("Due Date: ${bill.dueDate.toLocal()}", style: TextStyle(fontSize: 14.sp)),
                                  Text("Status: ${bill.status}", style: TextStyle(fontSize: 14.sp)),
                                ],
                              ),
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF941A), // accent blue
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("View"),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BillDetailScreen(bill: bill),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
