import 'package:flutter/material.dart';
import '../Controller/notification_template_controller.dart';
import '../Model/notification_template.dart';

class NotificationTemplateProvider with ChangeNotifier {
  NotificationTemplate? _template;
  final NotificationTemplateController _controller = NotificationTemplateController();

  NotificationTemplate? get template => _template;

  Future<void> loadTemplate() async {
    _template = await _controller.fetchTemplate();
    notifyListeners();
  }
}
