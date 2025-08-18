import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extend_my_pay_admin_panel/Model/bill_model.dart';
import 'package:extend_my_pay_admin_panel/Provider/bill_provider.dart';
import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BillDetailScreen extends StatefulWidget {
  final BillModel bill;

  const BillDetailScreen({super.key, required this.bill});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  String currentStatus = "";
  List<Map<String, dynamic>> installmentList = [];
  bool isLoading = false;
  double totalCharges = 0;
  double installmentAmount = 0;
  DateTime? approvedDate;
  String? receiptUrl;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.bill.status;
    _fetchReceiptUrl();

    if (currentStatus == 'approved') {
      approvedDate = DateTime.now();
      _generateInstallments();
    }
  }

  Future<void> _fetchReceiptUrl() async {
    final doc = await FirebaseFirestore.instance
        .collection('bill_receipts')
        .doc(widget.bill.billId)
        .get();

    if (doc.exists && doc.data() != null) {
      setState(() {
        receiptUrl = doc['receiptUrl'];
      });
    }
  }

  Future<void> _generateInstallments() async {
    setState(() => isLoading = true);

    final provider = Provider.of<BillProvider>(context, listen: false);
    final charges = await provider.fetchPaymentCharges();

    if (charges != null) {
      final double baseAmount = (charges['baseAmount'] ?? 0).toDouble();
      final double chargeAmount = (charges['chargeAmount'] ?? 0).toDouble();
      final double dueAmount = widget.bill.dueAmount.toDouble();
      final int numInstallments = widget.bill.installments;

      totalCharges = (dueAmount <= baseAmount)
          ? chargeAmount
          : (dueAmount / baseAmount) * chargeAmount;

      final totalPayable = dueAmount + totalCharges;
      installmentAmount = totalPayable / numInstallments;

      final now = approvedDate ?? DateTime.now();
      final interval = numInstallments == 4 ? 7 : 15;

      installmentList.clear();
      for (int i = 0; i < numInstallments; i++) {
        final installmentDate = now.add(Duration(days: (i + 1) * interval));
        installmentList.add({
          "title": "Installment ${i + 1}",
          "dueAmount": dueAmount,
          "totalCharges": totalCharges,
          "totalPayable": totalPayable,
          "installmentAmount": installmentAmount.toStringAsFixed(2),
          "dueDate": installmentDate,
          "billName": widget.bill.category,
          "owner": widget.bill.ownerName,
          "approvedDate": now,
          "paid": false,
        });
      }

      await provider.saveInstallmentsToFirestore(
        widget.bill.uid,
        widget.bill.billId,
        installmentList,
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> _uploadReceipt(BillProvider provider) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    final file = File(result.files.single.path!);
    await provider.uploadReceipt(widget.bill.billId, file);

    setState(() {
      receiptUrl = result.files.single.path;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Receipt uploaded successfully")),
    );
  }

  void _viewReceipt() {
    if (receiptUrl != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Receipt"),
          content: Image.network(receiptUrl!),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final bill = widget.bill;
    final orange = const Color(0xFFFF941A);

    return AdminLayout(
      screenTitle: "Bill Details",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back"),
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Wrap(
                    runSpacing: 10.h,
                    spacing: 20.w,
                    children: [
                      _infoBox("Billing Company", bill.billingCompanyName),
                      _infoBox("Category", bill.category),
                      _infoBox("Code", bill.code),
                      _infoBox("Owner", bill.ownerName),
                      _infoBox("UID", bill.uid),
                      _infoBox("Due Amount", "Rs. ${bill.dueAmount}"),
                      _infoBox("Installments", bill.installments.toString()),
                      _infoBox("Due Date", _formatDate(bill.dueDate)),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Text("Status", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  Consumer<BillProvider>(
                    builder: (context, provider, _) => DropdownButton<String>(
                      value: currentStatus,
                      items: ['pending', 'approved', 'rejected'].map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        if (newValue != null && newValue != currentStatus) {
                          setState(() => currentStatus = newValue);
                          await provider.updateBillStatus(bill.billId, newValue);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Status updated to $newValue")),
                          );

                          if (newValue == "approved") {
                            approvedDate = DateTime.now();
                            await _generateInstallments();
                          } else {
                            installmentList.clear();
                            setState(() {});
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Consumer<BillProvider>(
                    builder: (context, provider, _) => Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.upload_file),
                          label: const Text("Upload Receipt"),
                          onPressed: () => _uploadReceipt(provider),
                          style: ElevatedButton.styleFrom(backgroundColor: orange),
                        ),
                        SizedBox(width: 16.w),
                        if (receiptUrl != null)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.receipt),
                            label: const Text("View Receipt"),
                            onPressed: _viewReceipt,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text("Installments", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  if (installmentList.isEmpty)
                    const Text("Installment dates: Currently not scheduled")
                  else
                    ...installmentList.map((inst) {
                      final isPaid = inst['paid'] == true;
                     return Card(
  elevation: 3,
  margin: EdgeInsets.symmetric(vertical: 10.h),
  color: isPaid ? Colors.green.shade50 : Colors.red.shade50,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
  child: Padding(
    padding: EdgeInsets.all(16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              inst['title'],
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFFFF941A)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isPaid ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                isPaid ? "PAID" : "UNPAID",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        _infoText("Bill Name", inst['billName'], Colors.black87),
        _infoText("Owner", inst['owner'], Colors.black87),
        _infoText("Installment Date", _formatDate(inst['dueDate']), Colors.blueAccent),
        _infoText("Approval Date", _formatDate(inst['approvedDate']), Colors.blueAccent),

        Divider(height: 24.h, color: Colors.grey.shade300),

        _infoText("Due Amount", "\$. ${inst['dueAmount']}", Colors.redAccent),
        _infoText("Total Charges", "\$. ${inst['totalCharges'].toStringAsFixed(2)}", Colors.orange),
        _infoText("Total Amount", "\$. ${inst['totalPayable'].toStringAsFixed(2)}", Colors.deepPurple),
        _infoText("Installment Amount", "\$. ${inst['installmentAmount']}", const Color(0xFFFF941A)),
      ],
    ),
  ),
);

                    }),
                ],
              ),
            ),
    );
  }

  Widget _infoBox(String label, String value) {
    return Container(
      width: 300.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, color: const Color.fromARGB(255, 102, 123, 240),fontWeight: FontWeight.w700)),
          SizedBox(height: 6.h),
          Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }




  Widget _infoText(String label, String value, Color valueColor) {
  return Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: RichText(
      text: TextSpan(
        text: "$label: ",
        style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade800),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor,
              fontSize: 14.5.sp,
            ),
          ),
        ],
      ),
    ),
  );
}

}
