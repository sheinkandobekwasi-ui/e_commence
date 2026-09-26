import 'package:flutter/material.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/widgets/custom_button.dart';
import 'package:hettys_shop/widgets/custom_text_field.dart';

/// ============================================================================
/// CheckoutScreen
/// Coursework Concepts: StatefulWidget, Scaffold, AppBar, Form, GlobalKey,
/// TextFormField, Validators, Container, SizedBox, child & children, Page Navigation
/// ============================================================================
/// Collects shipping information and payment choice before finalizing order.
/// Strictly enforces form validation rules required by the coursework.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Coursework Concept: GlobalKey for Form Validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final CartService _cartService = CartService();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;

  String _selectedPaymentMethod = 'Cash on Delivery';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentOptions = [
    {
      'id': 'Cash on Delivery',
      'label': 'Cash on Delivery (Pay when received)',
      'icon': Icons.money,
    },
    {
      'id': 'Mobile Money',
      'label': 'Mobile Money (MTN / Telecel / AirtelTigo)',
      'icon': Icons.phone_android,
    },
    {
      'id': 'Credit / Debit Card',
      'label': 'Credit / Debit Card (Visa / Mastercard)',
      'icon': Icons.credit_card,
    },
  ];

  @override
  void initState() {
    super.initState();
    final user = _cartService.currentUser;
    _nameController = TextEditingController(text: user.name);
    _phoneController = TextEditingController(text: user.phone);
    _emailController = TextEditingController(text: user.email);
    _addressController = TextEditingController(text: user.address);
    _cityController = TextEditingController(text: user.city);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _handlePlaceOrder() {
    // =========================================================================
    // Coursework Concept: Prevent checkout if information is invalid
    // =========================================================================
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form before proceeding.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_cartService.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty. Add products first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    // Simulate order processing
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isProcessing = false);

      final orderDetails = {
        'orderId': 'HS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        'customerName': _nameController.text.trim(),
        'customerEmail': _emailController.text.trim(),
        'customerPhone': _phoneController.text.trim(),
        'deliveryAddress': '${_addressController.text.trim()}, ${_cityController.text.trim()}',
        'paymentMethod': _selectedPaymentMethod,
        'itemCount': _cartService.itemCount,
        'totalAmount': _cartService.grandTotal,
        'orderDate': DateTime.now().toLocal().toString().split('.')[0],
      };

      // Clear the shopping cart
      _cartService.clearCart();

      // Coursework Concept: Page Navigation with Arguments to Order Confirmation
      Navigator.pushReplacementNamed(
        context,
        '/order-confirmation',
        arguments: orderDetails,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grandTotal = _cartService.grandTotal;

    // Coursework Concept: Scaffold with AppBar & body
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Coursework Concept: Form with GlobalKey
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- STEP 1: SHIPPING INFORMATION ----------------
                _buildSectionHeader('1. Delivery Information', Icons.local_shipping_outlined),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Full Name
                      CustomTextField(
                        controller: _nameController,
                        label: 'Full Name *',
                        hintText: 'e.g. Henrietta Mensah',
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          if (value.trim().length < 3) {
                            return 'Enter at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Phone Number
                      CustomTextField(
                        controller: _phoneController,
                        label: 'Phone Number *',
                        hintText: 'e.g. +233 24 555 0192',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          if (value.trim().length < 7) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Email Address
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email Address *',
                        hintText: 'e.g. hetty@university.edu',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email address is required';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Delivery Address
                      CustomTextField(
                        controller: _addressController,
                        label: 'Street / Campus Address *',
                        hintText: 'e.g. Hall 4, Room 204, Campus Road',
                        prefixIcon: Icons.home_outlined,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Delivery address is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // City
                      CustomTextField(
                        controller: _cityController,
                        label: 'City / Region *',
                        hintText: 'e.g. Accra',
                        prefixIcon: Icons.location_city_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'City is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ---------------- STEP 2: PAYMENT METHOD ----------------
                _buildSectionHeader('2. Payment Method', Icons.payment_outlined),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: _paymentOptions.map((opt) {
                      final isSelected = _selectedPaymentMethod == opt['id'];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = opt['id'] as String;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Icon(
                                opt['icon'] as IconData,
                                color: isSelected
                                    ? theme.primaryColor
                                    : Colors.grey.shade600,
                                size: 24,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      opt['id'] as String,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 14,
                                        color: isSelected
                                            ? theme.primaryColor
                                            : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      opt['label'] as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: isSelected
                                    ? theme.primaryColor
                                    : Colors.grey.shade400,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // ---------------- STEP 3: ORDER SUMMARY ----------------
                _buildSectionHeader('3. Order Summary', Icons.receipt_long_outlined),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Items Count:',
                              style: TextStyle(color: Colors.grey.shade600)),
                          Text('${_cartService.itemCount} items',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal:',
                              style: TextStyle(color: Colors.grey.shade600)),
                          Text('\$${_cartService.subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery Charge:',
                              style: TextStyle(color: Colors.grey.shade600)),
                          Text('\$${_cartService.deliveryFee.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tax (5%):',
                              style: TextStyle(color: Colors.grey.shade600)),
                          Text('\$${_cartService.tax.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Payable:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${grandTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Place Order Button
                CustomButton(
                  text: 'Confirm & Place Order',
                  icon: Icons.check_circle,
                  isLoading: _isProcessing,
                  onPressed: _handlePlaceOrder,
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6A11CB)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
