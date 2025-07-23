import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/bill_model.dart';
import '../Provider/bill_provider.dart';

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

  Future<void> _uploadReceipt() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    final file = File(result.files.single.path!);

    await Provider.of<BillProvider>(context, listen: false)
        .uploadReceipt(widget.bill.billId, file);

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

  @override
  Widget build(BuildContext context) {
    final bill = widget.bill;

    return AdminLayout(
      screenTitle: "Bill Details",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
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

                  Text("Billing Company: ${bill.billingCompanyName}"),
                  Text("Category: ${bill.category}"),
                  Text("Code: ${bill.code}"),
                  Text("Owner: ${bill.ownerName}"),
                  Text("UID: ${bill.uid}"),
                  Text("Due Amount: Rs. ${bill.dueAmount}"),
                  Text("Installments: ${bill.installments}"),
                  Text("Due Date: ${_formatDate(bill.dueDate)}"),
                  const SizedBox(height: 20),

                  const Text("Status:", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
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

                        await Provider.of<BillProvider>(context, listen: false)
                            .updateBillStatus(bill.billId, newValue);

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

                  const SizedBox(height: 30),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.upload_file),
                        label: const Text("Upload Receipt"),
                        onPressed: _uploadReceipt,
                      ),
                      const SizedBox(width: 16),
                      if (receiptUrl != null)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.receipt),
                          label: const Text("View Receipt"),
                          onPressed: _viewReceipt,
                        ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Text("Installments", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),

                  if (installmentList.isEmpty)
                    const Text("Installment dates: Currently not scheduled")
                  else
                    ...installmentList.map((inst) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(inst['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text("Bill Name: ${inst['billName']}"),
                                Text("Owner: ${inst['owner']}"),
                                Text("Installment Date: ${_formatDate(inst['dueDate'])}"),
                                Text("Installment Approval Date: ${_formatDate(inst['approvedDate'])}"),
                                Text("Due Amount: Rs. ${inst['dueAmount']}"),
                                Text("Total Charges: Rs. ${inst['totalCharges'].toStringAsFixed(2)}"),
                                Text("Total Amount: Rs. ${inst['totalPayable'].toStringAsFixed(2)}"),
                                Text("Installment Amount: Rs. ${inst['installmentAmount']}"),
                              ],
                            ),
                          ),
                        )),
                ],
              ),
            ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }
}
