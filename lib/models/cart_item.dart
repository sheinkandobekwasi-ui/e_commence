import 'package:hettys_shop/models/product.dart';

/// ============================================================================
/// CartItem Model
/// Coursework Concept: Composite Data Models & Business Logic
/// ============================================================================
/// Represents an entry inside the user's shopping cart.
/// Holds the selected [Product] and its current purchase [quantity].
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  /// Calculates the total cost for this specific line item
  double get totalPrice => product.price * quantity;

  /// Helper to format the line item total price nicely
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';
}
