class InstallmentModel {
  final String id;
  final String uid;
  final String code;
  final String company;
  final String amount;
  final int installment;
  final int totalInstallments;
  final String ownerName;
  final String status;
  final DateTime createdAt;

  InstallmentModel({
    required this.id,
    required this.uid,
    required this.code,
    required this.company,
    required this.amount,
    required this.installment,
    required this.totalInstallments,
    required this.ownerName,
    required this.status,
    required this.createdAt,
  });

  factory InstallmentModel.fromFirestore(String id, Map<String, dynamic> data) {
    return InstallmentModel(
      id: id,
      uid: data['uid'] ?? '',
      code: data['code'] ?? '',
      company: data['company'] ?? '',
      amount: data['amount'] ?? '',
      installment: data['installment'] ?? 0,
      totalInstallments: data['totalInstallments'] ?? 0,
      ownerName: data['ownerName'] ?? '',
      status: data['status'] ?? '',
      createdAt: DateTime.parse(data['createdAt']),
    );
  }
}
