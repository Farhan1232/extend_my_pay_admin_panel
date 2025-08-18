import 'package:flutter/material.dart';
import '../Controller/notification_template_controller.dart';
import '../Model/notification_template.dart';

class NotificationTemplateProvider with ChangeNotifier {
  NotificationTemplate? _template;
  bool _isLoading = false;

  final NotificationTemplateController _controller = NotificationTemplateController();

  NotificationTemplate? get template => _template;
  bool get isLoading => _isLoading;

  Future<void> loadTemplate() async {
    _template = await _controller.fetchTemplate();
    notifyListeners();
  }

  Future<void> saveTemplate(NotificationTemplate template) async {
    _isLoading = true;
    notifyListeners();

    await _controller.saveTemplate(template);

    _isLoading = false;
    notifyListeners();
  }
  
}
