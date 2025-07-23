class UserModel {
  final String uid;
  final String email;

  UserModel({required this.uid, required this.email});

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
      };
}
