import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/bill_provider.dart';
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
          // 🔙 Custom Back Button
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text("Back"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black87,
                elevation: 2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),

          // 🔽 Bill List Content
          Expanded(
            child: FutureBuilder(
              future: billProvider.fetchBills(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Consumer<BillProvider>(
                  builder: (ctx, billProvider, _) {
                    final userBills = billProvider.bills
                        .where((bill) => bill.uid == uid)
                        .toList();

                    if (userBills.isEmpty) {
                      return const Center(
                          child: Text("No bills found for this user."));
                    }

                    return ListView.builder(
                      itemCount: userBills.length,
                      itemBuilder: (ctx, i) {
                        final bill = userBills[i];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 4,
                          child: ListTile(
                            title: Text("Category: ${bill.category}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Code: ${bill.code}"),
                                Text("Due Date: ${bill.dueDate.toLocal()}"),
                                Text("Status: ${bill.status}"),
                              ],
                            ),
                            trailing: ElevatedButton(
                              child: const Text("View"),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        BillDetailScreen(bill: bill),
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
