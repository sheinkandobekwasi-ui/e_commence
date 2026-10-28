import 'package:flutter/material.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/models/cart_item.dart';
import 'package:hettys_shop/widgets/app_image.dart';
import 'package:hettys_shop/widgets/custom_button.dart';

/// ============================================================================
/// CartScreen
/// Coursework Concepts: StatefulWidget, Scaffold, AppBar, ListView, Container,
/// SizedBox, child & children, Reactive Calculation, Page Navigation
/// ============================================================================
/// Provides a fully interactive shopping cart:
/// - Displays added products
/// - Increase and decrease quantity buttons
/// - Delete / remove item functionality
/// - Real-time automated calculation of subtotal, delivery, tax, and total
/// - Empty cart placeholder message with action to start shopping
/// - Checkout transition
class CartScreen extends StatefulWidget {
  final bool isRootTab;
  final VoidCallback? onContinueShopping;

  const CartScreen({
    super.key,
    this.isRootTab = false,
    this.onContinueShopping,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ListenableBuilder updates the StatefulWidget whenever CartService notifies listeners
    return ListenableBuilder(
      listenable: _cartService,
      builder: (context, _) {
        final items = _cartService.items;
        final itemCount = _cartService.itemCount;
        final subtotal = _cartService.subtotal;
        final deliveryFee = _cartService.deliveryFee;
        final tax = _cartService.tax;
        final grandTotal = _cartService.grandTotal;

        // Coursework Concept: Scaffold with AppBar & body
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text(
              'Shopping Cart',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            automaticallyImplyLeading: !widget.isRootTab,
            actions: [
              if (items.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    // Show confirmation dialog before clearing
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Clear Cart?'),
                        content: const Text(
                          'Are you sure you want to remove all items from your cart?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              _cartService.clearCart();
                              Navigator.pop(ctx);
                            },
                            child: const Text(
                              'Clear All',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Clear',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: items.isEmpty
              // ---------------- EMPTY CART MESSAGE (RESPONSIVE SCROLL) ----------------
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.remove_shopping_cart_outlined,
                            size: 55,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Your Cart is Empty',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Looks like you haven\'t added any items to your shopping cart yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Start Shopping',
                          icon: Icons.storefront,
                          width: 220,
                          onPressed: () {
                            if (widget.onContinueShopping != null) {
                              widget.onContinueShopping!();
                            } else if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacementNamed(context, '/main');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              // ---------------- CART ITEMS & SUMMARY ----------------
              : Column(
                  children: [
                    // Item Count Header Banner
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      color: theme.primaryColor.withOpacity(0.06),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$itemCount ${itemCount == 1 ? 'item' : 'items'} in your cart',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Subtotal: GH₵ ${subtotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable List of Cart Items
                    // Coursework Concept: ListView.separated
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _buildCartItemCard(context, item);
                        },
                      ),
                    ),

                    // ---------------- ORDER SUMMARY & CHECKOUT BAR ----------------
                    // Coursework Concept: Container with child and children
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Subtotal row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'GH₵ ${subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Delivery Fee row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Fee',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'GH₵ ${deliveryFee.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Tax row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Estimated Tax (5%)',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'GH₵ ${tax.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(),
                            ),

                            // Grand Total row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Grand Total',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  'GH₵ ${grandTotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Coursework Concept: Page Navigation to Checkout
                            CustomButton(
                              text:
                                  'Proceed to Checkout • GH₵ ${grandTotal.toStringAsFixed(2)}',
                              icon: Icons.payment,
                              onPressed: () {
                                Navigator.pushNamed(context, '/checkout');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  /// Individual card for a line item inside the cart
  Widget _buildCartItemCard(BuildContext context, CartItem item) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.all(4),
              child: AppImage(
                imagePath: item.product.image,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Details & Controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Remove button
                    GestureDetector(
                      onTap: () {
                        _cartService.removeItem(item.product.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.product.formattedPrice,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),

                // Quantity controls & total price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity stepper
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _cartService.decreaseQuantity(item.product.id);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.remove, size: 14),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _cartService.increaseQuantity(item.product.id);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.add, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Line total
                    Text(
                      item.formattedTotalPrice,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
