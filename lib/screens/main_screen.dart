import 'package:flutter/material.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/screens/cart_screen.dart';
import 'package:hettys_shop/screens/categories_screen.dart';
import 'package:hettys_shop/screens/home_screen.dart';
import 'package:hettys_shop/screens/profile_screen.dart';

/// ============================================================================
/// MainScreen
/// Coursework Concept: StatefulWidget, Scaffold, NavigationBar, Page Navigation
/// ============================================================================
/// Hosts the bottom [NavigationBar] with 4 primary destinations:
/// 1. Home
/// 2. Categories
/// 3. Cart (with dynamic count badge)
/// 4. Profile
///
/// Demonstrates [StatefulWidget] where the selected index updates upon user tap.
class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of page widgets corresponding to each navigation bar index
    final List<Widget> pages = [
      HomeScreen(
        onNavigateToCategories: () => _onDestinationSelected(1),
        onNavigateToCart: () => _onDestinationSelected(2),
      ),
      const CategoriesScreen(),
      CartScreen(
        isRootTab: true,
        onContinueShopping: () => _onDestinationSelected(0),
      ),
      ProfileScreen(
        onViewOrders: () => _onDestinationSelected(0),
      ),
    ];

    // Coursework Concept: Scaffold with body and NavigationBar
    return ListenableBuilder(
      listenable: CartService(),
      builder: (context, child) {
        final cartCount = CartService().itemCount;

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          // Coursework Concept: NavigationBar (Lecturer Requirement)
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onDestinationSelected,
              backgroundColor: Colors.white,
              elevation: 0,
              indicatorColor: const Color(0xFF6A11CB).withOpacity(0.15),
              destinations: [
                // 1. Home
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: Color(0xFF6A11CB)),
                  label: 'Home',
                ),

                // 2. Categories
                const NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view, color: Color(0xFF6A11CB)),
                  label: 'Categories',
                ),

                // 3. Cart (with Badge)
                NavigationDestination(
                  icon: cartCount > 0
                      ? Badge(
                          label: Text('$cartCount'),
                          backgroundColor: Colors.redAccent,
                          child: const Icon(Icons.shopping_cart_outlined),
                        )
                      : const Icon(Icons.shopping_cart_outlined),
                  selectedIcon: cartCount > 0
                      ? Badge(
                          label: Text('$cartCount'),
                          backgroundColor: Colors.redAccent,
                          child: const Icon(Icons.shopping_cart,
                              color: Color(0xFF6A11CB)),
                        )
                      : const Icon(Icons.shopping_cart,
                          color: Color(0xFF6A11CB)),
                  label: 'Cart',
                ),

                // 4. Profile
                const NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: Color(0xFF6A11CB)),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
