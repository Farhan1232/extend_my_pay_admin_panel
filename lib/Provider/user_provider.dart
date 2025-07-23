import 'package:flutter/material.dart';

import '../Controller/user_controller.dart';
import '../Model/user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserController _controller = UserController();
  List<UsersModel> _users = [];
  bool _isLoading = false;

  List<UsersModel> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    _users = await _controller.fetchAllUsers();

    // If address fetching is not needed, this loop can be kept only if you plan to do something else here later
    // otherwise it can be removed. Keeping as-is in case you expand logic later.

    _isLoading = false;
    notifyListeners();
  }
}
