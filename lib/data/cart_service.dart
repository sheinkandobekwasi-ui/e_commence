import 'package:flutter/foundation.dart';
import 'package:hettys_shop/data/mock_data.dart';
import 'package:hettys_shop/models/cart_item.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/models/user_profile.dart';

/// ============================================================================
/// Cart & Session Service
/// Coursework Concept: State Management with ChangeNotifier (Flutter SDK)
/// ============================================================================
/// A singleton service that manages:
/// 1. Real-time shopping cart state (adding, removing, quantity increments)
/// 2. Active user session (authentication state, profile details)
///
/// Uses [ChangeNotifier] so any widget can listen for changes and update
/// its UI reactively without requiring third-party libraries.
class CartService extends ChangeNotifier {
  // Singleton pattern setup
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  /// Internal list of items stored in the cart
  final List<CartItem> _items = [];

  /// Current logged-in user profile
  UserProfile _currentUser = MockData.defaultUser;
  bool _isLoggedIn = true;

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------
  List<CartItem> get items => List.unmodifiable(_items);

  UserProfile get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  /// Returns total quantity count across all products
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Returns subtotal of all items
  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Standard flat delivery charge; $0 if cart is empty
  double get deliveryFee => _items.isEmpty ? 0.0 : 10.0;

  /// Estimated tax (5%)
  double get tax => _items.isEmpty ? 0.0 : (subtotal * 0.05);

  /// Grand total: subtotal + delivery + tax
  double get grandTotal => subtotal + deliveryFee + tax;

  // ---------------------------------------------------------------------------
  // Cart Actions
  // ---------------------------------------------------------------------------

  /// Checks if a specific product is already in the cart
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// Gets the quantity of a specific product in the cart
  int getQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    return index != -1 ? _items[index].quantity : 0;
  }

  /// Adds a product to the cart or increments its count if already present
  void addItem(Product product, {int quantity = 1}) {
    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      final newQuantity = _items[existingIndex].quantity + quantity;
      // Cap at available stock
      _items[existingIndex].quantity =
          newQuantity <= product.stock ? newQuantity : product.stock;
    } else {
      final safeQty = quantity <= product.stock ? quantity : product.stock;
      _items.add(CartItem(product: product, quantity: safeQty));
    }
    notifyListeners();
  }

  /// Increases quantity by 1 for a product
  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity < _items[index].product.stock) {
        _items[index].quantity++;
        notifyListeners();
      }
    }
  }

  /// Decreases quantity by 1; removes item if it drops to 0
  void decreaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Removes an item completely from the cart
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Clears all items (e.g. after order checkout is complete)
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // User Session Actions
  // ---------------------------------------------------------------------------

  /// Updates current user session upon login or registration
  void login({
    required String name,
    required String email,
    required String phone,
    String address = 'Campus Hall Room 12',
    String city = 'Accra',
  }) {
    _currentUser = UserProfile(
      name: name,
      email: email,
      phone: phone,
      address: address,
      city: city,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  /// Logs the user out
  void logout() {
    _isLoggedIn = false;
    clearCart();
    notifyListeners();
  }
}
