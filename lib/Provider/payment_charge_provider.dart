import 'package:flutter/material.dart';
import '../Controller/payment_charge_controller.dart';
import '../Model/payment_charge_model.dart';

class PaymentChargeProvider extends ChangeNotifier {
  final PaymentChargeController _controller = PaymentChargeController();

  PaymentChargeModel? _setting;
  bool _isLoading = false;

  PaymentChargeModel? get setting => _setting;
  bool get isLoading => _isLoading;

  Future<void> loadSetting() async {
    _isLoading = true;
    notifyListeners();
    _setting = await _controller.fetchChargeSetting();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveSetting(PaymentChargeModel model) async {
    _isLoading = true;
    notifyListeners();
    await _controller.saveChargeSetting(model);
    _setting = model;
    _isLoading = false;
    notifyListeners();
  }
}
