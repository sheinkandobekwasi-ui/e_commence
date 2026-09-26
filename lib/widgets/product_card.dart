import 'package:flutter/material.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/models/product.dart';

/// ============================================================================
/// ProductCard Widget
/// Coursework Concept: StatelessWidget, Container, SizedBox, child & children
/// ============================================================================
/// A reusable card component to display product details in grids or lists.
/// Demonstrates:
/// - StatelessWidget for immutable UI presentation
/// - Container with BoxDecoration (rounded borders, shadow, colors)
/// - ClipRRect for image corner radius
/// - Row, Column for structured layouts
/// - Page navigation with arguments via Navigator.pushNamed
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
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- PRODUCT IMAGE & BADGE ----------------
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      // Graceful fallback if offline or image fails to load
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.primaryColor.withOpacity(0.08),
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 48,
                              color: theme.primaryColor,
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Category pill tag
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Stock indicator
                if (product.stock <= 5)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Only ${product.stock} left',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // ---------------- PRODUCT INFORMATION ----------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Star rating
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: TextStyle(
                          fontSize: 12,
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
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price and Quick Add to Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.formattedPrice,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: theme.primaryColor,
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
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
