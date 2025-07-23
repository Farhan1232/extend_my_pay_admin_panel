import 'package:flutter/material.dart';
import '../Controller/notification_controller.dart';
import '../Model/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationController _controller = NotificationController();

  bool isLoading = false;

  Future<void> sendNotification({
    required String title,
    required String description,
    String? uid,
  }) async {
    isLoading = true;
    notifyListeners();

    final notification = NotificationModel(
      title: title,
      description: description,
      uid: uid,
      timestamp: DateTime.now(),
    );

    await _controller.sendNotification(notification);

    isLoading = false;
    notifyListeners();
  }
}
