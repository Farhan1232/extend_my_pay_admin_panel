class UserProfile {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dob;
  final String status;
  final String profileImageUrl;
  final String idFrontUrl;
  final String idBackUrl;
  final String address;
  final double latitude;
  final double longitude;

  UserProfile({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.status,
    required this.profileImageUrl,
    required this.idFrontUrl,
    required this.idBackUrl,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final location = map['location'] ?? {};
    return UserProfile(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      dob: map['dob'] ?? '',
      status: map['status'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      idFrontUrl: map['idFrontUrl'] ?? '',
      idBackUrl: map['idBackUrl'] ?? '',
      address: location['address'] ?? '',
      latitude: location['latitude'] ?? 0.0,
      longitude: location['longitude'] ?? 0.0,
    );
  }
}
