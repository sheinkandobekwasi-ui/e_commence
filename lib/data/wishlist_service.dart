import 'package:flutter/foundation.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/data/product_service.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================================================
/// WishlistService
/// Coursework Concept: Reactive State Management & Local Storage Persistence
/// ============================================================================
/// Manages customer wishlist (liked items) for Hetty's Shop:
/// 1. Allows users to save favorite items across sessions using SharedPreferences.
/// 2. Extends [ChangeNotifier] so heart buttons and Wishlist badges update reactively.
/// 3. Provides direct "Move to Cart" and "Move All to Cart" operations.
class WishlistService extends ChangeNotifier {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;

  static const String _storageKey = 'shei_wishlist_ids';
  static const String _legacyStorageKey = 'hettys_wishlist_ids';

  final Set<String> _wishlistIds = {};

  WishlistService._internal() {
    loadWishlist();
  }

  Set<String> get wishlistIds => Set.unmodifiable(_wishlistIds);

  int get itemCount => _wishlistIds.length;

  bool isWishlisted(String productId) => _wishlistIds.contains(productId);

  /// Returns list of [Product] objects currently saved in the wishlist
  List<Product> get wishlistProducts {
    final allProducts = ProductService().products;
    return allProducts.where((p) => _wishlistIds.contains(p.id)).toList();
  }

  /// Toggles liked status of a product and persists to local device storage
  Future<void> toggleWishlist(Product product) async {
    if (_wishlistIds.contains(product.id)) {
      _wishlistIds.remove(product.id);
    } else {
      _wishlistIds.add(product.id);
    }
    notifyListeners();
    await _saveToPreferences();
  }

  /// Adds a product to wishlist if not already present
  Future<void> addToWishlist(Product product) async {
    if (!_wishlistIds.contains(product.id)) {
      _wishlistIds.add(product.id);
      notifyListeners();
      await _saveToPreferences();
    }
  }

  /// Removes a product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    if (_wishlistIds.remove(productId)) {
      notifyListeners();
      await _saveToPreferences();
    }
  }

  /// Clears all items from wishlist
  Future<void> clearWishlist() async {
    _wishlistIds.clear();
    notifyListeners();
    await _saveToPreferences();
  }

  /// Moves a wishlisted item directly into the shopping cart
  Future<void> moveToCart(Product product) async {
    CartService().addItem(product, quantity: 1);
    await removeFromWishlist(product.id);
  }

  /// Moves all wishlisted items into the shopping cart at once
  Future<void> moveAllToCart() async {
    final items = wishlistProducts;
    for (final product in items) {
      CartService().addItem(product, quantity: 1);
    }
    await clearWishlist();
  }

  /// Loads persisted wishlist item IDs from SharedPreferences
  Future<void> loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var ids = prefs.getStringList(_storageKey);
      ids ??= prefs.getStringList(_legacyStorageKey);
      if (ids != null) {
        _wishlistIds.clear();
        _wishlistIds.addAll(ids);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[WishlistService] load fallback: $e');
    }
  }

  /// Persists current wishlist IDs locally to SharedPreferences
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_storageKey, _wishlistIds.toList());
      await prefs.setStringList(_legacyStorageKey, _wishlistIds.toList());
    } catch (e) {
      debugPrint('[WishlistService] save error: $e');
    }
  }
}
