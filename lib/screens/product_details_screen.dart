import 'package:flutter/material.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/data/mock_data.dart';
import 'package:hettys_shop/data/wishlist_service.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/widgets/account_helpdesk_card.dart';
import 'package:hettys_shop/widgets/app_image.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // =========================================================================
    // Coursework Concept: Navigation Arguments Extraction
    // Retrieves the selected Product passed via Navigator.pushNamed(..., arguments: product)
    // =========================================================================
    final Product product =
        widget.product ??
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
          // Wishlist heart toggle
          ListenableBuilder(
            listenable: WishlistService(),
            builder: (context, _) {
              final isWishlisted = WishlistService().isWishlisted(product.id);
              return IconButton(
                tooltip: isWishlisted ? 'Remove from Wishlist' : 'Add to Wishlist',
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? Colors.redAccent : Colors.black87,
                ),
                onPressed: () {
                  WishlistService().toggleWishlist(product);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isWishlisted
                            ? 'Removed from your Wishlist'
                            : 'Added to your Wishlist ❤️',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
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
                  // ---------------- PRODUCT IMAGE CONTAINER (FULL DISPLAY) ----------------
                  // Coursework Concept: Container with child
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: const Color(0xFFF8FAFC),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: AppImage(
                        imagePath: product.image,
                        // Ensures full product is displayed from top to bottom without top cropping
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
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
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  product.category.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Colors.amber,
                                ),
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
                            Flexible(
                              child: Text(
                                product.formattedPrice,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Stock badge
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
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
                                  mainAxisSize: MainAxisSize.min,
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
                                    Flexible(
                                      child: Text(
                                        product.inStock
                                            ? 'In Stock (${product.stock} units)'
                                            : 'Out of Stock',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: product.inStock
                                              ? Colors.green.shade800
                                              : Colors.red.shade800,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),

                        // ---------------- 1. DESCRIPTION / OVERVIEW ----------------
                        _buildDetailCard(
                          icon: Icons.description_outlined,
                          title: 'Product Overview',
                          child: Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),

                        // ---------------- 2. FUNCTIONALITY & PRACTICAL USE ----------------
                        if (product.functionality.isNotEmpty)
                          _buildDetailCard(
                            icon: Icons.tune_rounded,
                            iconColor: const Color(0xFF2575FC),
                            title: 'Functionality & Performance',
                            child: Text(
                              product.functionality,
                              style: TextStyle(
                                fontSize: 13.5,
                                height: 1.55,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),

                        // ---------------- 3. QUALITY SPECIFICATIONS TABLE ----------------
                        if (product.specifications.isNotEmpty)
                          _buildDetailCard(
                            icon: Icons.format_list_bulleted,
                            iconColor: const Color(0xFF6A11CB),
                            title: 'Quality Specifications',
                            child: _buildSpecsTable(product.specifications),
                          ),

                        // ---------------- 4. DURABILITY & LONGEVITY DETAILS ----------------
                        if (product.durability.isNotEmpty)
                          _buildDetailCard(
                            icon: Icons.shield_outlined,
                            iconColor: Colors.teal.shade700,
                            title: 'Durability & Longevity',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.durability,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    height: 1.55,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.teal.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        size: 16,
                                        color: Colors.teal.shade800,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          'Verified Quality & Longevity Tested',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal.shade800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // ---------------- 5. HELPDESK ASSISTANCE BANNER ----------------
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.support_agent,
                                  color: theme.primaryColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Questions about this item?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    Text(
                                      'Shei Helpdesk provides instant answers.',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (ctx) => SafeArea(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              MediaQuery.of(ctx).size.height *
                                              0.88,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(
                                              ctx,
                                            ).viewInsets.bottom,
                                          ),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(24),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            child: const SingleChildScrollView(
                                              child: AccountHelpdeskCard(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Helpdesk',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
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
                                      horizontal: 10,
                                    ),
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
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added $_selectedQuantity x "${product.name}" to cart!',
                                  ),
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
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required Widget child,
    Color? iconColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: (iconColor ?? const Color(0xFF6A11CB)).withOpacity(
                    0.1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: iconColor ?? const Color(0xFF6A11CB),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSpecsTable(Map<String, String> specs) {
    if (specs.isEmpty) return const SizedBox.shrink();
    int index = 0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: specs.entries.map((entry) {
            final isEven = (index++) % 2 == 0;
            return Container(
              color: isEven ? const Color(0xFFF8FAFC) : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 6,
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
