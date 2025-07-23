import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/payment_charge_model.dart';

class PaymentChargeController {
  final _firestore = FirebaseFirestore.instance;
  final String _docId = 'default'; // single config

  Future<PaymentChargeModel?> fetchChargeSetting() async {
    final doc = await _firestore.collection('payment_charges').doc(_docId).get();
    if (doc.exists) {
      return PaymentChargeModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> saveChargeSetting(PaymentChargeModel model) async {
    await _firestore.collection('payment_charges').doc(_docId).set(model.toMap());
  }
}
