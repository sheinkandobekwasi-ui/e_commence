import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/data/mock_data.dart';
import 'package:hettys_shop/data/product_service.dart';
import 'package:hettys_shop/data/wishlist_service.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/widgets/app_image.dart';
import 'package:hettys_shop/widgets/category_chip.dart';
import 'package:hettys_shop/widgets/product_card.dart';
import 'package:url_launcher/url_launcher.dart';

/// ============================================================================
/// HomeScreen
/// Coursework Concepts: StatefulWidget, Scaffold, AppBar, CustomScrollView,
/// SliverToBoxAdapter, SliverGrid, PageView Carousel, Timer, url_launcher
/// ============================================================================
/// Features modern interactive dashboard layout:
/// 1. Top Search Bar with "Call to Order: 0599876242" hotline bar
/// 2. Interactive Auto-Scrolling Promotional Carousel with Page Indicator Dots
/// 3. "Essentials" Quick-Access Deals Cards (Flash Deals, Free Delivery, Campus Hub, Top Rated)
/// 4. Flash Sales Section with live countdown timer and horizontal product cards
/// 5. Horizontal Category Selection Chips
/// 6. Responsive 2-column Product Catalog Grid with Wishlist heart button
class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToCategories;
  final VoidCallback? onNavigateToCart;
  final VoidCallback? onNavigateToWishlist;

  const HomeScreen({
    super.key,
    this.onNavigateToCategories,
    this.onNavigateToCart,
    this.onNavigateToWishlist,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Promotional Carousel State
  late final PageController _pageController;
  int _currentCarouselIndex = 0;
  Timer? _carouselTimer;

  // Flash Sale Countdown State
  int _countdownSeconds = 3 * 3600 + 45 * 60 + 20; // 03:45:20
  Timer? _countdownTimer;

  final List<Map<String, dynamic>> _carouselBanners = [
    {
      'title': 'Mid-Season Mega Sale',
      'subtitle': 'Up to 50% OFF on all designer Fashion & Footwear',
      'tag': 'LIMITED OFFER',
      'discount': '50% OFF',
      'gradient': [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
      'category': 'Fashion',
    },
    {
      'title': 'Next-Gen Audio & Tech',
      'subtitle': 'Smartwatches, Wireless Earbuds & Gaming Headsets',
      'tag': 'CAMPUS HOT DEAL',
      'discount': '30% OFF',
      'gradient': [const Color(0xFF0F172A), const Color(0xFF1E293B)],
      'category': 'Electronics',
    },
    {
      'title': 'Premium Beauty & Glow',
      'subtitle': 'Facial serums, organic skincare & luxury fragrances',
      'tag': 'BEST SELLER',
      'discount': '25% OFF',
      'gradient': [const Color(0xFFBE185D), const Color(0xFFF43F5E)],
      'category': 'Beauty',
    },
    {
      'title': 'Sunyani Express Specials',
      'subtitle': 'Exclusive Ghana Cedis prices with instant MoMo checkout',
      'tag': 'BONO HUB',
      'discount': 'GH₵ DEALS',
      'gradient': [const Color(0xFF047857), const Color(0xFF10B981)],
      'category': 'All',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Auto-scroll promotional carousel every 4 seconds
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && _carouselBanners.isNotEmpty) {
        final nextIndex = (_currentCarouselIndex + 1) % _carouselBanners.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });

    // Countdown timer ticking every second
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _countdownSeconds = 4 * 3600; // Reset countdown
        }
      });
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _countdownTimer?.cancel();
    _pageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Launch Hotline phone call
  Future<void> _launchHotline() async {
    final uri = Uri.parse('tel:+233599876242');
    try {
      final launched = await launchUrl(uri);
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Call to Order: 0599876242 (+233 59 987 6242)'),
            backgroundColor: Color(0xFF2575FC),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Call to Order: 0599876242 (+233 59 987 6242)'),
            backgroundColor: Color(0xFF2575FC),
          ),
        );
      }
    }
  }

  /// Format countdown timer into hours : minutes : seconds
  String _formatDigits(int number) => number.toString().padLeft(2, '0');

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
    return ProductService().products.where((product) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  /// Sample products featured in the Flash Sales section
  List<Product> get _flashSaleProducts {
    final all = ProductService().products;
    if (all.length >= 6) {
      return all.sublist(0, 6);
    }
    return all;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hours = _countdownSeconds ~/ 3600;
    final minutes = (_countdownSeconds % 3600) ~/ 60;
    final seconds = _countdownSeconds % 60;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // ---------------- TOP APPBAR ----------------
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
                  "Shei Store",
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'STORE',
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Trendy fashion, electronics & beauty across Ghana',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 10.5,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          // Wishlist Shortcut Icon with Badge
          ListenableBuilder(
            listenable: WishlistService(),
            builder: (context, _) {
              final wishlistCount = WishlistService().itemCount;
              return IconButton(
                tooltip: 'My Wishlist',
                onPressed: () {
                  if (widget.onNavigateToWishlist != null) {
                    widget.onNavigateToWishlist!();
                  } else {
                    Navigator.pushNamed(context, '/wishlist');
                  }
                },
                icon: wishlistCount > 0
                    ? Badge(
                        label: Text('$wishlistCount'),
                        backgroundColor: Colors.redAccent,
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.redAccent,
                        ),
                      )
                    : const Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.black87,
                      ),
              );
            },
          ),

          // Cart Shortcut button with reactive badge
          ListenableBuilder(
            listenable: CartService(),
            builder: (context, _) {
              final count = CartService().itemCount;
              return IconButton(
                tooltip: 'Shopping Cart',
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
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.black87,
                        ),
                      )
                    : const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.black87,
                      ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ---------------- DASHBOARD BODY ----------------
      body: ListenableBuilder(
        listenable: ProductService(),
        builder: (context, _) => CustomScrollView(
          controller: _scrollController,
          slivers: [
            // ---------------- 1. SEARCH BAR & CALL TO ORDER HOTLINE BAR ----------------
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
                child: Column(
                  children: [
                    // Search Input
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search clothes, shoes, tech, beauty...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF6A11CB),
                          ),
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
                            horizontal: 16,
                            vertical: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // "Call to Order: 0599876242" Interactive Hotline Bar
                    InkWell(
                      onTap: _launchHotline,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 6,
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
                              child: const Icon(
                                Icons.phone_in_talk,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text.rich(
                                    TextSpan(
                                      text: 'Call to Order: ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '0599876242',
                                          style: TextStyle(
                                            color: Color(0xFF38BDF8),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12.5,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  Text(
                                    'Instant phone order assist • All 16 Ghana regions',
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'CALL',
                                    style: TextStyle(
                                      color: Color(0xFF38BDF8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFF38BDF8),
                                    size: 9,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---------------- 2. PROMOTIONAL CAROUSEL WITH PAGE INDICATORS ----------------
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Special Offers',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          'Swipe for deals',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 155,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                      itemCount: _carouselBanners.length,
                      itemBuilder: (context, index) {
                        final banner = _carouselBanners[index];
                        return _buildCarouselSlide(banner);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Carousel Animated Page Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_carouselBanners.length, (index) {
                      final isActive = index == _currentCarouselIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 5.5,
                        width: isActive ? 22 : 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? theme.primaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // ---------------- 3. "ESSENTIALS" QUICK-ACCESS CARDS ----------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Essentials & Perks',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          'Shei Guarantees',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Grid of 4 rounded quick-access cards
                    Row(
                      children: [
                        // Card 1: Flash Deals
                        Expanded(
                          child: _buildEssentialCard(
                            title: 'Flash Deals',
                            subtitle: 'Up to 50% Off',
                            icon: Icons.bolt_rounded,
                            gradient: const [
                              Color(0xFFFF512F),
                              Color(0xFFDD2476),
                            ],
                            onTap: () {
                              _scrollController.animateTo(
                                260,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Card 2: Free Delivery
                        Expanded(
                          child: _buildEssentialCard(
                            title: 'Delivery',
                            subtitle: '16 Regions',
                            icon: Icons.local_shipping_outlined,
                            gradient: const [
                              Color(0xFF10B981),
                              Color(0xFF059669),
                            ],
                            onTap: () {
                              _showPerkModal(
                                context,
                                'Nationwide Ghana Delivery',
                                'We deliver to all 16 regions of Ghana with express dispatch from Accra, Kumasi & Sunyani hubs. Free delivery on orders over GH₵ 300!',
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Card 3: MoMo Pay
                        Expanded(
                          child: _buildEssentialCard(
                            title: 'MoMo Pay',
                            subtitle: 'MTN / Telecel',
                            icon: Icons.account_balance_wallet_outlined,
                            gradient: const [
                              Color(0xFF2575FC),
                              Color(0xFF6A11CB),
                            ],
                            onTap: () {
                              _showPerkModal(
                                context,
                                'Mobile Money & Cedis Payments',
                                'Shei Store strictly transacts in Ghana Cedis (GH₵). We accept MTN MoMo, Telecel Cash, AirtelTigo Money, and Cash on Delivery.',
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Card 4: 24/7 Hotline
                        Expanded(
                          child: _buildEssentialCard(
                            title: 'Helpdesk',
                            subtitle: '0599876242',
                            icon: Icons.headset_mic_outlined,
                            gradient: const [
                              Color(0xFFF59E0B),
                              Color(0xFFD97706),
                            ],
                            onTap: _launchHotline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ---------------- 4. FLASH SALES SECTION ----------------
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 18),
                padding: const EdgeInsets.symmetric(vertical: 14),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flash Sale Header with Live Countdown Timer
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.flash_on_rounded,
                                  color: Colors.redAccent,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Flash Sale',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Countdown Badges
                              _buildCountdownBadge(_formatDigits(hours)),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  ':',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              _buildCountdownBadge(_formatDigits(minutes)),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  ':',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              _buildCountdownBadge(_formatDigits(seconds)),
                            ],
                          ),

                          // See All action
                          InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCategory = 'All';
                                _searchQuery = '';
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  'See All',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.chevron_right,
                                  size: 16,
                                  color: theme.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Horizontally scrollable list of discounted product cards
                    SizedBox(
                      height: 235,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _flashSaleProducts.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final product = _flashSaleProducts[index];
                          return _buildFlashSaleCard(context, product, index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---------------- 5. PRODUCT CATEGORIES ----------------
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 17,
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
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Horizontal Category Chips
                  SizedBox(
                    height: 42,
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

            // ---------------- 6. FEATURED PRODUCTS HEADER ----------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory == 'All'
                          ? 'Featured Products'
                          : '$_selectedCategory Collection',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      '${_filteredProducts.length} items in GH₵',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---------------- 7. PRODUCT GRIDVIEW ----------------
            if (_filteredProducts.isEmpty)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 55,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No products found matching "$_searchQuery"',
                        style: TextStyle(
                          fontSize: 14.5,
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
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = _filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/product-details',
                          arguments: product,
                        );
                      },
                    );
                  }, childCount: _filteredProducts.length),
                ),
              ),

            // Extra bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  /// Slide widget inside Promotional Carousel
  Widget _buildCarouselSlide(Map<String, dynamic> banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: banner['gradient'] as List<Color>,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (banner['gradient'][0] as Color).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top tag and discount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  banner['tag'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  banner['discount'] as String,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          // Titles
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                banner['title'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                banner['subtitle'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 11,
                ),
              ),
            ],
          ),

          // Action button
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                final targetCategory = banner['category'] as String;
                setState(() {
                  _selectedCategory = targetCategory;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Shop Now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(Icons.arrow_forward_rounded, size: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Essentials Quick-Access Card
  Widget _buildEssentialCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Dark pill badge for Flash Sale countdown timer
  Widget _buildCountdownBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Discounted Card for horizontal Flash Sale list
  Widget _buildFlashSaleCard(BuildContext context, Product product, int index) {
    final theme = Theme.of(context);
    final discountPercent = (index % 3 == 0) ? 35 : ((index % 2 == 0) ? 25 : 40);
    final originalPrice = product.price * (1 + discountPercent / 100);

    return Container(
      width: 154,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Discount Tag & Wishlist Button
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/product-details',
                    arguments: product,
                  );
                },
                child: Container(
                  height: 110,
                  width: double.infinity,
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                  ),
                  child: AppImage(
                    imagePath: product.image,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
              ),

              // Discount Tag
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '-$discountPercent%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Wishlist Heart Button
              Positioned(
                top: 5,
                right: 5,
                child: ListenableBuilder(
                  listenable: WishlistService(),
                  builder: (context, _) {
                    final isWishlisted =
                        WishlistService().isWishlisted(product.id);
                    return InkWell(
                      onTap: () {
                        WishlistService().toggleWishlist(product);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isWishlisted
                                  ? 'Removed "${product.name}" from Wishlist'
                                  : 'Added "${product.name}" to Wishlist ❤️',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isWishlisted
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          size: 14,
                          color: isWishlisted
                              ? Colors.redAccent
                              : const Color(0xFF64748B),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Details
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),

                // Prices
                Row(
                  children: [
                    Text(
                      product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'GH₵ ${originalPrice.toStringAsFixed(0)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9.5,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Stock progress & quick add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '⚡ ${product.stock} left',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        CartService().addItem(product, quantity: 1);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added "${product.name}" to cart!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          size: 11,
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
    );
  }

  /// Informational modal for perks
  void _showPerkModal(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        content: Text(description, style: const TextStyle(fontSize: 13, height: 1.4)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A11CB),
              foregroundColor: Colors.white,
            ),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
