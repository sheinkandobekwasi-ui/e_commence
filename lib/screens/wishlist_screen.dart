import 'package:flutter/material.dart';
import 'package:hettys_shop/data/wishlist_service.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/widgets/app_image.dart';
import 'package:hettys_shop/widgets/custom_button.dart';

/// ============================================================================
/// WishlistScreen
/// Coursework Concept: StatefulWidget, Scaffold, AppBar, ListView, State Management
/// ============================================================================
/// Dedicated view displaying customer's liked items saved locally on the device:
/// 1. Real-time updates via [WishlistService]
/// 2. Direct "Move to Cart" action on each item
/// 3. Direct "Checkout Now" shortcut to finalize purchase immediately
/// 4. Heart toggle to remove items
/// 5. Clean empty state with quick navigation back to shopping
class WishlistScreen extends StatefulWidget {
  final VoidCallback? onExploreProducts;

  const WishlistScreen({super.key, this.onExploreProducts});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'My Wishlist',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            const SizedBox(width: 8),
            ListenableBuilder(
              listenable: _wishlistService,
              builder: (context, _) {
                final count = _wishlistService.itemCount;
                if (count == 0) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          ListenableBuilder(
            listenable: _wishlistService,
            builder: (context, _) {
              final count = _wishlistService.itemCount;
              if (count == 0) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () async {
                  await _wishlistService.moveAllToCart();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Moved all wishlist items to your shopping cart!',
                        ),
                        backgroundColor: const Color(0xFF10B981),
                        action: SnackBarAction(
                          label: 'VIEW CART',
                          textColor: Colors.amber,
                          onPressed: () => Navigator.pushNamed(context, '/cart'),
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add_shopping_cart, size: 16),
                label: const Text(
                  'Move All to Cart',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6A11CB),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: _wishlistService,
        builder: (context, _) {
          final items = _wishlistService.wishlistProducts;

          if (items.isEmpty) {
            return _buildEmptyWishlist(context);
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = items[index];
              return _buildWishlistItemCard(context, product);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 52,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Wishlist is Empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore products you love and tap the heart icon on any product to save them here for later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Explore Products',
              icon: Icons.storefront_outlined,
              width: 200,
              onPressed: () {
                if (widget.onExploreProducts != null) {
                  widget.onExploreProducts!();
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
    );
  }

  Widget _buildWishlistItemCard(BuildContext context, Product product) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Thumbnail
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/product-details',
                    arguments: product,
                  );
                },
                child: Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: AppImage(
                    imagePath: product.image,
                    fit: BoxFit.contain,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6A11CB).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.category,
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6A11CB),
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Remove from Wishlist button
                        InkWell(
                          onTap: () {
                            _wishlistService.removeFromWishlist(product.id);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Removed "${product.name}" from Wishlist',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.favorite,
                              size: 19,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Title
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/product-details',
                          arguments: product,
                        );
                      },
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Price & Stock
                    Row(
                      children: [
                        Text(
                          product.formattedPrice,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          product.stock > 0 ? '• In Stock' : '• Out of Stock',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: product.stock > 0
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 18),

          // Direct Actions: Move to Cart & Checkout Now
          Row(
            children: [
              // Move to Cart
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await _wishlistService.moveToCart(product);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Moved "${product.name}" to shopping cart!',
                          ),
                          backgroundColor: const Color(0xFF10B981),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            textColor: Colors.amber,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/cart'),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                  label: const Text(
                    'Move to Cart',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6A11CB),
                    side: BorderSide(
                      color: const Color(0xFF6A11CB).withOpacity(0.4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Checkout Now
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _wishlistService.moveToCart(product);
                    if (context.mounted) {
                      Navigator.pushNamed(context, '/checkout');
                    }
                  },
                  icon: const Icon(Icons.flash_on_rounded, size: 16),
                  label: const Text(
                    'Checkout Now',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A11CB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
