import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hettys_shop/data/mock_data.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================================================
/// ProductService
/// Coursework Concept: Reactive State Management & Fully Local Persistence
/// ============================================================================
/// Manages the local store catalog for Hetty's Shop:
/// 1. Completely decoupled from Firebase Firestore (Firestore is exclusively reserved
///    for text checkout orders to keep it lightweight and free-tier).
/// 2. Saves newly created products, edits, and deletions locally to device/PC storage
///    via SharedPreferences / Local JSON serialization.
/// 3. Instantly reflects changes across customer screens (Home, Categories, Details, Cart).
class ProductService extends ChangeNotifier {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;

  static const String _storageKey = 'shei_local_products';
  static const String _legacyStorageKey = 'hettys_local_products';

  ProductService._internal() {
    _products = List<Product>.from(MockData.sampleProducts);
    loadFromLocalPreferences();
  }

  late List<Product> _products;

  List<Product> get products => List.unmodifiable(_products);

  /// Total count of available products in the store
  int get totalCount => _products.length;

  /// Fetch a single product by its ID
  Product? getById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Adds a new product created by the Administrator.
  /// Saves locally on the PC/device and updates customer-facing views without cloud storage.
  Future<void> addProduct(Product product) async {
    _products.insert(0, product);
    notifyListeners();
    await _saveToLocalPreferences();
  }

  /// Updates an existing product locally on PC/device
  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
      await _saveToLocalPreferences();
    }
  }

  /// Deletes a product from the catalog locally
  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
    await _saveToLocalPreferences();
  }

  /// Reset products back to default catalog and update local storage
  Future<void> resetToDefault() async {
    _products = List<Product>.from(MockData.sampleProducts);
    notifyListeners();
    await _saveToLocalPreferences();
  }

  /// Loads products persisted in local SharedPreferences JSON storage
  Future<void> loadFromLocalPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var rawJson = prefs.getString(_storageKey);
      rawJson ??= prefs.getString(_legacyStorageKey);
      if (rawJson != null && rawJson.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(rawJson);
        final loaded = decodedList
            .map((item) => Product.fromMap(Map<String, dynamic>.from(item)))
            .toList();
        if (loaded.isNotEmpty) {
          _products = loaded;
          notifyListeners();
          debugPrint(
            '[ProductService] Loaded ${_products.length} products from local PC/device storage.',
          );
        }
      }
    } catch (e) {
      debugPrint('[ProductService] Local storage load fallback: $e');
    }
  }

  /// Serializes and persists products locally to SharedPreferences
  Future<void> _saveToLocalPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listMap = _products.map((p) => p.toMap()).toList();
      final encoded = jsonEncode(listMap);
      await prefs.setString(_storageKey, encoded);
      await prefs.setString(_legacyStorageKey, encoded);
      debugPrint(
        '[ProductService] Persisted ${_products.length} products to local PC/device storage.',
      );
    } catch (e) {
      debugPrint('[ProductService] Local storage save error: $e');
    }
  }
}
