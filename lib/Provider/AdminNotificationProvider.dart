import 'package:extend_my_pay_admin_panel/Model/AdminNotificationModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AdminNotificationProvider extends ChangeNotifier {
  final List<AdminNotificationModel> _notifications = [];
  bool _isLoading = false;

  List<AdminNotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    final snapshot = await FirebaseFirestore.instance
        .collection('admin_notifications')
        .orderBy('createdAt', descending: true)
        .get();

    _notifications.clear();
    _notifications.addAll(snapshot.docs
        .map((doc) => AdminNotificationModel.fromFirestore(doc.id, doc.data())));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('admin_notifications')
        .doc(notificationId)
        .update({'isRead': true});

    await loadNotifications(); // refresh
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}
