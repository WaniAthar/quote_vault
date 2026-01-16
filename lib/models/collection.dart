class Collection {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int quoteCount;

  Collection({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.quoteCount = 0,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      quoteCount: json['quote_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
