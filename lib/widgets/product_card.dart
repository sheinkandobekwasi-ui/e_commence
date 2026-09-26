import 'package:flutter/material.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/models/product.dart';

/// ============================================================================
/// ProductCard Widget
/// Coursework Concept: StatelessWidget, Container, SizedBox, child & children
/// ============================================================================
/// A reusable card component to display product details in grids or lists.
/// Refactored for clean modern spacing, 4:3 aspect ratio image framing,
/// and dynamic vertical wrapping without excessive white space.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap ??
          () {
            // Coursework Concept: Page Navigation with Arguments
            Navigator.pushNamed(
              context,
              '/product-details',
              arguments: product,
            );
          },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- 1. PRODUCT IMAGE (4:3 ASPECT RATIO) ----------------
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                      child: Container(
                        color: const Color(0xFFF1F5F9),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          // Graceful fallback if offline or image fails to load
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: theme.primaryColor.withOpacity(0.08),
                              child: Center(
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 40,
                                  color: theme.primaryColor,
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Category pill tag
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Stock indicator badge
                  if (product.stock <= 5)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade800,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${product.stock} left',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ---------------- 2. PRODUCT DETAILS (DYNAMIC WRAPPING) ----------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top sub-column: Rating and Title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Star rating row
                        Row(
                          children: [
                            const Icon(Icons.star, size: 13, color: Colors.amber),
                            const SizedBox(width: 3),
                            Text(
                              product.rating.toString(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Product Title
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),

                    // Bottom sub-row: Price and Quick Add to Cart Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            product.formattedPrice,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                        // Quick Add button
                        InkWell(
                          onTap: () {
                            CartService().addItem(product, quantity: 1);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added "${product.name}" to cart!'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'VIEW CART',
                                  textColor: Colors.amber,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/cart');
                                  },
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
