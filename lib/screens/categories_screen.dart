import 'package:flutter/material.dart';
import 'package:hettys_shop/data/product_service.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/widgets/app_image.dart';
import 'package:hettys_shop/widgets/product_card.dart';

/// ============================================================================
/// CategoriesScreen
/// Coursework Concepts: StatefulWidget, Scaffold, AppBar, ListView, GridView,
/// Container, SizedBox, child & children, Page navigation with arguments
/// ============================================================================
/// Allows browsing by the coursework's 6 specified categories:
/// - Fashion
/// - Shoes
/// - Bags
/// - Accessories
/// - Beauty
/// - Electronics
///
/// Features both ListView and GridView layouts.
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // Active category selection ('All' or any of the 6 specific categories)
  String _activeCategory = 'Fashion';

  // Toggle layout mode between Grid and List view
  bool _isGridMode = true;

  // Coursework Category List with custom styling icons and descriptions
  final List<Map<String, dynamic>> _categoryData = [
    {
      'name': 'Fashion',
      'icon': Icons.checkroom,
      'color': const Color(0xFF6A11CB),
      'subtitle': 'Coats, blazers, sweaters & knitwear',
    },
    {
      'name': 'Shoes',
      'icon': Icons.snowshoeing_outlined,
      'color': const Color(0xFF2575FC),
      'subtitle': 'Sneakers, boots & athletic footwear',
    },
    {
      'name': 'Bags',
      'icon': Icons.luggage_outlined,
      'color': const Color(0xFFFF6B6B),
      'subtitle': 'Leather totes, backpacks & purses',
    },
    {
      'name': 'Accessories',
      'icon': Icons.watch_outlined,
      'color': const Color(0xFFFFA07A),
      'subtitle': 'Watches, jewelry & sunglasses',
    },
    {
      'name': 'Beauty',
      'icon': Icons.spa_outlined,
      'color': const Color(0xFFE91E63),
      'subtitle': 'Skincare, cosmetics & fragrances',
    },
    {
      'name': 'Electronics',
      'icon': Icons.devices_other,
      'color': const Color(0xFF00B4D8),
      'subtitle': 'Headphones, earbuds & smart watches',
    },
  ];

  List<Product> get _productsForCategory {
    return ProductService().products
        .where((p) => p.category.toLowerCase() == _activeCategory.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Coursework Concept: Scaffold with AppBar and body
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Product Categories',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          // Switch between GridView and ListView representation
          IconButton(
            icon: Icon(
              _isGridMode ? Icons.view_list_rounded : Icons.grid_view_rounded,
              color: theme.primaryColor,
            ),
            tooltip: _isGridMode
                ? 'Switch to List View'
                : 'Switch to Grid View',
            onPressed: () {
              setState(() {
                _isGridMode = !_isGridMode;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: ProductService(),
        builder: (context, _) => Column(
          children: [
            // ---------------- HORIZONTAL CATEGORY SELECTOR ----------------
            // Coursework Concept: Container with child and ListView
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 90,
                // Coursework Concept: ListView.builder
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categoryData.length,
                  itemBuilder: (context, index) {
                    final cat = _categoryData[index];
                    final isSelected = _activeCategory == cat['name'];
                    final Color catColor = cat['color'] as Color;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _activeCategory = cat['name'] as String;
                        });
                      },
                      child: Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? catColor
                                    : catColor.withOpacity(0.12),
                                shape: BoxShape.circle,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: catColor.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Icon(
                                cat['icon'] as IconData,
                                color: isSelected ? Colors.white : catColor,
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cat['name'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black87
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ---------------- CATEGORY INFO BAR ----------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        _activeCategory,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_productsForCategory.length} items',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _isGridMode ? 'Grid Layout' : 'List Layout',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- PRODUCT PRESENTATION (GRIDVIEW OR LISTVIEW) ----------------
            Expanded(
              child: _productsForCategory.isEmpty
                  ? Center(
                      child: Text(
                        'No products found in $_activeCategory',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  : _isGridMode
                  // Coursework Concept: GridView
                  ? GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.68,
                          ),
                      itemCount: _productsForCategory.length,
                      itemBuilder: (context, index) {
                        final product = _productsForCategory[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            // Coursework Concept: Page Navigation with Arguments
                            Navigator.pushNamed(
                              context,
                              '/product-details',
                              arguments: product,
                            );
                          },
                        );
                      },
                    )
                  // Coursework Concept: ListView
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _productsForCategory.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final product = _productsForCategory[index];
                        return _buildProductListTile(context, product);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget for ListView mode
  Widget _buildProductListTile(BuildContext context, Product product) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        // Coursework Concept: Page Navigation with Arguments
        Navigator.pushNamed(context, '/product-details', arguments: product);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 90,
                height: 90,
                color: const Color(0xFFF8FAFC),
                padding: const EdgeInsets.all(4),
                child: AppImage(
                  imagePath: product.image,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: product.inStock
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.inStock
                              ? 'In Stock (${product.stock})'
                              : 'Out of stock',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: product.inStock
                                ? Colors.green.shade800
                                : Colors.red.shade800,
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
