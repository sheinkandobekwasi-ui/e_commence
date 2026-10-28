/// ============================================================================
/// Product Model
/// Coursework Concept: Data Models & Object-Oriented Programming in Dart
/// ============================================================================
/// Represents a single product available in Hetty's Shop.
/// Contains all properties required by the coursework:
/// - id, name, description, price, image, category, stock, rating, functionality,
///   specifications, and durability.
/// Supports Firebase Firestore JSON/Map serialization and local asset paths.
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final int stock;
  final double rating;
  final String functionality;
  final Map<String, String> specifications;
  final String durability;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.stock,
    this.rating = 4.5,
    this.functionality = '',
    this.specifications = const {},
    this.durability = '',
  });

  /// Helper getter to check if product is currently in stock
  bool get inStock => stock > 0;

  /// Helper to format price in Ghana Cedis (e.g. GH₵ 129)
  String get formattedPrice => price == price.roundToDouble()
      ? 'GH₵ ${price.toInt()}'
      : 'GH₵ ${price.toStringAsFixed(2)}';

  /// Check whether the product uses a local asset image
  bool get isLocalAsset =>
      image.startsWith('assets/') || !image.startsWith('http');

  /// Convert Product to a Map for Firestore persistence
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'stock': stock,
      'rating': rating,
      'functionality': functionality,
      'specifications': specifications,
      'durability': durability,
    };
  }

  /// Construct a Product from a Firestore document / Map
  factory Product.fromMap(Map<String, dynamic> map, [String? docId]) {
    final rawSpecs = map['specifications'];
    final Map<String, String> parsedSpecs = {};
    if (rawSpecs is Map) {
      rawSpecs.forEach((key, value) {
        parsedSpecs[key.toString()] = value.toString();
      });
    }

    return Product(
      id: docId ?? map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Unnamed Product',
      description: map['description']?.toString() ?? '',
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      image: map['image']?.toString() ?? 'assets/images/sample_product.png',
      category: map['category']?.toString() ?? 'Fashion',
      stock: (map['stock'] is num) ? (map['stock'] as num).toInt() : 1,
      rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : 4.5,
      functionality: map['functionality']?.toString() ?? '',
      specifications: parsedSpecs,
      durability: map['durability']?.toString() ?? '',
    );
  }

  /// Create a clone with modified fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? image,
    String? category,
    int? stock,
    double? rating,
    String? functionality,
    Map<String, String>? specifications,
    String? durability,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      functionality: functionality ?? this.functionality,
      specifications: specifications ?? this.specifications,
      durability: durability ?? this.durability,
    );
  }
}
