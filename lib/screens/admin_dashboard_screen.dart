import 'package:flutter/material.dart';
import 'package:hettys_shop/data/mock_data.dart';
import 'package:hettys_shop/data/product_service.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/screens/admin_product_form_screen.dart';
import 'package:hettys_shop/services/admin_service.dart';
import 'package:hettys_shop/services/firebase_service.dart';
import 'package:hettys_shop/services/order_notification_service.dart';
import 'package:hettys_shop/widgets/app_image.dart';

/// ============================================================================
/// AdminDashboardScreen
/// Coursework Concept: Admin Product Management & Firestore Text Sync
/// ============================================================================
/// Administrator view allowing:
/// 1. Viewing live product catalog and customer orders
/// 2. Adding new products with local image assets (assets/images/) and GH₵ prices
/// 3. Setting detailed descriptions, functionality, specs, and durability
/// 4. Dynamic reflection of newly added items on the customer store view
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ProductService _productService = ProductService();
  final FirebaseService _firebaseService = FirebaseService();
  final Set<String> _alertedOrderIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        OrderNotificationService().markAllAsRead();
      }
    });
    OrderNotificationService().addListener(_handleOrderNotificationChange);
  }

  @override
  void dispose() {
    OrderNotificationService().removeListener(_handleOrderNotificationChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleOrderNotificationChange() {
    if (!mounted) return;
    final latest = OrderNotificationService().latestUnreadOrder;
    if (latest != null && !_alertedOrderIds.contains(latest.id)) {
      _alertedOrderIds.add(latest.id);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showRealTimeOrderAlert(latest);
        }
      });
    }
    setState(() {});
  }

  void _showRealTimeOrderAlert(OrderNotification order) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                color: Color(0xFF10B981),
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'New Customer Order!',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6A11CB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Order #${order.orderId}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A11CB),
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Customer: ${order.customerName ?? 'Customer'}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
            if (order.customerPhone != null) ...[
              const SizedBox(height: 2),
              Text(
                'Phone: ${order.customerPhone}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              'Destination: ${order.deliveryRegion}',
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order Total:',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  Text(
                    'GH₵ ${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Dismiss'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _tabController.animateTo(1);
              OrderNotificationService().markAllAsRead();
            },
            icon: const Icon(Icons.receipt_long, size: 16),
            label: const Text('Review Orders'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A11CB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveOrderAlertBanner() {
    return ListenableBuilder(
      listenable: OrderNotificationService(),
      builder: (context, _) {
        final unread = OrderNotificationService().unreadOrderCount;
        final latest = OrderNotificationService().latestUnreadOrder;
        if (unread == 0 || latest == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF10B981), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_active, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'LIVE ORDER #${latest.orderId}',
                          style: const TextStyle(
                            color: Color(0xFF38BDF8),
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$unread NEW',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${latest.customerName ?? 'Customer'} • GH₵ ${latest.totalAmount.toStringAsFixed(2)} • ${latest.deliveryRegion}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _tabController.animateTo(1);
                  OrderNotificationService().markAllAsRead();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('VIEW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openProductForm({Product? product}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => AdminProductFormScreen(productToEdit: product),
      ),
    );
  }

  void _showAddProductModal() {
    _openProductForm();
  }

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product?'),
        content: Text(
          'Are you sure you want to remove "${product.name}" from the store catalog?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _productService.deleteProduct(product.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed "${product.name}" from store.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Admin Portal • Shei Store',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          // Simulate Customer Order button (Test real-time alert)
          IconButton(
            tooltip: 'Simulate Customer Order (Test Real-Time Alert)',
            icon: const Icon(Icons.add_alert_outlined, color: Color(0xFF10B981)),
            onPressed: () async {
              await OrderNotificationService().simulateCustomerOrder(context);
            },
          ),
          // View Store as Customer
          IconButton(
            tooltip: 'View Customer Store',
            icon: const Icon(
              Icons.storefront_outlined,
              color: Color(0xFF6A11CB),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/main',
                (route) => false,
              );
            },
          ),
          // Logout
          IconButton(
            tooltip: 'Log Out of Admin',
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              AdminService().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF6A11CB),
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: const Color(0xFF6A11CB),
          indicatorWeight: 3,
          tabs: [
            const Tab(
              icon: Icon(Icons.inventory_2_outlined),
              text: 'Product Catalog',
            ),
            Tab(
              icon: ListenableBuilder(
                listenable: OrderNotificationService(),
                builder: (context, _) {
                  final unread = OrderNotificationService().unreadOrderCount;
                  if (unread > 0) {
                    return Badge(
                      label: Text('$unread'),
                      backgroundColor: Colors.redAccent,
                      child: const Icon(Icons.receipt_long_outlined),
                    );
                  }
                  return const Icon(Icons.receipt_long_outlined);
                },
              ),
              text: 'Customer Orders',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProductModal,
        backgroundColor: const Color(0xFF6A11CB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildLiveOrderAlertBanner(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // TAB 1: Product Management
                _buildProductsTab(theme),
                // TAB 2: Customer Orders
                _buildOrdersTab(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab(ThemeData theme) {
    return ListenableBuilder(
      listenable: _productService,
      builder: (context, _) {
        final products = _productService.products;
        final inStockCount = products.where((p) => p.inStock).length;

        return CustomScrollView(
          slivers: [
            // Top Metrics Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Total Products',
                            '${products.length}',
                            Icons.shopping_bag_outlined,
                            const Color(0xFF6A11CB),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricCard(
                            'In Stock',
                            '$inStockCount',
                            Icons.check_circle_outline,
                            Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricCard(
                            'Categories',
                            '${MockData.categories.length - 1}',
                            Icons.category_outlined,
                            const Color(0xFF2575FC),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Store Inventory',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          '${products.length} live items',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Products List
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = products[index];
                  return _buildAdminProductItem(product);
                }, childCount: products.length),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminProductItem(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: AppImage(
              imagePath: product.image,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A11CB).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A11CB),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Stock: ${product.stock}',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: product.inStock
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  product.formattedPrice,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Color(0xFF6A11CB),
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons: Edit & Delete
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF6A11CB),
                  size: 20,
                ),
                tooltip: 'Edit Product Details',
                onPressed: () => _openProductForm(product: product),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 20,
                ),
                tooltip: 'Delete Product',
                onPressed: () => _confirmDelete(product),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab(ThemeData theme) {
    return ListenableBuilder(
      listenable: _firebaseService,
      builder: (context, _) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _firebaseService.getOrders(),
          builder: (context, snapshot) {
            final orders = snapshot.data ?? _firebaseService.cachedOrders;

            if (orders.isEmpty) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No Customer Orders Yet',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Orders placed through the customer checkout will sync to Firestore and appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        onPressed: () =>
                            OrderNotificationService().simulateCustomerOrder(context),
                        icon: const Icon(Icons.add_alert_rounded, size: 16),
                        label: const Text('Simulate Test Customer Order'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A11CB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final orderId = order['orderId']?.toString() ?? 'Order';
            final currentStatus = order['status']?.toString() ?? 'Processing';

            Color statusColor;
            switch (currentStatus) {
              case 'Delivered':
                statusColor = Colors.green.shade700;
                break;
              case 'Dispatched':
                statusColor = const Color(0xFF6A11CB);
                break;
              case 'Confirmed':
                statusColor = Colors.blue.shade700;
                break;
              default:
                statusColor = Colors.orange.shade800;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            orderId,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6A11CB),
                              fontSize: 14.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2.5,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              currentStatus,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'GH₵ ${(order['totalAmount'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 18),
                  Text(
                    'Customer: ${order['customerName']} (${order['customerPhone']})',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Destination: ${order['deliveryAddress']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Payment: ${order['paymentMethod']} • Date: ${order['orderDate']}',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Order Status Update Action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Update Status:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        tooltip: 'Change order status',
                        initialValue: currentStatus,
                        onSelected: (newStatus) async {
                          if (newStatus != currentStatus) {
                            final region = order['deliveryRegion']?.toString() ??
                                (order['deliveryAddress']?.toString() ??
                                    'Ghana');
                            await _firebaseService.updateOrderStatus(
                              orderId,
                              newStatus,
                            );
                            if (!mounted) return;
                            setState(() {});
                            OrderNotificationService().notifyOrderStatusUpdated(
                              this.context,
                              orderId: orderId,
                              newStatus: newStatus,
                              deliveryRegion: region,
                            );
                          }
                        },
                        itemBuilder: (ctx) => [
                          'Processing',
                          'Confirmed',
                          'Dispatched',
                          'Delivered',
                        ].map((s) => PopupMenuItem(
                          value: s,
                          child: Text(
                            s,
                            style: TextStyle(
                              fontWeight: s == currentStatus
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: s == currentStatus
                                  ? const Color(0xFF6A11CB)
                                  : Colors.black87,
                            ),
                          ),
                        )).toList(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6A11CB).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF6A11CB).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.edit_note,
                                size: 16,
                                color: Color(0xFF6A11CB),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Change Status',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6A11CB),
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 16,
                                color: Color(0xFF6A11CB),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    },
  );
  }
}
