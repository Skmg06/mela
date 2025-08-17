class Category {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final bool isFeatured;
  final int sortOrder;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.isFeatured,
    required this.sortOrder,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      isFeatured: json['is_featured'] as bool,
      sortOrder: json['sort_order'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'is_featured': isFeatured,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
