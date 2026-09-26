import 'package:flutter/material.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/data/mock_data.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/widgets/custom_button.dart';

/// ============================================================================
/// ProductDetailsScreen
/// Coursework Concepts: StatefulWidget, Scaffold, AppBar, Container, SizedBox,
/// Navigation Arguments, child & children, Form/Quantity State
/// ============================================================================
/// Displays complete product information including:
/// - Product Image
/// - Name
/// - Price
/// - Description
/// - Stock Status
/// - Quantity Selector
/// - Add to Cart and Buy Now actions
///
/// NOTE FOR LECTURER:
/// Uses navigation arguments passed from the product grid/list:
/// `ModalRoute.of(context)!.settings.arguments as Product`
class ProductDetailsScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailsScreen({super.key, this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedQuantity = 1;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // =========================================================================
    // Coursework Concept: Navigation Arguments Extraction
    // Retrieves the selected Product passed via Navigator.pushNamed(..., arguments: product)
    // =========================================================================
    final Product product = widget.product ??
        (ModalRoute.of(context)?.settings.arguments as Product?) ??
        MockData.sampleProducts.first;

    // Coursework Concept: Scaffold with AppBar & body
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          // Favorite toggle
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.black87,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isFavorite
                      ? 'Added to your favorites wishlist!'
                      : 'Removed from favorites'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          // Cart badge button
          ListenableBuilder(
            listenable: CartService(),
            builder: (context, _) {
              final count = CartService().itemCount;
              return IconButton(
                icon: count > 0
                    ? Badge(
                        label: Text('$count'),
                        backgroundColor: Colors.redAccent,
                        child: const Icon(Icons.shopping_bag_outlined),
                      )
                    : const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Scrollable Product Information
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------- PRODUCT IMAGE CONTAINER ----------------
                  // Coursework Concept: Container with child
                  Container(
                    height: 320,
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: theme.primaryColor.withOpacity(0.08),
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 80,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ---------------- PRODUCT DETAILS CONTENT ----------------
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category and Rating Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                product.category.toUpperCase(),
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 18, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  '${product.rating} (128 reviews)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Coursework Concept: SizedBox for spacing
                        const SizedBox(height: 12),

                        // Product Name
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                            height: 1.25,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Price and Stock Tag Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.formattedPrice,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: theme.primaryColor,
                              ),
                            ),
                            // Stock badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: product.inStock
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: product.inStock
                                      ? Colors.green.shade300
                                      : Colors.red.shade300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    product.inStock
                                        ? Icons.check_circle_outline
                                        : Icons.cancel_outlined,
                                    size: 16,
                                    color: product.inStock
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.inStock
                                        ? 'In Stock (${product.stock} units)'
                                        : 'Out of Stock',
                                    style: TextStyle(
                                      color: product.inStock
                                          ? Colors.green.shade800
                                          : Colors.red.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),

                        // Description Section
                        const Text(
                          'Product Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Quantity Selector Section
                        Row(
                          children: [
                            const Text(
                              'Select Quantity:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 16),
                                    onPressed: _selectedQuantity > 1
                                        ? () {
                                            setState(() {
                                              _selectedQuantity--;
                                            });
                                          }
                                        : null,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      '$_selectedQuantity',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 16),
                                    onPressed: _selectedQuantity < product.stock
                                        ? () {
                                            setState(() {
                                              _selectedQuantity++;
                                            });
                                          }
                                        : null,
                                  ),
                                ],
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
          ),

          // ---------------- BOTTOM ACTION BUTTON BAR ----------------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Add to Cart Button
                  Expanded(
                    flex: 1,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: theme.primaryColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: product.inStock
                          ? () {
                              // Coursework Concept: Add to Cart functionality
                              CartService().addItem(
                                product,
                                quantity: _selectedQuantity,
                              );
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Added $_selectedQuantity x "${product.name}" to cart!'),
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
                            }
                          : null,
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Buy Now Button
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      text: 'Buy Now',
                      icon: Icons.flash_on,
                      backgroundColor: const Color(0xFF6A11CB),
                      onPressed: product.inStock
                          ? () {
                              CartService().addItem(
                                product,
                                quantity: _selectedQuantity,
                              );
                              // Page navigation directly to Checkout
                              Navigator.pushNamed(context, '/checkout');
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
