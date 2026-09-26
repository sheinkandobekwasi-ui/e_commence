import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/models/user_profile.dart';

/// ============================================================================
/// Mock Data Repository
/// Coursework Concept: Mock Data & Separation of Concerns
/// ============================================================================
/// Provides static data for Hetty's Shop so the app functions entirely offline
/// without requiring an external backend or database server.
class MockData {
  /// Required Categories as per coursework guidelines:
  /// Fashion, Shoes, Bags, Accessories, Beauty, Electronics
  static const List<String> categories = [
    'All',
    'Fashion',
    'Shoes',
    'Bags',
    'Accessories',
    'Beauty',
    'Electronics',
  ];

  /// Promotional banner items displayed on the Home screen
  static const List<Map<String, String>> promoBanners = [
    {
      'title': 'Mid-Season Mega Sale!',
      'subtitle': 'Up to 50% OFF on all designer Fashion & Bags',
      'tag': 'LIMITED OFFER',
      'discount': '50% OFF',
    },
    {
      'title': 'New Tech Arrivals',
      'subtitle': 'Next-gen audio & wireless accessories are here',
      'tag': 'HOT DEAL',
      'discount': '30% OFF',
    },
    {
      'title': 'Glow & Glamour',
      'subtitle': 'Organic beauty & skincare essentials for everyday shine',
      'tag': 'TRENDING',
      'discount': '20% OFF',
    },
  ];

  /// Sample products: 18 items across 6 categories (Fashion, Shoes, Bags, Accessories, Beauty, Electronics)
  static final List<Product> sampleProducts = [
    // ---------------------- FASHION ----------------------
    Product(
      id: 'p1',
      name: 'Classic Oversized Wool Trench Coat',
      description:
          'A timeless winter staple tailored from premium double-faced wool blend. Features a relaxed notch collar, storm flap, and a detachable tie belt for custom styling.',
      price: 129.99,
      image:
          'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?auto=format&fit=crop&w=600&q=80',
      category: 'Fashion',
      stock: 14,
      rating: 4.8,
    ),
    Product(
      id: 'p2',
      name: 'Tailored Linen Blend Blazer',
      description:
          'Breathable European linen blazer cut in an effortlessly chic silhouette. Single-breasted button closure with functional patch pockets. Perfect for business casual looks.',
      price: 89.50,
      image:
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?auto=format&fit=crop&w=600&q=80',
      category: 'Fashion',
      stock: 9,
      rating: 4.6,
    ),
    Product(
      id: 'p3',
      name: 'Casual Ribbed Knit Cotton Sweater',
      description:
          'Ultra-soft 100% combed cotton knit with subtle drop shoulders and ribbed cuffs. Provides cozy warmth with an elevated, relaxed drape.',
      price: 49.00,
      image:
          'https://images.unsplash.com/photo-1576566588028-4147f3842f27?auto=format&fit=crop&w=600&q=80',
      category: 'Fashion',
      stock: 22,
      rating: 4.7,
    ),

    // ---------------------- SHOES ----------------------
    Product(
      id: 'p4',
      name: 'Minimalist Clean White Sneakers',
      description:
          'Handcrafted premium Italian leather sneakers with cushioned memory foam footbeds and durable stitched rubber soles. The everyday essential.',
      price: 78.00,
      image:
          'https://images.unsplash.com/photo-1560769629-975ec94e6a86?auto=format&fit=crop&w=600&q=80',
      category: 'Shoes',
      stock: 16,
      rating: 4.9,
    ),
    Product(
      id: 'p5',
      name: 'Heritage Leather Chelsea Boots',
      description:
          'Iconic pull-on Chelsea boots crafted with water-resistant oiled nubuck leather, elastic side gussets, and rugged lugged commando outsoles.',
      price: 135.00,
      image:
          'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?auto=format&fit=crop&w=600&q=80',
      category: 'Shoes',
      stock: 7,
      rating: 4.8,
    ),
    Product(
      id: 'p6',
      name: 'Air Cushion Performance Runners',
      description:
          'Engineered mesh running shoes featuring high-rebound responsive foam soles, heel stabilizer clip, and anti-slip traction treads.',
      price: 94.99,
      image:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=600&q=80',
      category: 'Shoes',
      stock: 19,
      rating: 4.7,
    ),

    // ---------------------- BAGS ----------------------
    Product(
      id: 'p7',
      name: 'Signature Structured Leather Tote',
      description:
          'Roomy full-grain pebbled leather tote with reinforced top handles, padded 15-inch laptop compartment, and gold-tone polished hardware.',
      price: 115.00,
      image:
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=600&q=80',
      category: 'Bags',
      stock: 11,
      rating: 4.9,
    ),
    Product(
      id: 'p8',
      name: 'Urban Commuter Waterproof Backpack',
      description:
          'Sleek matte PU weather-sealed backpack with roll-top buckle closure, hidden passport security pocket, and ergonomic airflow back padding.',
      price: 68.50,
      image:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=600&q=80',
      category: 'Bags',
      stock: 18,
      rating: 4.6,
    ),
    Product(
      id: 'p9',
      name: 'Quilted Chain Crossbody Bag',
      description:
          'Compact vegan leather evening purse with diamond quilt pattern, interlocking turn-lock clasp, and convertible woven chain shoulder strap.',
      price: 54.00,
      image:
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=600&q=80',
      category: 'Bags',
      stock: 15,
      rating: 4.7,
    ),

    // ---------------------- ACCESSORIES ----------------------
    Product(
      id: 'p10',
      name: 'Polarized Aviator Sunglasses',
      description:
          'Lightweight stainless steel frames with 100% UV400 polarized gradient scratch-resistant lenses. Includes protective case and microfiber cloth.',
      price: 38.00,
      image:
          'https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=600&q=80',
      category: 'Accessories',
      stock: 25,
      rating: 4.5,
    ),
    Product(
      id: 'p11',
      name: 'Chronograph Minimalist Wristwatch',
      description:
          'Japanese quartz movement encased in 40mm brushed rose gold casing with quick-release genuine Italian saddle leather wristband. Water resistant 5ATM.',
      price: 119.00,
      image:
          'https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&w=600&q=80',
      category: 'Accessories',
      stock: 8,
      rating: 4.9,
    ),
    Product(
      id: 'p12',
      name: '18K Gold Plated Paperclip Chain Necklace',
      description:
          'Modern hypoallergenic layered paperclip chain necklace dipped in 18k yellow gold with lobster clasp. Tarnish resistant and shower safe.',
      price: 32.50,
      image:
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=600&q=80',
      category: 'Accessories',
      stock: 30,
      rating: 4.8,
    ),

    // ---------------------- BEAUTY ----------------------
    Product(
      id: 'p13',
      name: 'Hydrating Botanical Facial Serum',
      description:
          'Formulated with multi-molecular hyaluronic acid, vitamin B5, and rosehip extract. Restores moisture barrier and delivers instant dewy radiance.',
      price: 36.00,
      image:
          'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?auto=format&fit=crop&w=600&q=80',
      category: 'Beauty',
      stock: 40,
      rating: 4.8,
    ),
    Product(
      id: 'p14',
      name: 'Velvet Matte Long-Wear Lipstick Duo',
      description:
          'Weightless, pigment-rich liquid lipstick infused with jojoba oil and vitamin E for a non-drying, smudge-proof 12-hour comfortable finish.',
      price: 24.00,
      image:
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?auto=format&fit=crop&w=600&q=80',
      category: 'Beauty',
      stock: 28,
      rating: 4.6,
    ),
    Product(
      id: 'p15',
      name: 'Artisan Sandalwood & Amber Scented Candle',
      description:
          'Hand-poured 100% natural soy wax candle with clean-burning crackling wooden wick. Notes of cedarwood, warm amber, and French lavender.',
      price: 26.50,
      image:
          'https://images.unsplash.com/photo-1603006905003-be475563bc59?auto=format&fit=crop&w=600&q=80',
      category: 'Beauty',
      stock: 17,
      rating: 4.7,
    ),

    // ---------------------- ELECTRONICS ----------------------
    Product(
      id: 'p16',
      name: 'Active Noise Cancelling Wireless Headphones',
      description:
          'Over-ear studio sound headphones with 40mm high-fidelity dynamic drivers, hybrid active noise cancellation, and up to 40 hours battery life.',
      price: 159.99,
      image:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=600&q=80',
      category: 'Electronics',
      stock: 12,
      rating: 4.9,
    ),
    Product(
      id: 'p17',
      name: 'Compact True Wireless Hi-Fi Earbuds',
      description:
          'Ergonomic Bluetooth 5.3 earbuds featuring environmental noise cancellation for crystal calls, IPX5 water resistance, and fast USB-C wireless charge case.',
      price: 69.99,
      image:
          'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=600&q=80',
      category: 'Electronics',
      stock: 20,
      rating: 4.7,
    ),
    Product(
      id: 'p18',
      name: 'Smart Fitness Tracker & Heart Rate Watch',
      description:
          'Vibrant AMOLED touch display with 24/7 continuous heart rate, SpO2 blood oxygen tracking, sleep analysis, and 50+ athletic workout modes.',
      price: 79.50,
      image:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80',
      category: 'Electronics',
      stock: 14,
      rating: 4.8,
    ),
  ];

  /// Default demo user profile for Hetty's Shop
  static const UserProfile defaultUser = UserProfile(
    name: 'Henrietta "Hetty" Mensah',
    email: 'hetty.mensah@university.edu',
    phone: '+233 24 555 0192',
    address: 'Block B, Hall of Residence, University Campus',
    city: 'Accra',
  );
}
