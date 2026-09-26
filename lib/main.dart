import 'package:flutter/material.dart';
import 'package:hettys_shop/screens/cart_screen.dart';
import 'package:hettys_shop/screens/checkout_screen.dart';
import 'package:hettys_shop/screens/login_screen.dart';
import 'package:hettys_shop/screens/main_screen.dart';
import 'package:hettys_shop/screens/order_confirmation_screen.dart';
import 'package:hettys_shop/screens/product_details_screen.dart';
import 'package:hettys_shop/screens/registration_screen.dart';

/// ============================================================================
/// Hetty's Shop - University Coursework Mobile Application
///
/// LECTURER'S REQUIRED CONCEPTS IMPLEMENTED ACROSS THE PROJECT:
///  [✓] MaterialApp - Defined here in main.dart
///  [✓] Scaffold - Used in all primary screens
///  [✓] AppBar - Custom headers with titles, actions & search
///  [✓] NavigationBar - Modern Material 3 bottom navigation in MainScreen
///  [✓] Container - Custom cards, badges, gradients, and layouts
///  [✓] StatelessWidget - ProductCard, PromoBanner, CustomButton, CategoryChip
///  [✓] StatefulWidget - MainScreen, HomeScreen, CartScreen, CheckoutScreen, LoginScreen
///  [✓] Widget - Explicit typing and composition throughout
///  [✓] child and children - Single-child and multi-child widget trees
///  [✓] body - Provided to every Scaffold
///  [✓] SizedBox - Spacing, sizing, and layout constraints
///  [✓] ListView - Horizontal categories, promo banners, cart list, profile list
///  [✓] GridView - 2-column responsive product grid
///  [✓] Page navigation - Named routes & route arguments
///  [✓] Form validation - Login, Registration, Checkout with `GlobalKey<FormState>`
///  [✓] Arguments - Passing selected Product to ProductDetailsScreen & Order to Confirmation
/// ============================================================================
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HettysShopApp());
}

/// Root Application Widget
class HettysShopApp extends StatelessWidget {
  const HettysShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Coursework Concept: MaterialApp
    return MaterialApp(
      title: "Hetty's Shop",
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
        '/checkout': (context) => const CheckoutScreen(),
        '/order-confirmation': (context) => const OrderConfirmationScreen(),
      },
    );
  }
}
