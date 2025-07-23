class TermsPolicyModel {
  final String id;
  final String description;

  TermsPolicyModel({required this.id, required this.description});

  factory TermsPolicyModel.fromMap(String id, Map<String, dynamic> data) {
    return TermsPolicyModel(
      id: id,
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
    };
  }
}
