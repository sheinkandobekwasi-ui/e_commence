import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/data/mock_data.dart';
import 'package:hettys_shop/data/product_service.dart';
import 'package:hettys_shop/data/wishlist_service.dart';
import 'package:hettys_shop/main.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/screens/admin_dashboard_screen.dart';
import 'package:hettys_shop/screens/admin_product_form_screen.dart';
import 'package:hettys_shop/screens/checkout_screen.dart';
import 'package:hettys_shop/screens/home_screen.dart';
import 'package:hettys_shop/screens/main_screen.dart';
import 'package:hettys_shop/screens/order_confirmation_screen.dart';
import 'package:hettys_shop/screens/product_details_screen.dart';
import 'package:hettys_shop/screens/wishlist_screen.dart';
import 'package:hettys_shop/services/admin_service.dart';
import 'package:hettys_shop/services/order_notification_service.dart';
import 'package:hettys_shop/widgets/account_helpdesk_card.dart';
import 'package:hettys_shop/widgets/app_image.dart';
import 'package:hettys_shop/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    CartService().clearCart();
    ProductService().resetToDefault();
    WishlistService().clearWishlist();
  });

  testWidgets('Shei Store loads initial login screen and authenticates', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HettysShopApp());
    await tester.pumpAndSettle();

    expect(find.text("Shei Store"), findsWidgets);
    expect(find.text('Sign In'), findsOneWidget);

    // Tap continue as guest
    await tester.tap(find.text('Continue as Guest'));
    await tester.pumpAndSettle();

    // Verifies Home screen loaded
    expect(find.text('Special Offers'), findsOneWidget);
    expect(find.text('Categories'), findsWidgets);
  });

  test('All 16 Ghana regions are defined in CheckoutScreen.ghanaRegions', () {
    const expectedRegions = [
      'Ahafo',
      'Ashanti',
      'Bono',
      'Bono East',
      'Central',
      'Eastern',
      'Greater Accra',
      'North East',
      'Northern',
      'Oti',
      'Savannah',
      'Upper East',
      'Upper West',
      'Volta',
      'Western',
      'Western North',
    ];

    expect(CheckoutScreen.ghanaRegions.length, 16);
    for (final region in expectedRegions) {
      expect(
        CheckoutScreen.ghanaRegions.contains(region),
        isTrue,
        reason: 'Missing region: $region',
      );
    }
  });

  testWidgets(
    'CheckoutScreen displays 16 Ghana regions compact dropdown and GH₵ currency',
    (WidgetTester tester) async {
      CartService().addItem(MockData.sampleProducts.first);

      await tester.pumpWidget(const MaterialApp(home: CheckoutScreen()));
      await tester.pumpAndSettle();

      // Verify Delivery Region field exists
      expect(find.text('Delivery Region (Ghana) *'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

      // Verify compact dropdown menuMaxHeight is 260
      final dropdownFinder = find.byType(DropdownButton<String>);
      final dropdownWidget = tester.widget<DropdownButton<String>>(
        dropdownFinder,
      );
      expect(dropdownWidget.menuMaxHeight, 260);

      // Verify prices exclusively use GH₵ and NOT $
      expect(find.textContaining('GH₵'), findsWidgets);
      expect(find.textContaining(r'$'), findsNothing);
    },
  );

  testWidgets(
    'CheckoutScreen has GPS location smart-fill for Sunyani and Bono',
    (WidgetTester tester) async {
      CartService().addItem(MockData.sampleProducts.first);

      await tester.pumpWidget(const MaterialApp(home: CheckoutScreen()));
      await tester.pumpAndSettle();

      // Verify GPS smart fill action is present
      expect(find.textContaining('GPS: Sunyani (Bono)'), findsOneWidget);
      expect(find.byIcon(Icons.gps_fixed), findsOneWidget);

      // Tap GPS action button
      await tester.tap(find.textContaining('GPS: Sunyani (Bono)'));
      await tester.pumpAndSettle();

      // Verify Sunyani is smart-filled in City
      expect(find.text('Sunyani'), findsWidgets);
    },
  );

  testWidgets(
    'OrderConfirmationScreen exclusively uses GH₵ and displays region',
    (WidgetTester tester) async {
      final orderData = {
        'orderId': 'HS-987654',
        'customerName': 'Henrietta Mensah',
        'customerEmail': 'hetty@university.edu',
        'customerPhone': '+233 24 555 0192',
        'deliveryRegion': 'Ashanti Region',
        'deliveryAddress':
            'Room 12, Unity Hall, KNUST, Kumasi, Ashanti Region, Ghana',
        'paymentMethod': 'Mobile Money',
        'itemCount': 2,
        'totalAmount': 178.00,
        'orderDate': '2026-10-04 10:00:00',
      };

      await tester.pumpWidget(
        MaterialApp(home: OrderConfirmationScreen(orderData: orderData)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Delivery Region'), findsOneWidget);
      expect(find.text('Ashanti Region'), findsOneWidget);
      expect(find.text('GH₵ 178.00'), findsOneWidget);
      expect(find.textContaining(r'$'), findsNothing);
    },
  );

  testWidgets(
    'ProductDetailsScreen displays Functionality, Specs, and Durability',
    (WidgetTester tester) async {
      final product = MockData.sampleProducts.first;

      await tester.pumpWidget(
        MaterialApp(home: ProductDetailsScreen(product: product)),
      );
      await tester.pumpAndSettle();

      // Verify sections exist
      expect(find.text('Product Overview'), findsOneWidget);
      expect(find.text('Functionality & Performance'), findsOneWidget);
      expect(find.text('Quality Specifications'), findsOneWidget);
      expect(find.text('Durability & Longevity'), findsOneWidget);
      expect(find.text('Verified Quality & Longevity Tested'), findsOneWidget);

      // Verify image uses AppImage / BoxFit.contain (uncropped)
      expect(find.byType(AppImage), findsOneWidget);
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.fit, BoxFit.contain);
    },
  );

  testWidgets(
    'AccountHelpdeskCard renders quick support channels (WhatsApp & Hotline)',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: AccountHelpdeskCard()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Account Helpdesk'), findsOneWidget);
      expect(find.text('24/7 LIVE'), findsOneWidget);
      expect(find.text('Ask Query'), findsOneWidget);
      expect(find.text('WhatsApp'), findsOneWidget);
      expect(find.text('Hotline'), findsOneWidget);

      // Tap to open FAQs
      await tester.tap(find.textContaining('Instant FAQ Solutions'));
      await tester.pumpAndSettle();
      expect(find.text('Delivery in Ghana (16 Regions)'), findsOneWidget);
    },
  );

  testWidgets(
    'Admin authentication and Product Management adds dynamic product rendered to store',
    (WidgetTester tester) async {
      // Verify admin credentials login
      expect(AdminService().login('admin@hettysshop.com', 'admin123'), isTrue);

      // Verify adding a new product dynamically reflects on customer HomeScreen
      const newProduct = Product(
        id: 'admin-p-999',
        name: 'Custom Admin Kente Coat',
        description: 'Handwoven premium Ghanaian Kente ceremonial jacket.',
        price: 250.0,
        image: 'assets/images/sample_product.png',
        category: 'Fashion',
        stock: 5,
        rating: 5.0,
        functionality: 'Ceremonial and formal luxury outerwear.',
        specifications: {'Weave': '100% Traditional Bonwire Kente'},
        durability: 'Handcrafted heirloom longevity.',
      );

      await ProductService().addProduct(newProduct);

      // Verify new product exists in ProductService
      expect(ProductService().products.first.name, 'Custom Admin Kente Coat');

      // Build HomeScreen and verify dynamically rendered
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Custom Admin Kente Coat'), findsOneWidget);
      expect(find.text('GH₵ 250'), findsOneWidget);
    },
  );

  testWidgets(
    'AdminDashboardScreen renders Product Catalog and Customer Orders tabs',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AdminDashboardScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Admin Portal • Shei Store'), findsOneWidget);
      expect(find.text('Product Catalog'), findsOneWidget);
      expect(find.text('Customer Orders'), findsOneWidget);
      expect(find.text('Add Product'), findsOneWidget);
    },
  );

  testWidgets(
    'Responsive Layout on iPhone SE (375x667) has zero overflow errors',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.71,
              ),
              itemCount: 2,
              itemBuilder: (context, index) =>
                  ProductCard(product: MockData.sampleProducts[index]),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check no overflow errors occurred
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Responsive Layout on Samsung Galaxy A55 (412x915) has zero overflow errors',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsScreen(product: MockData.sampleProducts[1]),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );

  test('Expanded catalog covers Fashion, Shoes, Bags, Accessories, Beauty, Electronics with 36 items in GH₵', () {
    expect(MockData.sampleProducts.length, 36);

    final categories = {'Fashion', 'Shoes', 'Bags', 'Accessories', 'Beauty', 'Electronics'};
    for (final cat in categories) {
      final items = MockData.sampleProducts.where((p) => p.category == cat).toList();
      expect(items.length, 6, reason: 'Expected 6 products for category $cat');
    }

    for (final p in MockData.sampleProducts) {
      expect(p.formattedPrice.startsWith('GH₵'), isTrue);
      expect(p.name.isNotEmpty, isTrue);
      expect(p.description.isNotEmpty, isTrue);
      expect(p.functionality.isNotEmpty, isTrue);
      expect(p.durability.isNotEmpty, isTrue);
      expect(p.specifications.isNotEmpty, isTrue);
      expect(p.rating >= 4.0, isTrue);
      expect(p.image.isNotEmpty, isTrue);
    }
  });

  testWidgets('OrderNotificationService triggers notification for placed orders and status updates', (
    WidgetTester tester,
  ) async {
    final notifService = OrderNotificationService();

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      notifService.notifyOrderPlaced(
                        context,
                        orderId: 'HS-778899',
                        deliveryRegion: 'Bono Region',
                        city: 'Sunyani',
                        totalAmount: 250.0,
                      );
                    },
                    child: const Text('Simulate Order Placed'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      notifService.notifyOrderStatusUpdated(
                        context,
                        orderId: 'HS-778899',
                        newStatus: 'Dispatched',
                        deliveryRegion: 'Sunyani, Bono Region',
                      );
                    },
                    child: const Text('Simulate Status Update'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    // Tap order placed
    await tester.tap(find.text('Simulate Order Placed'));
    await tester.pump();

    expect(find.text('Order Placed Successfully!'), findsOneWidget);
    expect(
      find.textContaining('Order #HS-778899 successfully placed! Delivery to Sunyani, Bono Region is being processed.'),
      findsWidgets,
    );

    // Dismiss dialog
    await tester.tap(find.text('View Order Summary'));
    await tester.pumpAndSettle();

    // Tap status update
    await tester.tap(find.text('Simulate Status Update'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(
      find.textContaining('Order #HS-778899 status updated to Dispatched! Delivery to Sunyani, Bono Region is being processed.'),
      findsWidgets,
    );
  });

  testWidgets('AppImage fallback renders clean styled product icon without error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 120,
            height: 120,
            child: AppImage(
              imagePath: '', // Empty path triggers fallback
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
    expect(find.text('Product Image'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('OrderConfirmationScreen displays prominent order notification banner', (
    WidgetTester tester,
  ) async {
    final sampleOrder = {
      'orderId': 'HS-112233',
      'customerName': 'Henrietta Mensah',
      'deliveryRegion': 'Bono Region',
      'city': 'Sunyani',
      'deliveryAddress': 'Campus Rd, Sunyani, Bono Region, Ghana',
      'paymentMethod': 'Cash on Delivery',
      'itemCount': 3,
      'totalAmount': 210.0,
      'orderDate': '2026-10-12 14:00:00',
    };

    await tester.pumpWidget(
      MaterialApp(
        home: OrderConfirmationScreen(orderData: sampleOrder),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ORDER NOTIFICATION CONFIRMATION'), findsOneWidget);
    expect(
      find.textContaining('Order #HS-112233 successfully placed! Delivery to Sunyani, Bono Region is being processed.'),
      findsOneWidget,
    );
  });

  test('ProductService persists products locally via SharedPreferences', () async {
    final service = ProductService();
    await service.resetToDefault();
    final initialCount = service.products.length;

    const newProduct = Product(
      id: 'local_test_999',
      name: 'Local Test Product',
      price: 150.0,
      image: 'assets/images/custom_test.jpg',
      category: 'Electronics',
      stock: 5,
      rating: 4.8,
      description: 'Local storage test description',
    );

    await service.addProduct(newProduct);
    expect(service.products.length, initialCount + 1);

    // Verify stored in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final storedJson = prefs.getString('hettys_local_products');
    expect(storedJson, isNotNull);
    expect(storedJson!.contains('local_test_999'), isTrue);
    expect(storedJson.contains('Local Test Product'), isTrue);

    // Verify reload from SharedPreferences
    await service.loadFromLocalPreferences();
    expect(service.products.any((p) => p.id == 'local_test_999'), isTrue);

    // Verify deletion persists locally
    await service.deleteProduct('local_test_999');
    expect(service.products.length, initialCount);
    final updatedJson = prefs.getString('hettys_local_products');
    expect(updatedJson!.contains('local_test_999'), isFalse);
  });

  testWidgets('AppImage renders Base64 data URI cleanly without error', (
    WidgetTester tester,
  ) async {
    const validBase64Uri =
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppImage(
            imagePath: validBase64Uri,
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('WishlistService toggles, persists locally to SharedPreferences, and moves to cart', () async {
    final wishlist = WishlistService();
    await wishlist.clearWishlist();
    expect(wishlist.itemCount, 0);

    final product = MockData.sampleProducts.first;

    // Toggle on (add)
    await wishlist.toggleWishlist(product);
    expect(wishlist.itemCount, 1);
    expect(wishlist.isWishlisted(product.id), isTrue);

    // Verify stored in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final storedIds = prefs.getStringList('hettys_wishlist_ids');
    expect(storedIds, isNotNull);
    expect(storedIds!.contains(product.id), isTrue);

    // Move to cart
    CartService().clearCart();
    expect(CartService().itemCount, 0);
    await wishlist.moveToCart(product);
    expect(wishlist.itemCount, 0);
    expect(CartService().itemCount, 1);
  });

  testWidgets('MainScreen contains 5 bottom navigation tabs [Home, Categories, Cart, Wishlist, Account]', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });

  testWidgets('WishlistScreen shows empty state and populated state with Move to Cart action', (
    WidgetTester tester,
  ) async {
    final wishlist = WishlistService();
    await wishlist.clearWishlist();

    await tester.pumpWidget(const MaterialApp(home: WishlistScreen()));
    await tester.pumpAndSettle();

    // Verify empty state
    expect(find.text('Your Wishlist is Empty'), findsOneWidget);
    expect(find.text('Explore Products'), findsOneWidget);

    // Add item to wishlist
    final sample = MockData.sampleProducts.first;
    await wishlist.addToWishlist(sample);
    await tester.pumpAndSettle();

    // Verify populated card
    expect(find.text(sample.name), findsOneWidget);
    expect(find.text('Move to Cart'), findsOneWidget);
    expect(find.text('Checkout Now'), findsOneWidget);
  });

  testWidgets('HomeScreen renders Hotline Bar, Promotional Carousel, Essentials Cards, and Flash Sale with timer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    // 1. Search Bar & Hotline Bar
    expect(find.textContaining('Call to Order: 0599876242'), findsOneWidget);

    // 2. Promotional Carousel & Special Offers
    expect(find.text('Special Offers'), findsOneWidget);
    expect(find.text('Mid-Season Mega Sale'), findsOneWidget);

    // 3. Essentials & Perks
    expect(find.text('Essentials & Perks'), findsOneWidget);
    expect(find.text('Flash Deals'), findsWidgets);
    expect(find.text('Delivery'), findsOneWidget);
    expect(find.text('MoMo Pay'), findsOneWidget);
    expect(find.text('Helpdesk'), findsOneWidget);

    // 4. Flash Sale Countdown Section
    expect(find.text('Flash Sale'), findsOneWidget);
    expect(find.text('See All'), findsWidgets);

    // 5. ProductCard Wishlist Heart Button
    expect(find.byIcon(Icons.favorite_border_rounded), findsWidgets);
  });

  testWidgets(
    'Admin Portal receives real-time customer order notifications and updates badge',
    (WidgetTester tester) async {
      OrderNotificationService().clearAll();
      expect(OrderNotificationService().unreadOrderCount, 0);

      await tester.pumpWidget(const MaterialApp(home: AdminDashboardScreen()));
      await tester.pumpAndSettle();

      // Trigger a real-time order simulation
      await OrderNotificationService().simulateCustomerOrder(null);
      await tester.pump();

      // Verify unread count updated
      expect(OrderNotificationService().unreadOrderCount, 1);
      final latest = OrderNotificationService().latestUnreadOrder;
      expect(latest, isNotNull);
      expect(latest!.totalAmount, 450.00);
      expect(latest.deliveryRegion, contains('Sunyani'));

      // Settle UI changes
      await tester.pumpAndSettle();

      // Verify live alert banner or badge is rendered on screen
      expect(find.text('1 NEW'), findsOneWidget);
      expect(find.textContaining('LIVE ORDER'), findsOneWidget);
    },
  );

  testWidgets(
    'AdminProductFormScreen pre-populates existing product data and updates product inventory',
    (WidgetTester tester) async {
      final product = MockData.sampleProducts.first;

      await tester.pumpWidget(
        MaterialApp(
          home: AdminProductFormScreen(productToEdit: product),
        ),
      );
      await tester.pumpAndSettle();

      // Verify title is Edit Product
      expect(find.text('Edit Product'), findsOneWidget);

      // Verify pre-populated fields
      expect(find.text(product.name), findsWidgets);
      expect(find.text(product.description), findsOneWidget);
      expect(find.text(product.functionality), findsOneWidget);
      expect(find.text(product.durability), findsOneWidget);
      expect(find.text('Save & Update Product Inventory'), findsOneWidget);

      // Modify the title
      final titleField = find.widgetWithText(TextFormField, product.name);
      await tester.enterText(titleField, 'Updated Trench Coat Edition');
      await tester.pumpAndSettle();

      // Scroll to Save button and tap
      final saveBtnFinder = find.text('Save & Update Product Inventory');
      await tester.ensureVisible(saveBtnFinder);
      await tester.tap(saveBtnFinder);
      await tester.pumpAndSettle();

      // Verify ProductService has the updated product
      final updated = ProductService().getById(product.id);
      expect(updated, isNotNull);
      expect(updated!.name, 'Updated Trench Coat Edition');
    },
  );
}

