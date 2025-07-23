import 'package:extend_my_pay_admin_panel/Model/admin_user_model.dart';
import 'package:flutter/material.dart';


class AppAuthProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
