class NotificationTemplate {
  final String billApprovedTitle;
  final String billApprovedDesc;
  final String billRejectedTitle;
  final String billRejectedDesc;
  final String profileApprovedTitle;
  final String profileApprovedDesc;
  final String profileRejectedTitle;
  final String profileRejectedDesc;

  NotificationTemplate({
    required this.billApprovedTitle,
    required this.billApprovedDesc,
    required this.billRejectedTitle,
    required this.billRejectedDesc,
    required this.profileApprovedTitle,
    required this.profileApprovedDesc,
    required this.profileRejectedTitle,
    required this.profileRejectedDesc,
  });

  factory NotificationTemplate.fromMap(Map<String, dynamic> map) {
    return NotificationTemplate(
      billApprovedTitle: map['billApprovedTitle'] ?? '',
      billApprovedDesc: map['billApprovedDesc'] ?? '',
      billRejectedTitle: map['billRejectedTitle'] ?? '',
      billRejectedDesc: map['billRejectedDesc'] ?? '',
      profileApprovedTitle: map['profileApprovedTitle'] ?? '',
      profileApprovedDesc: map['profileApprovedDesc'] ?? '',
      profileRejectedTitle: map['profileRejectedTitle'] ?? '',
      profileRejectedDesc: map['profileRejectedDesc'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'billApprovedTitle': billApprovedTitle,
      'billApprovedDesc': billApprovedDesc,
      'billRejectedTitle': billRejectedTitle,
      'billRejectedDesc': billRejectedDesc,
      'profileApprovedTitle': profileApprovedTitle,
      'profileApprovedDesc': profileApprovedDesc,
      'profileRejectedTitle': profileRejectedTitle,
      'profileRejectedDesc': profileRejectedDesc,
    };
  }
}
