import 'package:flutter/material.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/screens/admin_dashboard_screen.dart';
import 'package:hettys_shop/screens/admin_login_screen.dart';
import 'package:hettys_shop/screens/admin_product_form_screen.dart';
import 'package:hettys_shop/screens/cart_screen.dart';
import 'package:hettys_shop/screens/checkout_screen.dart';
import 'package:hettys_shop/screens/login_screen.dart';
import 'package:hettys_shop/screens/main_screen.dart';
import 'package:hettys_shop/screens/order_confirmation_screen.dart';
import 'package:hettys_shop/screens/product_details_screen.dart';
import 'package:hettys_shop/screens/registration_screen.dart';
import 'package:hettys_shop/screens/wishlist_screen.dart';
import 'package:hettys_shop/services/firebase_service.dart';

/// ============================================================================
/// Shei Store (formerly Hetty's Shop) - University Coursework Mobile & Web Application
///
/// LECTURER'S REQUIRED CONCEPTS IMPLEMENTED ACROSS THE PROJECT:
///  [✓] MaterialApp - Defined here in main.dart
///  [✓] Scaffold - Used in all primary screens
///  [✓] AppBar - Custom headers with titles, actions & search
///  [✓] NavigationBar - Modern Material 3 bottom navigation in MainScreen
///  [✓] Container - Custom cards, badges, gradients, and layouts
///  [✓] StatelessWidget - ProductCard, PromoBanner, CustomButton, CategoryChip, AppImage
///  [✓] StatefulWidget - MainScreen, HomeScreen, CartScreen, CheckoutScreen, LoginScreen, AdminDashboard
///  [✓] Widget - Explicit typing and composition throughout
///  [✓] child and children - Single-child and multi-child widget trees
///  [✓] body - Provided to every Scaffold
///  [✓] SizedBox - Spacing, sizing, and layout constraints
///  [✓] ListView - Horizontal categories, promo banners, cart list, profile list
///  [✓] GridView - 2-column responsive product grid
///  [✓] Page navigation - Named routes & route arguments
///  [✓] Form validation - Login, Registration, Checkout with `GlobalKey<FormState>`
///  [✓] Arguments - Passing selected Product to ProductDetailsScreen & Order to Confirmation
///  [✓] Firebase Hybrid Storage - Text to Firestore, Local assets to assets/images/
///  [✓] Admin Management Panel - Product Creation, Local Asset Assignment, Orders review
/// ============================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase Free-Tier Hybrid Storage
  await FirebaseService().initialize();
  runApp(const HettysShopApp());
}

/// Root Application Widget
class HettysShopApp extends StatelessWidget {
  const HettysShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Coursework Concept: MaterialApp
    return MaterialApp(
      title: "Shei Store",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF6A11CB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A11CB),
          primary: const Color(0xFF6A11CB),
          secondary: const Color(0xFF2575FC),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E293B),
          elevation: 0,
          centerTitle: false,
        ),
        fontFamily: 'Roboto',
      ),

      // Initial route: starts at Login screen as required by navigation flow
      initialRoute: '/login',

      // Coursework Concept: Page Navigation Routes
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/main': (context) => const MainScreen(),
        '/product-details': (context) => const ProductDetailsScreen(),
        '/cart': (context) => const CartScreen(),
        '/wishlist': (context) => const WishlistScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/order-confirmation': (context) => const OrderConfirmationScreen(),
        '/admin-login': (context) => const AdminLoginScreen(),
        '/admin-dashboard': (context) => const AdminDashboardScreen(),
        '/admin-product-form': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Product?;
          return AdminProductFormScreen(productToEdit: args);
        },
      },
    );
  }
}

/// Alias for Shei Store root widget
typedef SheiStoreApp = HettysShopApp;
