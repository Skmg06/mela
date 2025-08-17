class Product {
  final String id;
  final String sellerId;
  final String? categoryId;
  final String name;
  final String? description;
  final double price;
  final double? originalPrice;
  final String status;
  final List<String> images;
  final int inventoryCount;
  final List<String> tags;
  final Map<String, dynamic> metadata;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.sellerId,
    this.categoryId,
    required this.name,
    this.description,
    required this.price,
    this.originalPrice,
    required this.status,
    required this.images,
    required this.inventoryCount,
    required this.tags,
    required this.metadata,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      sellerId: json['seller_id'] as String,
      categoryId: json['category_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['original_price'] != null
          ? (json['original_price'] as num).toDouble()
          : null,
      status: json['status'] as String,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : [],
      inventoryCount: json['inventory_count'] as int,
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : [],
      metadata: json['metadata'] as Map<String, dynamic>,
      viewCount: json['view_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller_id': sellerId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'original_price': originalPrice,
      'status': status,
      'images': images,
      'inventory_count': inventoryCount,
      'tags': tags,
      'metadata': metadata,
      'view_count': viewCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  double get discountPercentage => hasDiscount
      ? ((originalPrice! - price) / originalPrice! * 100).roundToDouble()
      : 0.0;

  bool get isInStock => inventoryCount > 0;

  String get mainImage => images.isNotEmpty ? images.first : '';
}
