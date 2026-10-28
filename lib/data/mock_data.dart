import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/models/user_profile.dart';

/// ============================================================================
/// Mock Data Repository
/// Coursework Concept: Mock Data & Separation of Concerns
/// ============================================================================
/// Provides static data for Hetty's Shop, local asset definitions, and
/// an expanded catalog of high-quality eCommerce products formatted in Ghana Cedis (GH₵).
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

  /// Available local image asset options for the Admin Panel & Products
  static const List<String> availableLocalAssets = [
    'assets/images/sample_product.png',
    'assets/images/trench_coat.png',
    'assets/images/linen_blazer.png',
    'assets/images/sweater.png',
    'assets/images/sneakers.png',
    'assets/images/chelsea_boots.png',
    'assets/images/runners.png',
    'assets/images/tote_bag.png',
    'assets/images/backpack.png',
    'assets/images/crossbody.png',
    'assets/images/sunglasses.png',
    'assets/images/wristwatch.png',
    'assets/images/necklace.png',
    'assets/images/facial_serum.png',
    'assets/images/lipstick.png',
    'assets/images/candle.png',
    'assets/images/headphones.png',
    'assets/images/earbuds.png',
    'assets/images/smartwatch.png',
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
      'subtitle': 'Next-gen audio & wireless accessories are here in Ghana',
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

  /// Expanded product catalog: 36 items across 6 categories
  /// Configured with high-resolution eCommerce product image URLs and local asset fallbacks.
  /// All prices formatted in Ghana Cedis (GH₵).
  static final List<Product> sampleProducts = [
    // -------------------------------------------------------------------------
    // 1. FASHION
    // -------------------------------------------------------------------------
    Product(
      id: 'p1',
      name: 'Classic Oversized Wool Trench Coat',
      description:
          'A timeless winter and rainy season staple tailored from premium double-faced wool blend. Features a relaxed notch collar, storm flap, and a detachable tie belt for custom styling.',
      price: 129.0,
      image:
          'https://images.unsplash.com/photo-1544923246-77307dd654cb?auto=format&fit=crop&w=600&q=80',
      category: 'Fashion',
      stock: 14,
      rating: 4.8,
      functionality:
          'Engineered for cold-weather layering and wet urban environments. Includes double-breasted storm closure, removable belt cinch for wind protection, and deep fleece-lined handwarmer pockets.',
      specifications: {
        'Material Composition':
            '70% Double-Faced Merino Wool Blend, 30% Thermal Poly',
        'Weave & Weight': 'Heavyweight 480 GSM Melton Weave',
        'Lining': 'Anti-static breathable satin twill',
        'Hardware': 'Horn-effect reinforced anchor buttons',
        'Pockets': '2 deep exterior fleece pockets, 1 interior breast pocket',
      },
      durability:
          'Pill-resistant finish with weather-guard hydrophobic coating. Reinforced double-stitched stress seams rated for 5+ seasons of continuous cold-weather wear.',
    ),
    Product(
      id: 'p2',
      name: 'Tailored Linen Blend Blazer',
      description:
          'Breathable European linen blazer cut in an effortlessly chic silhouette. Single-breasted button closure with functional patch pockets. Perfect for business casual looks in Ghana’s tropical climate.',
      price: 89.0,
      image:
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?auto=format&fit=crop&w=600&q=80',
      category: 'Fashion',
      stock: 9,
      rating: 4.6,
      functionality:
          'All-day smart-casual and formal wear. Engineered with breathable open-weave linen to provide cooling airflow in tropical and warm climates, featuring functional internal passport pockets.',
      specifications: {
        'Fabric Blend': '65% European Flax Linen, 35% Cotton Slub',
        'Construction': 'Half-canvassed chest piece with soft shoulder pads',
        'Pockets':
            '2 front patch pockets, 1 welt chest pocket, 2 internal security slots',
        'Fit Profile': 'Modern structured relaxed fit',
        'Ventilation': 'Dual rear vents for sitting comfort',
      },
      durability:
          'Pre-washed and pre-shrunk linen fibers prevent shrinkage. High tensile yarn prevents tearing at elbow and armhole tension zones.',
    ),
    Product(
      id: 'p3',
      name: 'Casual Ribbed Knit Cotton Sweater',
      description:
          'Ultra-soft 100% combed cotton knit with subtle drop shoulders and ribbed cuffs. Provides cozy warmth with an elevated, relaxed drape for everyday comfort.',
      price: 49.0,
      image:
          'https://images.unsplash.com/photo-1576566588028-4147f3842f27?auto=format&fit=crop&w=600&q=80',
      category: 'Fashion',
      stock: 22,
      rating: 4.7,
      functionality:
          'Versatile pullover designed for effortless daily layering. Features four-way natural stretch, ribbed crew neck collar, and shape-retaining elasticized cuffs.',
      specifications: {
        'Fiber': '100% Ring-Spun Long-Staple Combed Cotton',
        'Knit Gauge': '7-gauge fisherman rib knit',
        'Colorfastness': 'Oeko-Tex Standard 100 eco-dyed non-fade reactive dye',
        'Weight': '360 GSM mid-heavyweight',
        'Collar & Hem': '1x1 Spandex-reinforced ribbing',
      },
      durability:
          'Anti-snag knit weave maintains shape after repeated machine washes without pilling or color loss.',
    ),
    Product(
      id: 'p4',
      name: 'Slim-Fit Stretch Selvedge Denim Jeans',
      description:
          'Crafted from premium 12.5 oz Japanese indigo selvedge denim woven with a touch of elastane for flexibility. Tailored slim fit through thigh and leg.',
      price: 65.0,
      image:
          'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=600&q=80',
      category: 'Fashion',
      stock: 18,
      rating: 4.8,
      functionality:
          'Comfortable everyday denim with 5-pocket utility, reinforced belt loops, and hidden coin pocket. Natural stretch allows unrestricted movement.',
      specifications: {
        'Denim Weight': '12.5 oz Ring-Spun Cotton Selvedge',
        'Composition': '98% Organic Cotton, 2% Spandex',
        'Hardware': 'Antique brass rivets and custom shank button',
        'Closure': 'Heavy-duty YKK brass zipper fly',
      },
      durability:
          'Chain-stitched flat-felled inseams and bar-tacked stress pockets ensure years of heavy daily wear without blowout.',
    ),
    Product(
      id: 'p5',
      name: 'Bohemian Floral Summer Maxi Dress',
      description:
          'Flowing tiers of lightweight woven viscose adorned with botanical prints. Features an elasticized smocked bodice and breezy flutter sleeves.',
      price: 58.0,
      image:
          'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?auto=format&fit=crop&w=600&q=80',
      category: 'Fashion',
      stock: 15,
      rating: 4.7,
      functionality:
          'Effortless warm-weather daytime and evening outfit. Smocked bodice self-adjusts to body contours while tiered hem provides dramatic movement and cooling ventilation.',
      specifications: {
        'Fabric': '100% Breathable Eco-Vero Viscose Twill',
        'Silhouette': 'A-Line tiered floor-length maxi',
        'Neckline': 'Square neck with ruffled elastic edges',
        'Pockets': 'Hidden deep side-seam pockets',
      },
      durability:
          'Fade-resistant digital reactive dye preserves rich botanical shades through sunshine and wash cycles.',
    ),
    Product(
      id: 'p6',
      name: 'Premium Pima Cotton Polo Shirt',
      description:
          'Silky smooth Peruvian Pima cotton knit polo with collar that refuses to roll. Subtle mother-of-pearl buttons and tailored athletic fit.',
      price: 42.0,
      image:
          'https://images.unsplash.com/photo-1581655353564-df123a1eb820?auto=format&fit=crop&w=600&q=80',
      category: 'Fashion',
      stock: 25,
      rating: 4.6,
      functionality:
          'Ideal smart-casual essential for office, university, or weekend outings. Naturally breathable and moisture-wicking in hot weather.',
      specifications: {
        'Material': '100% Long-Staple Peruvian Pima Cotton Piqué',
        'Buttons': 'Genuine iridescent shell buttons',
        'Fit': 'Modern tailored athletic cut with side vent hems',
      },
      durability:
          'Double-twisted yarn resists torquing and twisting in the wash, retaining crisp collar form.',
    ),

    // -------------------------------------------------------------------------
    // 2. SHOES
    // -------------------------------------------------------------------------
    Product(
      id: 'p7',
      name: 'Minimalist Clean White Sneakers',
      description:
          'Handcrafted premium Italian calfskin leather sneakers with cushioned memory foam footbeds and durable stitched rubber cupsole. The versatile everyday essential.',
      price: 78.0,
      image:
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=600&q=80',
      category: 'Shoes',
      stock: 16,
      rating: 4.9,
      functionality:
          'Ergonomic daily walking sneakers equipped with high-rebound dual-density EVA insoles and shock-absorbing memory foam footbeds for 10,000+ steps daily comfort.',
      specifications: {
        'Upper Material': 'Full-Grain Italian Calfskin Leather',
        'Outsole': '360-degree stitched vulcanized natural rubber',
        'Insole': 'Removable orthotic memory foam with antimicrobial lining',
        'Eyelets': 'Brass-reinforced hidden eyelets',
        'Laces': '100% Waxed woven organic cotton',
      },
      durability:
          'Margom-style cupsole stitched directly to upper prevents sole separation. Abrasion-resistant tread delivers 2+ years of daily street traction.',
    ),
    Product(
      id: 'p8',
      name: 'Heritage Leather Chelsea Boots',
      description:
          'Iconic pull-on Chelsea boots crafted with water-resistant oiled nubuck leather, elastic side gussets, and rugged lugged commando outsoles.',
      price: 135.0,
      image:
          'https://images.unsplash.com/photo-1638247025967-b4e38f787b76?auto=format&fit=crop&w=600&q=80',
      category: 'Shoes',
      stock: 7,
      rating: 4.8,
      functionality:
          'All-weather slip-on boots with dual elastic side gores and heavy-duty nylon pull tabs for rapid step-in convenience and ankle stability.',
      specifications: {
        'Leather': '2.2mm Water-Resistant Oiled Pull-Up Nubuck Leather',
        'Construction': 'Goodyear Welted 360-degree resolable construction',
        'Sole': 'Lugged Commando Vibram-style non-slip rubber outsoles',
        'Shank': 'Tempered steel shank for arch support',
        'Lining': 'Full breathable pigskin leather lining',
      },
      durability:
          'Resolable Goodyear welt ensures a lifetime boot. Weather-sealed welt prevents water and mud ingress on rough outdoor terrains.',
    ),
    Product(
      id: 'p9',
      name: 'Air Cushion Performance Runners',
      description:
          'Engineered mesh running shoes featuring high-rebound responsive foam soles, heel stabilizer clip, and anti-slip traction treads.',
      price: 95.0,
      image:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=600&q=80',
      category: 'Shoes',
      stock: 19,
      rating: 4.7,
      functionality:
          'High-performance running shoe engineered for road running, track training, and active athletic lifestyles. Provides energy-return responsive bounce with each stride.',
      specifications: {
        'Upper': 'Seamless Jacquard engineered mesh with TPU toe bumper',
        'Midsole': 'Nitrogen-infused supercritical bouncy foam',
        'Drop': '8mm heel-to-toe ergonomic drop',
        'Weight': '245g ultra-lightweight',
        'Traction': 'Zonal carbon rubber road grip studs',
      },
      durability:
          'High-abrasion carbon rubber outsole compound tested for 800+ kilometers of road running durability.',
    ),
    Product(
      id: 'p10',
      name: 'Hand-Stitched Italian Suede Loafers',
      description:
          'Velvety soft suede slip-on driving loafers accented with a leather strap penny bar and flexible studded rubber pebble sole.',
      price: 110.0,
      image:
          'https://images.unsplash.com/photo-1533867617858-e7b97e060509?auto=format&fit=crop&w=600&q=80',
      category: 'Shoes',
      stock: 12,
      rating: 4.8,
      functionality:
          'Sophisticated casual shoe that slips on effortlessly without socks. Moccasin tubular construction envelopes foot in glove-like softness.',
      specifications: {
        'Upper': 'Water-repellent treated Italian calf suede',
        'Insole': 'Cushioned calfskin footbed with heel cup padding',
        'Outsole': 'Segmented rubber gommino pebble driving sole',
      },
      durability:
          'Hand-sewn apron stitching with reinforced wax cord prevents blowout under flex.',
    ),
    Product(
      id: 'p11',
      name: 'High-Top Canvas Streetwear Sneakers',
      description:
          'Classic high-top silhouette crafted from heavy 14 oz duck canvas with vulcanized rubber cap toe and retro side stripe.',
      price: 55.0,
      image:
          'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?auto=format&fit=crop&w=600&q=80',
      category: 'Shoes',
      stock: 22,
      rating: 4.6,
      functionality:
          'Versatile casual lifestyle shoe providing ankle support, breathable cotton lining, and waffle traction grip.',
      specifications: {
        'Material': '14 oz Heavy-Duty Woven Cotton Duck Canvas',
        'Sole': 'Vulcanized gum rubber with diamond tread',
        'Ankle Collar': 'Padded canvas collar with dual medial eyelets',
      },
      durability:
          'Double-wrapped foxing tape and reinforced toe bumper withstand skate and street wear.',
    ),
    Product(
      id: 'p12',
      name: 'Lightweight Breathable Trail Running Shoes',
      description:
          'Rugged trail shoes equipped with deep multidirectional 5mm lugs, rock protection plate, and quick-lace drawstring system.',
      price: 88.0,
      image:
          'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?auto=format&fit=crop&w=600&q=80',
      category: 'Shoes',
      stock: 15,
      rating: 4.7,
      functionality:
          'All-terrain grip for rocky paths, dirt trails, and wet grass. Protective TPU mudguard shields toes from roots and sharp rocks.',
      specifications: {
        'Grip': '5mm Contagrip rubber chevron lugs',
        'Rock Plate': 'Segmented ballistic TPU forefoot rock shield',
        'Lacing': 'Kevlar quick-lace cord with tongue lace garage',
      },
      durability:
          'Ripstop ballistic mesh upper prevents punctures and tearing on brush trails.',
    ),

    // -------------------------------------------------------------------------
    // 3. BAGS
    // -------------------------------------------------------------------------
    Product(
      id: 'p13',
      name: 'Signature Structured Leather Tote',
      description:
          'Roomy full-grain pebbled leather tote with reinforced top handles, padded 15-inch laptop compartment, and gold-tone polished hardware.',
      price: 115.0,
      image:
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=600&q=80',
      category: 'Bags',
      stock: 11,
      rating: 4.9,
      functionality:
          'Professional business and travel carryall with padded compartment accommodating up to 16-inch laptops, key leash, and zippered RFID-blocking document compartment.',
      specifications: {
        'Material': '100% Genuine Top-Grain Pebbled Bovine Leather',
        'Hardware': 'Solid electroplated brass zippers and metal base feet',
        'Capacity': '18.5 Liters with triple-divided internal layout',
        'Strap Drop': '10.5 inches reinforced dual shoulder drop',
        'Base': 'Reinforced bottom board with 4 protective metal studs',
      },
      durability:
          'Bar-tack cross-stitched handle anchor points hold up to 15 kg without strain. Scratch-resistant coated pebble grain finish.',
    ),
    Product(
      id: 'p14',
      name: 'Urban Commuter Waterproof Backpack',
      description:
          'Sleek matte PU weather-sealed backpack with roll-top buckle closure, hidden passport security pocket, and ergonomic airflow back padding.',
      price: 68.0,
      image:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=600&q=80',
      category: 'Bags',
      stock: 18,
      rating: 4.6,
      functionality:
          'Weather-tight commuter pack featuring roll-top buckle closure, TSA-compliant clamshell opening, exterior water bottle pocket, and hidden lumbar passport pocket.',
      specifications: {
        'Outer Fabric': '900D Matte TPU-Laminated Water-Sealed Ballistic Poly',
        'Zippers': 'YKK Aquaguard waterproof welded zip tracks',
        'Backing': '3D Air-mesh ergonomic padded airflow channel',
        'Dimensions': '48cm x 30cm x 15cm (22L capacity)',
        'Laptop Sleeve': 'Suspended false-bottom fleece padded 15.6" sleeve',
      },
      durability:
          'IPX4 splash and torrential rain proof. Tear-resistant Ripstop base prevents punctures from gravel and coarse floor surfaces.',
    ),
    Product(
      id: 'p15',
      name: 'Quilted Chain Crossbody Bag',
      description:
          'Compact vegan leather evening purse with diamond quilt pattern, interlocking turn-lock clasp, and convertible woven chain shoulder strap.',
      price: 54.0,
      image:
          'https://images.unsplash.com/photo-1566150905458-1bf1fc113f0d?auto=format&fit=crop&w=600&q=80',
      category: 'Bags',
      stock: 15,
      rating: 4.7,
      functionality:
          'Compact evening and daily crossbody with convertible dual-chain strap (wearable as long crossbody or double-chain shoulder bag) and turnlock security clasp.',
      specifications: {
        'Shell': 'Ultra-soft vegan PU leather with diamond quilt stitching',
        'Hardware': 'High-gloss polished gold-tone alloy chain',
        'Interior': 'Dual accordion compartments with center zipper divider',
        'Dimensions': '22cm x 15cm x 7cm',
        'Strap Length': '120cm full drop (convertible to 65cm double)',
      },
      durability:
          'Tarnish-free multi-layer electroplated chain withstands skin contact and humidity without fading or peeling.',
    ),
    Product(
      id: 'p16',
      name: 'Vintage Handcrafted Leather Travel Duffle',
      description:
          'Spacious weekender duffle made from rich vegetable-tanned oil-waxed leather with detachable padded shoulder strap and shoe compartment.',
      price: 145.0,
      image:
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=600&q=80',
      category: 'Bags',
      stock: 8,
      rating: 4.9,
      functionality:
          'Airline carry-on approved 45L travel bag with dedicated ventilated side shoe compartment and exterior luggage trolley pass-through sleeve.',
      specifications: {
        'Leather': 'Full-Grain Oil Waxed Crazy Horse Cowhide Leather',
        'Capacity': '45 Liters (52cm x 28cm x 26cm)',
        'Lining': 'Heavyweight 16 oz cotton twill canvas lining',
        'Hardware': 'Antiqued solid bronze hardware and dual YKK #10 zippers',
      },
      durability:
          'Develops a deep, rich patina with age. Copper-riveted stress points support up to 25 kg loads.',
    ),
    Product(
      id: 'p17',
      name: 'Anti-Theft Compact Crossbody Sling Bag',
      description:
          'Ergonomic unisex chest sling bag with hidden anti-theft zipper, built-in USB charging port, and water-resistant coated Oxford fabric.',
      price: 38.0,
      image:
          'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?auto=format&fit=crop&w=600&q=80',
      category: 'Bags',
      stock: 24,
      rating: 4.6,
      functionality:
          'Hands-free carry for campus, cycling, and travel. Quick-release magnetic Fidlock buckle strap flips easily to either shoulder.',
      specifications: {
        'Material': 'High-Density Water-Repellent Oxford Fabric',
        'Weight': '350 grams ultra-light',
        'Features': 'Integrated USB-A charging port, hidden back security pocket',
      },
      durability:
          'Slash-resistant interior wire reinforcement mesh prevents quick-slash pickpocketing.',
    ),
    Product(
      id: 'p18',
      name: 'Minimalist Canvas Everyday Shopper Bag',
      description:
          'Heavy 16 oz organic cotton canvas tote with interior zipped pocket, key hook, and reinforced webbing shoulder handles.',
      price: 28.0,
      image:
          'https://images.unsplash.com/photo-1597633425046-08f5110420b5?auto=format&fit=crop&w=600&q=80',
      category: 'Bags',
      stock: 35,
      rating: 4.5,
      functionality:
          'Eco-friendly grocery, book, and daily beach carryall. Stands upright with wide gusseted base.',
      specifications: {
        'Fabric': '100% GOTS-Certified Unbleached Organic Heavy Canvas',
        'Dimensions': '38cm x 34cm x 12cm',
        'Handles': 'Double-stitched cotton webbing handles (28cm drop)',
      },
      durability:
          'Machine washable canvas with reinforced box-X handle stitching tested to 18 kg.',
    ),

    // -------------------------------------------------------------------------
    // 4. ACCESSORIES
    // -------------------------------------------------------------------------
    Product(
      id: 'p19',
      name: 'Polarized Aviator Sunglasses',
      description:
          'Lightweight surgical stainless steel frames with 100% UV400 polarized gradient scratch-resistant lenses. Includes protective case and microfiber cloth.',
      price: 38.0,
      image:
          'https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=600&q=80',
      category: 'Accessories',
      stock: 25,
      rating: 4.5,
      functionality:
          'Glare-reduction aviator eyewear engineered for sunny outdoor driving, beach, and daily eye protection. Filters 99.9% of reflective water and road glare.',
      specifications: {
        'Lens Technology':
            '9-Layer Triacetate TAC Polarized with UV400 UV-A/B block',
        'Frame': 'Aircraft-grade corrosion-resistant surgical stainless steel',
        'Hinges': 'Flexible spring hinges with 15-degree over-flex tolerance',
        'Pads': 'Hypoallergenic soft medical silicone nose pads',
        'Weight': '22 grams featherlight frame',
      },
      durability:
          'Impact-resistant shatterproof lenses with oleophobic and anti-scratch hard coatings.',
    ),
    Product(
      id: 'p20',
      name: 'Chronograph Minimalist Wristwatch',
      description:
          'Japanese quartz movement encased in 40mm brushed rose gold casing with quick-release genuine Italian saddle leather wristband. Water resistant 5ATM.',
      price: 119.0,
      image:
          'https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&w=600&q=80',
      category: 'Accessories',
      stock: 8,
      rating: 4.9,
      functionality:
          'Dual-subdial quartz chronograph featuring precise stop-second timing, date calendar window at 4 o’clock, and quick-release strap interchangeable mechanism.',
      specifications: {
        'Movement': 'Japanese Miyota Caliber Quartz Chronograph',
        'Case': '316L Surgical Stainless Steel (40mm diameter, 10mm thickness)',
        'Crystal': 'Sapphire-coated scratch-resistant mineral glass',
        'Water Resistance': '5 ATM / 50 meters (swimming, rain, shower safe)',
        'Strap': '20mm Genuine vegetable-tanned Italian saddle leather',
      },
      durability:
          '316L marine-grade steel resists perspiration corrosion. 3-year SR920SW battery life.',
    ),
    Product(
      id: 'p21',
      name: '18K Gold Plated Paperclip Chain Necklace',
      description:
          'Modern hypoallergenic layered paperclip chain necklace dipped in 18k yellow gold with lobster clasp. Tarnish resistant and shower safe.',
      price: 32.0,
      image:
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=600&q=80',
      category: 'Accessories',
      stock: 30,
      rating: 4.8,
      functionality:
          'Modern layering necklace that can be worn solo, clipped at any link for customizable choker or princess lengths, or paired with favorite pendants.',
      specifications: {
        'Plating': '2.5 Micron 18-Karat Real Yellow Gold Vermeil',
        'Core Metal':
            'Hypoallergenic 316L Stainless Steel (Nickel & Lead Free)',
        'Chain Length': '18 inches + 2 inch extender link',
        'Clasp': 'Heavy-duty lobster claw clasp',
        'Link Size': '4mm x 12mm elongated rectangular links',
      },
      durability:
          'E-coat anti-tarnish protective sealing allows shower, exercise, and humidity wear without turning skin green or oxidizing.',
    ),
    Product(
      id: 'p22',
      name: 'RFID-Blocking Slim Bifold Leather Wallet',
      description:
          'Ultra-slim front-pocket bifold wallet crafted from full-grain saddle leather. Holds 8 cards, folded Ghana Cedi notes, and includes an ID quick-thumb slot.',
      price: 35.0,
      image:
          'https://images.unsplash.com/photo-1627123424574-724758594e93?auto=format&fit=crop&w=600&q=80',
      category: 'Accessories',
      stock: 20,
      rating: 4.7,
      functionality:
          'Pocket-friendly everyday carry with aerospace-grade Faraday lining shielding cards from unauthorized 13.56MHz contactless RFID scanners.',
      specifications: {
        'Material': 'Vegetable-Tanned Full-Grain Cowhide Leather',
        'Thickness': 'Only 8mm when unloaded',
        'Capacity': '6 card slots, 2 hidden slip pockets, 1 cash divider',
      },
      durability:
          'Turned-edge construction and nylon bonded thread prevent seam stretching over years of daily pocket friction.',
    ),
    Product(
      id: 'p23',
      name: 'Sterling Silver Minimalist Band Ring',
      description:
          'Subtle brushed comfort-fit band forged from pure 925 sterling silver with polished beveled inner edges. Unisex timeless design.',
      price: 28.0,
      image:
          'https://images.unsplash.com/photo-1605100804763-247f67b3557e?auto=format&fit=crop&w=600&q=80',
      category: 'Accessories',
      stock: 22,
      rating: 4.6,
      functionality:
          'All-day comfort ring that slips easily over knuckles. Rhodium plating provides brilliant mirror luster and tarnish resistance.',
      specifications: {
        'Metal': 'Solid 925 Sterling Silver stamped hallmark',
        'Band Width': '4mm brushed satin top with comfort-fit curved interior',
      },
      durability:
          'Solid nickel-free alloy retains round shape under everyday hand pressure.',
    ),
    Product(
      id: 'p24',
      name: 'Reversible Italian Full-Grain Leather Belt',
      description:
          'Two belts in one: sleek twist-buckle reverses between classic black and rich cognac brown leather. Brushed gunmetal zinc alloy buckle.',
      price: 45.0,
      image:
          'https://images.unsplash.com/photo-1624222247344-550fb60583dc?auto=format&fit=crop&w=600&q=80',
      category: 'Accessories',
      stock: 16,
      rating: 4.7,
      functionality:
          'Instant color change from formal black dress pants to casual brown chinos with a quick pull-and-turn buckle action.',
      specifications: {
        'Leather': '100% Genuine Italian Full-Grain Leather (34mm width)',
        'Buckle': '360-degree rotating brushed gunmetal buckle',
      },
      durability:
          'Solid one-piece leather strap will never split or peel like bonded faux leather belts.',
    ),

    // -------------------------------------------------------------------------
    // 5. BEAUTY
    // -------------------------------------------------------------------------
    Product(
      id: 'p25',
      name: 'Hydrating Botanical Facial Serum',
      description:
          'Formulated with multi-molecular hyaluronic acid, vitamin B5, and organic rosehip extract. Restores moisture barrier and delivers instant dewy radiance.',
      price: 36.0,
      image:
          'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?auto=format&fit=crop&w=600&q=80',
      category: 'Beauty',
      stock: 40,
      rating: 4.8,
      functionality:
          'Intensive moisture barrier hydration and rejuvenation. Fast-absorbing liquid gel plumps fine lines, evens skin tone, and restores dewy glow in 7 days.',
      specifications: {
        'Active Actives':
            '2% Multi-Molecular Hyaluronic Acid, 5% Niacinamide, B5, Rosehip',
        'Volume': '30ml / 1.0 fl oz UV-protective amber glass dropper bottle',
        'Skin Suitability':
            'Dermatologist tested for all skin types, including sensitive skin',
        'Ethical': '100% Vegan, Cruelty-Free, Paraben-Free, Fragrance-Free',
        'Texture': 'Ultra-lightweight oil-free aqueous gel',
      },
      durability:
          'Airless dropper seal maintains potency. 24-month unopened shelf life / 12-month PAO (period after opening).',
    ),
    Product(
      id: 'p26',
      name: 'Velvet Matte Long-Wear Lipstick Duo',
      description:
          'Weightless, pigment-rich liquid lipstick infused with jojoba oil and vitamin E for a non-drying, smudge-proof 12-hour comfortable finish.',
      price: 24.0,
      image:
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?auto=format&fit=crop&w=600&q=80',
      category: 'Beauty',
      stock: 28,
      rating: 4.6,
      functionality:
          'Full-coverage liquid lip color with ultra-smooth gliding precision applicator. Dries to an ultra-comfortable velvet matte texture that never flakes.',
      specifications: {
        'Set Contents': '2 Complimentary Shades (Nude Rosewood & Bold Crimson)',
        'Infusion': 'Organic Jojoba Seed Oil, Shea Butter, and Vitamin E',
        'Performance': '16-Hour Transfer-proof, Mask-proof, and Waterproof',
        'Volume': '2 x 4.5ml',
        'Finish': 'Velveteen soft-touch matte',
      },
      durability:
          'Non-drying flexible polymer film prevents feathering or cracking in high heat and humidity.',
    ),
    Product(
      id: 'p27',
      name: 'Artisan Sandalwood & Amber Scented Candle',
      description:
          'Hand-poured 100% natural soy wax candle with clean-burning crackling wooden wick. Notes of cedarwood, warm amber, and French lavender.',
      price: 26.0,
      image:
          'https://images.unsplash.com/photo-1603006905003-be475563bc59?auto=format&fit=crop&w=600&q=80',
      category: 'Beauty',
      stock: 17,
      rating: 4.7,
      functionality:
          'Aromatherapy and ambiance candle designed for stress relief, relaxation, and home fragrance diffusion. Emits an organic soothing crackling fire sound.',
      specifications: {
        'Wax': '100% Pure Organic Soybean Wax & Plant Oils',
        'Wick':
            'FSC-Certified sustainably harvested natural wooden booster wick',
        'Burn Time': '55 - 60 clean burning hours',
        'Vessel': 'Matte frosted ceramic tumbler with embossed bamboo lid',
        'Fragrance Throw': 'High diffusion cold and warm scent throw',
      },
      durability:
          'Clean burn with zero toxic paraffin, zero petroleum soot, and 100% reusable ceramic keepsake tumbler.',
    ),
    Product(
      id: 'p28',
      name: 'Organic Nourishing Vitamin C Night Cream',
      description:
          'Rich restorative overnight facial cream packed with cold-pressed marula oil, stabilized Vitamin C, and squalane for deep night renewal.',
      price: 42.0,
      image:
          'https://images.unsplash.com/photo-1556228720-195a672e8a03?auto=format&fit=crop&w=600&q=80',
      category: 'Beauty',
      stock: 19,
      rating: 4.8,
      functionality:
          'Deep hydration replenishment while you sleep. Brightens hyperpigmentation and locks in skin moisture through morning.',
      specifications: {
        'Volume': '50ml frosted glass jar with hygiene inner lid',
        'Key Ingredients': '10% THD Ascorbate (Vitamin C), Squalane, Marula Oil',
      },
      durability:
          'Antioxidant-stabilized formulation resists oxidation and dark discoloration in humid tropical climates.',
    ),
    Product(
      id: 'p29',
      name: 'Revitalizing Mineral Rosewater Face Mist',
      description:
          'Pure distilled Damask rose water infused with aloe vera, cucumber extract, and electrolyte minerals to instantly soothe and refresh tired skin.',
      price: 22.0,
      image:
          'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?auto=format&fit=crop&w=600&q=80',
      category: 'Beauty',
      stock: 30,
      rating: 4.6,
      functionality:
          'Instant midday skin cooldown, toner step, or makeup setting spray. Calms sun-exposed skin and reduces redness.',
      specifications: {
        'Bottle': '100ml ultra-fine micro-atomizer spray bottle',
        'Origin': 'Distilled Rosa Damascena petals',
      },
      durability:
          'Naturally preserved with radish root ferment for 18-month freshness.',
    ),
    Product(
      id: 'p30',
      name: 'Gentle Clarifying Green Tea Clay Mask',
      description:
          'French green clay combined with matcha green tea and tea tree oil to purify pores, balance excess oil, and reduce blemishes without over-drying.',
      price: 30.0,
      image:
          'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?auto=format&fit=crop&w=600&q=80',
      category: 'Beauty',
      stock: 21,
      rating: 4.7,
      functionality:
          '10-minute purifying spa treatment for oily and combination skin. Absorbs impurities and leaves complexion smooth and refined.',
      specifications: {
        'Volume': '80g creamy clay paste',
        'Ingredients': 'French Green Illite Clay, Ceremonial Matcha, Tea Tree',
      },
      durability:
          'Hermetic seal prevents clay drying out between weekly uses.',
    ),

    // -------------------------------------------------------------------------
    // 6. ELECTRONICS
    // -------------------------------------------------------------------------
    Product(
      id: 'p31',
      name: 'Active Noise Cancelling Wireless Headphones',
      description:
          'Over-ear studio sound headphones with 40mm high-fidelity dynamic drivers, hybrid active noise cancellation, and up to 40 hours battery life.',
      price: 160.0,
      image:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=600&q=80',
      category: 'Electronics',
      stock: 12,
      rating: 4.9,
      functionality:
          'Studio-grade hybrid Active Noise Cancellation (up to -38dB) with Transparency Mode, multipoint Bluetooth 5.3 connection (2 devices simultaneously), and crystal mic beamforming.',
      specifications: {
        'Acoustic Driver': '40mm Beryllium-coated dynamic drivers',
        'Battery Life': '45 hours playtime (ANC on) / 60 hours (ANC off)',
        'Fast Charge': '10 minutes charge yields 5 hours playtime via USB-C',
        'Codecs': 'AAC, SBC, and Hi-Res LDAC audio decoding',
        'Weight': '248g ergonomic foldable frame',
      },
      durability:
          'Aircraft-grade anodized aluminum headband sliders with protein memory-foam earcups tested for 10,000+ flex cycles.',
    ),
    Product(
      id: 'p32',
      name: 'Compact True Wireless Hi-Fi Earbuds',
      description:
          'Ergonomic Bluetooth 5.3 earbuds featuring environmental noise cancellation for crystal calls, IPX5 water resistance, and fast USB-C wireless charge case.',
      price: 70.0,
      image:
          'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=600&q=80',
      category: 'Electronics',
      stock: 20,
      rating: 4.7,
      functionality:
          'Ultra-portable pocket earbuds with quad-mic ENC for loud outdoor calls, touch gesture controls, and low-latency 45ms gaming audio mode.',
      specifications: {
        'Drivers': '10mm Titanium-diaphragm composite drivers',
        'Playtime':
            '8 hours per charge + 32 hours battery in pocket charging case',
        'Waterproof Rating': 'IPX5 sweat and rainfall certified',
        'Wireless Connectivity': 'Bluetooth 5.3 with instantaneous auto-pair',
        'Charging': 'USB-C fast wired charging + Qi wireless pad compatible',
      },
      durability:
          'Nano-coated acoustic mesh resists earwax and sweat ingress. Magnetic lid tested for 20,000 opening cycles.',
    ),
    Product(
      id: 'p33',
      name: 'Smart Fitness Tracker & Heart Rate Watch',
      description:
          'Vibrant AMOLED touch display with 24/7 continuous heart rate, SpO2 blood oxygen tracking, sleep analysis, and 50+ athletic workout modes.',
      price: 80.0,
      image:
          'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=600&q=80',
      category: 'Electronics',
      stock: 14,
      rating: 4.8,
      functionality:
          'All-in-one daily health & workout monitor with continuous 24/7 heart rate, blood oxygen (SpO2), stress monitoring, sleep stages, and real-time smartphone notifications.',
      specifications: {
        'Display':
            '1.47-inch High-Brightness Curved AMOLED Touchscreen (450 nits)',
        'Battery':
            '14-day ultra-long endurance on a single magnetic charge',
        'Sensors':
            'Optical PPG Bio-tracking sensor, 6-axis accelerometer, SpO2',
        'Waterproof Rating': '5 ATM (50m depth swim-proof)',
        'Compatibility': 'iOS 11.0+ and Android 6.0+ via Bluetooth Low Energy',
      },
      durability:
          'Corning Gorilla Glass face with aerospace polymer frame and skin-friendly fluoroelastomer sweat-channel strap.',
    ),
    Product(
      id: 'p34',
      name: 'Rugged IPX7 Waterproof Bluetooth Speaker',
      description:
          'Heavy 360-degree bass with dual passive radiators, 24-hour party battery, and full IPX7 waterproof submersible floating casing.',
      price: 65.0,
      image:
          'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=600&q=80',
      category: 'Electronics',
      stock: 17,
      rating: 4.7,
      functionality:
          'Outdoor party and beach speaker. Floats in pools, connects two speakers for wireless stereo, and includes built-in microphone for speakerphone calls.',
      specifications: {
        'Power Output': '25W RMS with BassUp DSP digital enhancement',
        'Battery': '5,200mAh (24 hours playback @ 50% volume)',
        'Waterproof': 'IPX7 certified (submersible up to 1 meter for 30 min)',
      },
      durability:
          'Shock-absorbing silicone end-caps survive drops onto concrete from 1.5 meters.',
    ),
    Product(
      id: 'p35',
      name: '15W Fast Magnetic Qi Wireless Charger',
      description:
          'Ultra-thin aluminum alloy puck with strong MagSafe-compatible magnets for instant snap-on 15W high-speed wireless charging.',
      price: 38.0,
      image:
          'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?auto=format&fit=crop&w=600&q=80',
      category: 'Electronics',
      stock: 26,
      rating: 4.6,
      functionality:
          'Snaps securely to iPhone 12/13/14/15/16 and Qi2 Android phones. Charges through phone cases up to 5mm thick without overheating.',
      specifications: {
        'Output Power': '15W / 10W / 7.5W / 5W adaptive fast charge',
        'Cable': '1.5-meter braided nylon USB-C integrated cord',
        'Protection': 'FOD foreign object detection, thermal temperature control',
      },
      durability:
          'Anodized aviation aluminum backplate dissipates heat rapidly for efficient battery longevity.',
    ),
    Product(
      id: 'p36',
      name: 'High-Speed Dual Port 65W GaN Travel Charger',
      description:
          'Pocket-sized Gallium Nitride (GaN) fast wall adapter with dual USB-C and USB-A ports to charge laptops, tablets, and phones simultaneously.',
      price: 45.0,
      image:
          'https://images.unsplash.com/photo-1618761714954-0b8cd0026356?auto=format&fit=crop&w=600&q=80',
      category: 'Electronics',
      stock: 22,
      rating: 4.9,
      functionality:
          'Replaces bulky laptop charging bricks. Powers a MacBook Pro or Dell XPS at full 65W speed, or fast-charges phone and tablet together.',
      specifications: {
        'Technology': 'GaN III Semiconductor Technology',
        'Outputs': '2x USB-C (65W max Power Delivery 3.0), 1x USB-A (QC 4.0)',
        'Pins': 'Foldable pins compatible with 100V-240V international travel',
      },
      durability:
          'Flame-retardant PC shell with overvoltage, overcurrent, and short-circuit multi-protection.',
    ),
  ];

  /// Default demo user profile for Shei Store (Accra, Ghana)
  static const UserProfile defaultUser = UserProfile(
    name: 'Shei Customer',
    email: 'customer@sheistore.com',
    phone: '+233 24 555 0192',
    address: 'Block B, Independence Avenue, Ridge',
    city: 'Accra',
  );
}
