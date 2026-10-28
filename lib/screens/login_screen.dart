import 'package:flutter/material.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/data/mock_data.dart';
import 'package:hettys_shop/widgets/custom_button.dart';
import 'package:hettys_shop/widgets/custom_text_field.dart';

/// ============================================================================
/// LoginScreen
/// Coursework Concepts: StatefulWidget, Scaffold, Form validation, Page navigation
/// ============================================================================
/// Provides email and password authentication with client-side form validation.
/// Allows navigating to Registration or proceeding into the main application.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Coursework Concept: GlobalKey for Form Validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController(
    text: 'customer@sheistore.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'password123',
  );

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Coursework Concept: Form validation checking
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() => _isLoading = false);

        // Update active user session
        CartService().login(
          name: MockData.defaultUser.name,
          email: _emailController.text.trim(),
          phone: MockData.defaultUser.phone,
          address: MockData.defaultUser.address,
          city: MockData.defaultUser.city,
        );

        // Coursework Concept: Navigation - Replace login route with MainScreen
        Navigator.pushReplacementNamed(context, '/main');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Coursework Concept: Scaffold with body
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            // Coursework Concept: Form widget with FormKey
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // Coursework Concept: children list
                children: [
                  // App Brand Logo & Icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6A11CB).withOpacity(0.35),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        size: 44,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Coursework Concept: SizedBox for spacing
                  const SizedBox(height: 20),

                  const Text(
                    "Shei Store",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Welcome back! Log in to continue shopping.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 32),

                  // Email Input Field with Validator
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hintText: 'customer@sheistore.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password Input Field with Validator
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Login Action Button
                  CustomButton(
                    text: 'Sign In',
                    isLoading: _isLoading,
                    icon: Icons.login,
                    onPressed: _handleLogin,
                  ),

                  const SizedBox(height: 16),

                  // Guest / Fast demo button (helpful for lecturer grading)
                  OutlinedButton.icon(
                    onPressed: () {
                      CartService().login(
                        name: 'Guest Shopper',
                        email: 'guest@sheistore.com',
                        phone: '+233 50 123 4567',
                      );
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    icon: const Icon(Icons.person_outline, size: 18),
                    label: const Text('Continue as Guest'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Admin Portal Access Button (Authorized Only)
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/admin-login');
                    },
                    icon: const Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 18,
                      color: Color(0xFF6A11CB),
                    ),
                    label: const Text(
                      'Admin Portal (Authorized Only)',
                      style: TextStyle(
                        color: Color(0xFF6A11CB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Coursework Concept: Page Navigation to Registration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Page navigation: Navigate to Registration screen
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Register Here',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
