import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Model/bill_model.dart';

class BillProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  List<BillModel> _bills = [];
  List<BillModel> get bills => _bills;

  // Fetch all bills from Firestore
  Future<void> fetchBills() async {
    final snapshot = await FirebaseFirestore.instance.collection('bills').get();
    _bills = snapshot.docs.map((doc) => BillModel.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  // Send notification to user
  Future<void> sendNotificationToUser({
    required String uid,
    required String title,
    required String description,
  }) async {
    await _firestore.collection('notifications').add({
      'uid': uid,
      'title': title,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'unread',
    });
  }

  // Update bill status + send notification
  Future<void> updateBillStatus(String billId, String newStatus) async {
    final approvalTimestamp = Timestamp.now();
    final approvalDate = approvalTimestamp.toDate();

    final billIndex = _bills.indexWhere((b) => b.billId == billId);
    if (billIndex == -1) return;
    final bill = _bills[billIndex];

    // Update Firestore
    await _firestore.collection('bills').doc(billId).update({
      'status': newStatus,
      'approvalDate': approvalTimestamp,
    });

    // Update local model
    _bills[billIndex] = bill.copyWith(
      status: newStatus,
      approvalDate: approvalDate,
    );

    String title = '';
    String description = '';

    if (newStatus == 'approved') {
      title = 'Your bill is approved';
      description = 'Thank you for your submission.';
    } else if (newStatus == 'rejected') {
      title = 'Your bill is rejected';
      description = 'Thank you for applying. Please review the details.';
    }

    if (title.isNotEmpty && description.isNotEmpty) {
      await sendNotificationToUser(
        uid: bill.uid,
        title: title,
        description: description,
      );
    }

    notifyListeners();
  }

  // Upload receipt to Firebase Storage and Firestore
  Future<void> uploadReceipt(String billId, File file) async {
    final fileName = "${billId}_${DateTime.now().millisecondsSinceEpoch}";
    final ref = FirebaseStorage.instance.ref().child("bill_receipts/$fileName");

    await ref.putFile(file);
    final downloadUrl = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('bill_receipts')
        .doc(billId)
        .set({'receiptUrl': downloadUrl});

    await FirebaseFirestore.instance.collection('bills').doc(billId).update({
      'receiptUrl': downloadUrl,
      'receiptStatus': 'uploaded',
    });

    final index = _bills.indexWhere((b) => b.billId == billId);
    if (index != -1) {
      _bills[index] = _bills[index].copyWith(
        receiptUrl: downloadUrl,
        receiptStatus: 'uploaded',
      );
      notifyListeners();
    }
  }

  // ✅ Save generated installments and add dummy field
  Future<void> saveInstallmentsToFirestore(String uid, String billId, List<Map<String, dynamic>> installments) async {
    // Ensure dummy field exists
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bills')
        .doc(billId)
        .set({'dummy': ''}, SetOptions(merge: true)); // ✅ Add dummy field

    final CollectionReference billInstallmentsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bills')
        .doc(billId)
        .collection('installments');

    for (int i = 0; i < installments.length; i++) {
      final docId = "installment_$i";

      final installmentData = {
        ...installments[i],
        'billId': billId,
        'uid': uid,
        'installmentIndex': i,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await billInstallmentsCollection.doc(docId).set(installmentData);
    }
  }

  // Fetch payment charge configuration
  Future<Map<String, dynamic>?> fetchPaymentCharges() async {
    final snapshot = await FirebaseFirestore.instance.collection('payment_charges').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null;
  }

  // Get total earnings from all paid installments
  Future<num> getTotalEarningsFromPaidInstallments() async {
    num total = 0;

    for (final bill in _bills) {
      final installmentsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(bill.uid)
          .collection('bills')
          .doc(bill.billId)
          .collection('installments')
          .get();

      for (final doc in installmentsSnapshot.docs) {
        final data = doc.data();
        if (data['paid'] == true) {
          total += num.tryParse(data['installmentAmount'].toString()) ?? 0;
        }
      }
    }

    return total;
  }

  // Get bill status count
  Map<String, int> getBillStatusCounts() {
    int approved = 0;
    int rejected = 0;
    int pending = 0;

    for (final bill in _bills) {
      if (bill.status == 'approved') approved++;
      else if (bill.status == 'rejected') rejected++;
      else pending++;
    }

    return {
      'approved': approved,
      'rejected': rejected,
      'pending': pending,
    };
  }
}
