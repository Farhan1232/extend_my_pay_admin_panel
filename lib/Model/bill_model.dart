import 'package:cloud_firestore/cloud_firestore.dart';

class BillModel {
  final String category;
  final String code;
  final DateTime createdAt;
  final String? customCategory;
  final num dueAmount;
  final DateTime dueDate;
  final int installments;
  final String ownerName;
  final String status;
  final String uid;
  final String billId;
  final DateTime? approvalDate;
  final String? receiptUrl;
  final String billingCompanyName;
  final String? receiptStatus;
  final bool paid; // ✅ NEW

  BillModel({
    required this.category,
    required this.code,
    required this.createdAt,
    required this.customCategory,
    required this.dueAmount,
    required this.dueDate,
    required this.installments,
    required this.ownerName,
    required this.status,
    required this.uid,
    required this.billId,
    required this.billingCompanyName,
    this.approvalDate,
    this.receiptUrl,
    this.receiptStatus,
    this.paid = false, // ✅ Default to false
  });

  factory BillModel.fromMap(Map<String, dynamic> map, String docId) {
    return BillModel(
      category: map['category'],
      code: map['code'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      customCategory: map['customCategory'],
      dueAmount: map['dueAmount'],
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      installments: map['installments'],
      ownerName: map['ownerName'],
      status: map['status'],
      uid: map['uid'],
      billId: docId,
      billingCompanyName: map['billingCompanyName'] ?? '',
      approvalDate: map['approvalDate'] != null ? (map['approvalDate'] as Timestamp).toDate() : null,
      receiptUrl: map['receiptUrl'],
      receiptStatus: map['receiptStatus'],
      paid: map['paid'] ?? false, // ✅ Default to false if null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'code': code,
      'createdAt': createdAt,
      'customCategory': customCategory,
      'dueAmount': dueAmount,
      'dueDate': dueDate,
      'installments': installments,
      'ownerName': ownerName,
      'status': status,
      'uid': uid,
      'billingCompanyName': billingCompanyName,
      'paid': paid, // ✅ Include in map
      if (approvalDate != null) 'approvalDate': approvalDate,
      if (receiptUrl != null) 'receiptUrl': receiptUrl,
      if (receiptStatus != null) 'receiptStatus': receiptStatus,
    };
  }

  BillModel copyWith({
    String? category,
    String? code,
    DateTime? createdAt,
    String? customCategory,
    num? dueAmount,
    DateTime? dueDate,
    int? installments,
    String? ownerName,
    String? status,
    String? uid,
    String? billId,
    DateTime? approvalDate,
    String? receiptUrl,
    String? billingCompanyName,
    String? receiptStatus,
    bool? paid, // ✅ NEW
  }) {
    return BillModel(
      category: category ?? this.category,
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      customCategory: customCategory ?? this.customCategory,
      dueAmount: dueAmount ?? this.dueAmount,
      dueDate: dueDate ?? this.dueDate,
      installments: installments ?? this.installments,
      ownerName: ownerName ?? this.ownerName,
      status: status ?? this.status,
      uid: uid ?? this.uid,
      billId: billId ?? this.billId,
      approvalDate: approvalDate ?? this.approvalDate,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      billingCompanyName: billingCompanyName ?? this.billingCompanyName,
      receiptStatus: receiptStatus ?? this.receiptStatus,
      paid: paid ?? this.paid, // ✅ NEW
    );
  }
}
