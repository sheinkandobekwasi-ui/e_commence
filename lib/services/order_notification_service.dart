import 'package:flutter/material.dart';
import 'package:hettys_shop/services/firebase_service.dart';

/// ============================================================================
/// OrderNotification Model
/// Coursework Concept: Data Models & Notification State
/// ============================================================================
class OrderNotification {
  final String id;
  final String orderId;
  final String title;
  final String message;
  final String status;
  final String deliveryRegion;
  final double totalAmount;
  final String? customerName;
  final String? customerPhone;
  final int? itemsCount;
  final DateTime timestamp;
  bool isRead;

  OrderNotification({
    required this.id,
    required this.orderId,
    required this.title,
    required this.message,
    required this.status,
    required this.deliveryRegion,
    required this.totalAmount,
    this.customerName,
    this.customerPhone,
    this.itemsCount,
    required this.timestamp,
    this.isRead = false,
  });
}

/// ============================================================================
/// OrderNotificationService
/// Coursework Concept: Reactive State Management & Real-Time Notification System
/// ============================================================================
/// Handles order notifications triggered immediately when:
/// 1. A customer submits a checkout order
/// 2. An administrator or customer updates order status (e.g. Processing -> Dispatched)
/// 3. An administrator tests/simulates real-time customer orders
///
/// Features:
/// - Real-Time reactive listener for Admin Dashboard badge counter
/// - Instant prominent popup alert dialog with order details
/// - Material Banner / Floating SnackBar notifications
/// - Persistent unread state management with "Mark all as read"
class OrderNotificationService extends ChangeNotifier {
  static final OrderNotificationService _instance =
      OrderNotificationService._internal();
  factory OrderNotificationService() => _instance;
  OrderNotificationService._internal();

  final List<OrderNotification> _notifications = [];

  List<OrderNotification> get notifications =>
      List.unmodifiable(_notifications);

  /// Number of unread notifications
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  int get unreadOrderCount => unreadCount;

  /// Most recent unread order notification
  OrderNotification? get latestUnreadOrder {
    try {
      return _notifications.firstWhere((n) => !n.isRead);
    } catch (_) {
      return null;
    }
  }

  /// Mark all notifications as read
  void markAllAsRead() {
    bool changed = false;
    for (final notif in _notifications) {
      if (!notif.isRead) {
        notif.isRead = true;
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  /// Mark single notification as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  /// Clear all notifications
  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  /// Triggered immediately when a customer submits an order at checkout
  void notifyOrderPlaced(
    BuildContext? context, {
    required String orderId,
    required String deliveryRegion,
    required double totalAmount,
    String? city,
    String? customerName,
    String? customerPhone,
    int? itemsCount,
  }) {
    final location = (city != null && city.isNotEmpty)
        ? '$city, $deliveryRegion'
        : deliveryRegion;
    final message =
        'Order #$orderId successfully placed! Delivery to $location is being processed.';

    final notification = OrderNotification(
      id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
      orderId: orderId,
      title: 'Order Placed Successfully',
      message: message,
      status: 'Processing',
      deliveryRegion: location,
      totalAmount: totalAmount,
      customerName: customerName ?? 'Customer',
      customerPhone: customerPhone ?? '+233 59 987 6242',
      itemsCount: itemsCount ?? 1,
      timestamp: DateTime.now(),
      isRead: false,
    );

    _notifications.insert(0, notification);
    notifyListeners();

    // Show immediate customer-facing dialog if context is available
    if (context != null && context.mounted) {
      showOrderPlacedDialog(
        context,
        orderId: orderId,
        message: message,
        deliveryRegion: location,
        totalAmount: totalAmount,
      );

      _showInAppBanner(
        context,
        title: 'Order Placed!',
        message: message,
        icon: Icons.check_circle_outline,
        color: const Color(0xFF10B981),
      );
    }
  }

  /// Triggered immediately when order status is updated (e.g., in Admin panel)
  void notifyOrderStatusUpdated(
    BuildContext? context, {
    required String orderId,
    required String newStatus,
    required String deliveryRegion,
  }) {
    final message =
        'Order #$orderId status updated to $newStatus! Delivery to $deliveryRegion is being processed.';

    final notification = OrderNotification(
      id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
      orderId: orderId,
      title: 'Order Status Updated: $newStatus',
      message: message,
      status: newStatus,
      deliveryRegion: deliveryRegion,
      totalAmount: 0.0,
      timestamp: DateTime.now(),
      isRead: false,
    );

    _notifications.insert(0, notification);
    notifyListeners();

    if (context != null && context.mounted) {
      _showInAppBanner(
        context,
        title: 'Order Status: $newStatus',
        message: message,
        icon: Icons.local_shipping_outlined,
        color: const Color(0xFF6A11CB),
      );
    }
  }

  /// Simulates a real-time customer order to demonstrate instant admin notifications
  Future<void> simulateCustomerOrder([BuildContext? context]) async {
    final orderId = 'SH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    const sampleRegion = 'Bono';
    const sampleCity = 'Sunyani';
    const sampleAmount = 450.00;
    const sampleCustomer = 'Kwame Mensah';
    const samplePhone = '+233 59 987 6242';

    final orderData = {
      'orderId': orderId,
      'customerName': sampleCustomer,
      'customerEmail': 'kwame.mensah@sheistore.com',
      'customerPhone': samplePhone,
      'deliveryRegion': '$sampleRegion Region',
      'deliveryCity': sampleCity,
      'deliveryAddress': 'Apartment 14, Unity Estate, Sunyani, Bono Region, Ghana',
      'paymentMethod': 'MTN Mobile Money (MoMo)',
      'itemCount': 2,
      'totalAmount': sampleAmount,
      'orderDate': DateTime.now().toLocal().toString().split('.')[0],
      'status': 'Processing',
    };

    // Save to FirebaseService
    await FirebaseService().saveOrder(orderData);

    // Notify service (listeners react immediately without needing BuildContext)
    notifyOrderPlaced(
      null,
      orderId: orderId,
      deliveryRegion: '$sampleCity, $sampleRegion Region',
      totalAmount: sampleAmount,
      city: sampleCity,
      customerName: sampleCustomer,
      customerPhone: samplePhone,
      itemsCount: 2,
    );
  }

  /// Displays an in-app styled SnackBar banner across screens
  void _showInAppBanner(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    try {
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger == null) return;

      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          elevation: 6,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: color.withOpacity(0.4), width: 1.5),
          ),
          duration: const Duration(seconds: 4),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } catch (_) {
      // Ignore if context is deactivated during rapid navigation
    }
  }

  /// Displays an interactive order placement modal dialog
  void showOrderPlacedDialog(
    BuildContext context, {
    required String orderId,
    required String message,
    required String deliveryRegion,
    required double totalAmount,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF10B981),
                size: 46,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Placed Successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6A11CB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Order #$orderId',
                style: const TextStyle(
                  color: Color(0xFF6A11CB),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                  ),
                  Text(
                    'GH₵ ${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A11CB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View Order Summary',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
