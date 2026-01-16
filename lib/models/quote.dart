class Quote {
  final String id;
  final String text;
  final String? author;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isFavorite;

  Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      text: json['text'],
      author: json['author'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'category': category,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Quote copyWith({
    String? id,
    String? text,
    String? author,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
  }) {
    return Quote(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
