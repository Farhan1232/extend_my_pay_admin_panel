import 'package:extend_my_pay_admin_panel/Controller/firestore_service.dart';
import 'package:extend_my_pay_admin_panel/Controller/notification_template_controller.dart';
import 'package:extend_my_pay_admin_panel/Model/notification_template.dart';
import 'package:extend_my_pay_admin_panel/Model/user_profile.dart';
import 'package:flutter/material.dart';


class ProfileProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

int get approvedCount => _profiles.where((p) => p.status == 'approved').length;
int get rejectedCount => _profiles.where((p) => p.status == 'rejected').length;
int get pendingCount => _profiles.where((p) => p.status == 'pending').length;


  List<UserProfile> _profiles = [];
  bool _isLoading = true;

  List<UserProfile> get profiles => _profiles;
  bool get isLoading => _isLoading;

  ProfileProvider() {
    fetchProfiles();
  }

  void fetchProfiles() {
    _firestoreService.getUserProfiles().listen((data) {
      _profiles = data;
      _isLoading = false;
      notifyListeners();
    });
  }
 Future<void> updateStatus(String uid, String newStatus) async {
  await _firestoreService.updateUserStatus(uid, newStatus);

  final NotificationTemplateController templateController = NotificationTemplateController();
  final NotificationTemplate? template = await templateController.fetchTemplate();

  if (template != null) {
    String title = '';
    String description = '';

    if (newStatus == 'approved') {
      title = template.profileApprovedTitle;
      description = template.profileApprovedDesc;
    } else if (newStatus == 'rejected') {
      title = template.profileRejectedTitle;
      description = template.profileRejectedDesc;
    }

    if (title.isNotEmpty && description.isNotEmpty) {
      await _firestoreService.sendNotificationToUser(
        uid: uid,
        title: title,
        description: description,
      );
    }
  }

  fetchProfiles(); // Refresh profile list
}


}
