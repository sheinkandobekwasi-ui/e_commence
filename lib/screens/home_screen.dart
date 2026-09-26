import 'package:flutter/material.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/data/mock_data.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/widgets/category_chip.dart';
import 'package:hettys_shop/widgets/product_card.dart';
import 'package:hettys_shop/widgets/promo_banner.dart';

/// ============================================================================
/// HomeScreen
/// Coursework Concepts: StatefulWidget, Scaffold, AppBar, Container, SizedBox,
/// ListView, GridView, child & children, Page navigation with arguments
/// ============================================================================
/// Displays:
/// 1. Top AppBar with Shop branding and Cart shortcut
/// 2. Interactive Search Bar for filtering items
/// 3. Promotional banner carousel (horizontal ListView)
/// 4. Category selection chips (horizontal ListView)
/// 5. Featured product collection (2-column GridView)
class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToCategories;
  final VoidCallback? onNavigateToCart;

  const HomeScreen({
    super.key,
    this.onNavigateToCategories,
    this.onNavigateToCart,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Category icon helper
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Fashion':
        return Icons.checkroom;
      case 'Shoes':
        return Icons.snowshoeing_outlined;
      case 'Bags':
        return Icons.luggage_outlined;
      case 'Accessories':
        return Icons.watch_outlined;
      case 'Beauty':
        return Icons.spa_outlined;
      case 'Electronics':
        return Icons.devices_other;
      default:
        return Icons.all_inclusive;
    }
  }

  /// Filtered list of products based on selected category and active search query
  List<Product> get _filteredProducts {
    return MockData.sampleProducts.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Coursework Concept: Scaffold with AppBar & body
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // Coursework Concept: AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Hetty's Shop",
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'STORE',
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Discover trendy fashion, electronics & beauty',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          // Cart Shortcut button with reactive badge
          ListenableBuilder(
            listenable: CartService(),
            builder: (context, _) {
              final count = CartService().itemCount;
              return IconButton(
                onPressed: () {
                  if (widget.onNavigateToCart != null) {
                    widget.onNavigateToCart!();
                  } else {
                    Navigator.pushNamed(context, '/cart');
                  }
                },
                icon: count > 0
                    ? Badge(
                        label: Text('$count'),
                        backgroundColor: Colors.redAccent,
                        child: const Icon(Icons.shopping_bag_outlined,
                            color: Colors.black87),
                      )
                    : const Icon(Icons.shopping_bag_outlined,
                        color: Colors.black87),
                tooltip: 'Shopping Cart',
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Coursework Concept: body
      body: CustomScrollView(
        slivers: [
          // ---------------- SEARCH BAR ----------------
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                // Coursework Concept: Container child
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search clothes, shoes, electronics...',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF6A11CB)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ),

          // ---------------- PROMOTIONAL BANNERS ----------------
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Special Offers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Swipe for more',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Coursework Concept: ListView (horizontal scrolling)
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: MockData.promoBanners.length,
                    itemBuilder: (context, index) {
                      final promo = MockData.promoBanners[index];
                      return PromoBanner(
                        title: promo['title']!,
                        subtitle: promo['subtitle']!,
                        tag: promo['tag']!,
                        discount: promo['discount']!,
                        onShopNow: () {
                          // Filter to relevant category or scroll to grid
                          setState(() {
                            _selectedCategory = 'All';
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ---------------- PRODUCT CATEGORIES ----------------
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      if (widget.onNavigateToCategories != null)
                        GestureDetector(
                          onTap: widget.onNavigateToCategories,
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Coursework Concept: ListView (Horizontal category chips)
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: MockData.categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = MockData.categories[index];
                      final isSelected = _selectedCategory == category;
                      return CategoryChip(
                        label: category,
                        isSelected: isSelected,
                        icon: _getCategoryIcon(category),
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ---------------- FEATURED PRODUCTS HEADER ----------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCategory == 'All'
                        ? 'Featured Products'
                        : '$_selectedCategory Collection',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    '${_filteredProducts.length} items',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------------- PRODUCT GRIDVIEW ----------------
          // Coursework Concept: GridView (2-column layout)
          if (_filteredProducts.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      'No products found matching "$_searchQuery"',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _selectedCategory = 'All';
                        });
                      },
                      child: const Text('Reset Search & Filters'),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.74,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = _filteredProducts[index];
                    return ProductCard(
                      product: product,
                      // Coursework Concept: Page Navigation with Arguments
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/product-details',
                          arguments: product,
                        );
                      },
                    );
                  },
                  childCount: _filteredProducts.length,
                ),
              ),
            ),

          // Extra bottom padding for comfortable scrolling
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}
