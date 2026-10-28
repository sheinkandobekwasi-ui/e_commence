import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// ============================================================================
/// FirebaseService
/// Coursework Concept: Firebase Hybrid Storage Logic
/// ============================================================================
/// Connects application text data (orders, checkout details, user inputs,
/// product descriptions/prices, and support tickets) to Firebase Firestore
/// (keeping it on the free tier).
///
/// Images are stored locally in assets/images/ to avoid Firebase Storage billing.
///
/// Built with offline-first resilience: if Firestore is not configured or
/// disconnected, operations seamlessly fall back to local in-memory storage
/// without disrupting the user experience or throwing unhandled errors.
class FirebaseService extends ChangeNotifier {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _isInitialized = false;
  FirebaseFirestore? _firestore;

  bool get isInitialized => _isInitialized;
  bool get isFirestoreAvailable => _isInitialized && _firestore != null;

  // Local in-memory caches for hybrid offline persistence
  final List<Map<String, dynamic>> _cachedOrders = [];
  final List<Map<String, dynamic>> _cachedInquiries = [];

  List<Map<String, dynamic>> get cachedOrders =>
      List.unmodifiable(_cachedOrders);

  /// Initializes Firebase Core and Firestore with free-tier settings
  Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        // Safe default free-tier project options for demo/mobile/web
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyA8sample-key-hettys-shop-ghana',
            appId: '1:103000000000:android:samplehettysshop',
            messagingSenderId: '103000000000',
            projectId: 'hettys-shop-ghana-freetier',
            storageBucket: 'hettys-shop-ghana-freetier.appspot.com',
          ),
        );
      }
      _firestore = FirebaseFirestore.instance;
      _isInitialized = true;
      debugPrint('[FirebaseService] Firestore initialized successfully.');
      _startOrdersListener();
    } catch (e) {
      debugPrint('[FirebaseService] Running in local offline hybrid mode: $e');
      _isInitialized = false;
    }
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _ordersSubscription;

  void _startOrdersListener() {
    if (!isFirestoreAvailable || _ordersSubscription != null) return;
    try {
      _ordersSubscription = _firestore!
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .snapshots()
          .listen((snapshot) {
            for (final change in snapshot.docChanges) {
              if (change.type == DocumentChangeType.added) {
                final data = change.doc.data();
                if (data != null) {
                  final orderId = data['orderId']?.toString() ?? change.doc.id;
                  final exists = _cachedOrders.any((o) => o['orderId'] == orderId);
                  if (!exists) {
                    _cachedOrders.insert(0, data);
                  }
                }
              }
            }
            notifyListeners();
          }, onError: (err) {
            debugPrint('[FirebaseService] Real-time orders stream: $err');
          });
    } catch (e) {
      debugPrint('[FirebaseService] Orders listener notice: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Orders Collection
  // ---------------------------------------------------------------------------

  /// Saves a customer order text record to Firestore and local cache
  Future<bool> saveOrder(Map<String, dynamic> orderData) async {
    _cachedOrders.insert(0, Map<String, dynamic>.from(orderData));
    notifyListeners();

    if (!isFirestoreAvailable) {
      debugPrint('[FirebaseService] Order stored in local hybrid cache.');
      return true;
    }

    try {
      final docId =
          orderData['orderId']?.toString() ??
          'SH-${DateTime.now().millisecondsSinceEpoch}';
      await _firestore!
          .collection('orders')
          .doc(docId)
          .set(orderData, SetOptions(merge: true));
      debugPrint('[FirebaseService] Order $docId saved to Firestore.');
      return true;
    } catch (e) {
      debugPrint('[FirebaseService] Firestore saveOrder fallback to local: $e');
      return true;
    }
  }

  /// Retrieves list of past orders from Firestore or local cache
  Future<List<Map<String, dynamic>>> getOrders() async {
    if (!isFirestoreAvailable) {
      return List.unmodifiable(_cachedOrders);
    }

    try {
      final snapshot = await _firestore!
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .limit(50)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      }
    } catch (e) {
      debugPrint('[FirebaseService] Firestore getOrders error: $e');
    }

    return List.unmodifiable(_cachedOrders);
  }

  /// Updates status of an existing order in Firestore and local cache
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    final index = _cachedOrders.indexWhere((o) => o['orderId'] == orderId);
    if (index != -1) {
      _cachedOrders[index]['status'] = newStatus;
      notifyListeners();
    }

    if (!isFirestoreAvailable) {
      debugPrint('[FirebaseService] Order status updated in local cache.');
      return true;
    }

    try {
      await _firestore!
          .collection('orders')
          .doc(orderId)
          .set({'status': newStatus}, SetOptions(merge: true));
      debugPrint(
        '[FirebaseService] Order $orderId status updated to $newStatus in Firestore.',
      );
      return true;
    } catch (e) {
      debugPrint('[FirebaseService] Firestore updateOrderStatus error: $e');
      return true;
    }
  }

  // ---------------------------------------------------------------------------
  // Products Management: Handled 100% locally on PC/device
  // (Database Scope Correction: Firestore is kept ONLY for customer text orders)
  // ---------------------------------------------------------------------------
  // Products, descriptions, GH₵ prices, and images are managed entirely through
  // ProductService and the local device file system / SharedPreferences.

  // ---------------------------------------------------------------------------
  // Support Inquiries Collection
  // ---------------------------------------------------------------------------

  /// Saves a support inquiry / ticket to Firestore
  Future<bool> saveSupportTicket(Map<String, dynamic> ticketData) async {
    _cachedInquiries.insert(0, Map<String, dynamic>.from(ticketData));

    if (!isFirestoreAvailable) {
      debugPrint('[FirebaseService] Support ticket cached locally.');
      return true;
    }

    try {
      final ticketId =
          ticketData['ticketNumber']?.toString() ??
          'TKT-${DateTime.now().millisecondsSinceEpoch}';
      await _firestore!
          .collection('support_tickets')
          .doc(ticketId)
          .set(ticketData, SetOptions(merge: true));
      debugPrint('[FirebaseService] Support ticket saved to Firestore.');
      return true;
    } catch (e) {
      debugPrint('[FirebaseService] Firestore saveSupportTicket fallback: $e');
      return true;
    }
  }
}
