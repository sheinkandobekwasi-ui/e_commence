/// ============================================================================
/// Product Model
/// Coursework Concept: Data Models & Object-Oriented Programming in Dart
/// ============================================================================
/// Represents a single product available in Hetty's Shop.
/// Contains all properties required by the lecturer:
/// - id, name, description, price, image, category, stock
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final int stock;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.stock,
    this.rating = 4.5,
  });

  /// Helper getter to check if product is currently in stock
  bool get inStock => stock > 0;

  /// Helper to format price nicely (e.g. $49.99)
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
}
