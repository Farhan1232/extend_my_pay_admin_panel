class PaymentChargeModel {
  final double baseAmount;
  final double chargeAmount;

  PaymentChargeModel({
    required this.baseAmount,
    required this.chargeAmount,
  });

  factory PaymentChargeModel.fromMap(Map<String, dynamic> map) {
    return PaymentChargeModel(
      baseAmount: (map['baseAmount'] ?? 0).toDouble(),
      chargeAmount: (map['chargeAmount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'baseAmount': baseAmount,
      'chargeAmount': chargeAmount,
    };
  }
}
