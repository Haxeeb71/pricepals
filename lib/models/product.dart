class Product {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final String retailer;
  final String category;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final double? originalPrice;
  final double? discountPercentage;
  final DateTime lastUpdated;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.retailer,
    required this.category,
    required this.tags,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    this.originalPrice,
    this.discountPercentage,
    required this.lastUpdated,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  double get discountAmount => hasDiscount ? originalPrice! - price : 0.0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      retailer: json['retailer'] as String,
      category: json['category'] as String,
      tags: List<String>.from(json['tags']),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      inStock: json['inStock'] as bool,
      originalPrice: json['originalPrice'] != null 
          ? (json['originalPrice'] as num).toDouble() 
          : null,
      discountPercentage: json['discountPercentage'] != null 
          ? (json['discountPercentage'] as num).toDouble() 
          : null,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'retailer': retailer,
      'category': category,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
      'inStock': inStock,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
