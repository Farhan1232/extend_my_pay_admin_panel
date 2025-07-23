import 'package:flutter/material.dart';
import '../Controller/terms_policy_controller.dart';
import '../Model/terms_policy_model.dart';

class TermsPolicyProvider extends ChangeNotifier {
  final TermsPolicyController _controller = TermsPolicyController();

  TermsPolicyModel? _policy;
  bool isLoading = false;

  TermsPolicyModel? get policy => _policy;

  Future<void> loadPolicy() async {
    isLoading = true;
    notifyListeners();

    _policy = await _controller.fetchPolicy();

    isLoading = false;
    notifyListeners();
  }

  Future<void> savePolicy(String title, String description) async {
    await _controller.savePolicy(title, description, _policy?.id);
    await loadPolicy(); // reload updated data
  }
}
