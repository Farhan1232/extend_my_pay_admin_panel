class PosterModel {
  final String id;
  final String imageUrl;
  final DateTime createdAt;

  PosterModel({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
  });

  factory PosterModel.fromMap(String id, Map<String, dynamic> data) {
    return PosterModel(
      id: id,
      imageUrl: data['imageUrl'] ?? '',
      createdAt: DateTime.parse(data['createdAt']),
    );
  }
}
