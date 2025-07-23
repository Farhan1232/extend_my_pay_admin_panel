// lib/Model/user_model.dart

class UsersModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String name;
  final String phone;
  final String dob;
  final String? profileImageUrl;
  final String? idFrontUrl;
  final String? idBackUrl;
  final double? latitude;
  final double? longitude;
  final String status;
  final String? address; // ✅ Added

  UsersModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.phone,
    required this.dob,
    this.profileImageUrl,
    this.idFrontUrl,
    this.idBackUrl,
    this.latitude,
    this.longitude,
    this.status = 'pending',
    this.address,
  });

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      dob: map['dob'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      idFrontUrl: map['idFrontUrl'],
      idBackUrl: map['idBackUrl'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      status: map['status'] ?? 'pending',
      address: map['address'], // ✅ FIXED: Now parsed
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'name': name,
      'phone': phone,
      'dob': dob,
      'profileImageUrl': profileImageUrl,
      'idFrontUrl': idFrontUrl,
      'idBackUrl': idBackUrl,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'address': address, // ✅ Include in map
    };
  }

  UsersModel copyWith({String? address}) {
    return UsersModel(
      uid: uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
      name: name,
      phone: phone,
      dob: dob,
      profileImageUrl: profileImageUrl,
      idFrontUrl: idFrontUrl,
      idBackUrl: idBackUrl,
      latitude: latitude,
      longitude: longitude,
      status: status,
      address: address ?? this.address,
    );
  }
}
