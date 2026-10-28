import 'package:flutter/material.dart';
import 'package:hettys_shop/data/cart_service.dart';
import 'package:hettys_shop/services/firebase_service.dart';
import 'package:hettys_shop/services/order_notification_service.dart';
import 'package:hettys_shop/widgets/custom_button.dart';
import 'package:hettys_shop/widgets/custom_text_field.dart';

/// ============================================================================
/// CheckoutScreen
/// Coursework Concepts: StatefulWidget, Scaffold, AppBar, Form, GlobalKey,
/// TextFormField, Validators, Container, SizedBox, child & children, Page Navigation
/// ============================================================================
/// Collects shipping information and payment choice before finalizing order.
/// Strictly enforces:
/// 1. Delivery Address Hierarchy & Sequence:
///    - 1. Delivery Region (Ghana)
///    - 2. City / Town (with smart-fill / GPS location mapping for cities like Sunyani)
///    - 3. Street / Campus Address
/// 2. Compact, inline dropdown popup style for Ghana's 16 regions
/// 3. Connecting checkout text data to Firebase Firestore
class CheckoutScreen extends StatefulWidget {
  /// 16 Official Regions of Ghana (Mandatory coursework requirement)
  static const List<String> ghanaRegions = [
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

  /// Mapping of Ghanaian major cities / towns to their official Region
  static const Map<String, String> cityToRegionMap = {
    'Sunyani': 'Bono',
    'Berekum': 'Bono',
    'Dormaa Ahenkro': 'Bono',
    'Techiman': 'Bono East',
    'Kintampo': 'Bono East',
    'Kumasi': 'Ashanti',
    'Obuasi': 'Ashanti',
    'Accra': 'Greater Accra',
    'Tema': 'Greater Accra',
    'Madina': 'Greater Accra',
    'Cape Coast': 'Central',
    'Elmina': 'Central',
    'Winneba': 'Central',
    'Koforidua': 'Eastern',
    'Nkawkaw': 'Eastern',
    'Tamale': 'Northern',
    'Yendi': 'Northern',
    'Takoradi': 'Western',
    'Sekondi': 'Western',
    'Tarkwa': 'Western',
    'Ho': 'Volta',
    'Hohoe': 'Volta',
    'Bolgatanga': 'Upper East',
    'Navrongo': 'Upper East',
    'Wa': 'Upper West',
    'Goaso': 'Ahafo',
    'Dambai': 'Oti',
    'Nalerigu': 'North East',
    'Damongo': 'Savannah',
    'Sefwi Wiawso': 'Western North',
  };

  /// Default regional hub cities for smart-filling
  static const Map<String, String> regionDefaultCityMap = {
    'Bono': 'Sunyani',
    'Bono East': 'Techiman',
    'Ashanti': 'Kumasi',
    'Greater Accra': 'Accra',
    'Central': 'Cape Coast',
    'Eastern': 'Koforidua',
    'Northern': 'Tamale',
    'Western': 'Takoradi',
    'Volta': 'Ho',
    'Upper East': 'Bolgatanga',
    'Upper West': 'Wa',
    'Ahafo': 'Goaso',
    'Oti': 'Dambai',
    'North East': 'Nalerigu',
    'Savannah': 'Damongo',
    'Western North': 'Sefwi Wiawso',
  };

  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Coursework Concept: GlobalKey for Form Validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final CartService _cartService = CartService();
  final FirebaseService _firebaseService = FirebaseService();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;

  String? _selectedRegion = 'Greater Accra';
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

    // Smart-fill listener: when user types known city, auto-map region
    _cityController.addListener(_onCityChanged);
  }

  void _onCityChanged() {
    final text = _cityController.text.trim();
    for (final entry in CheckoutScreen.cityToRegionMap.entries) {
      if (text.toLowerCase() == entry.key.toLowerCase() &&
          _selectedRegion != entry.value) {
        setState(() {
          _selectedRegion = entry.value;
        });
        break;
      }
    }
  }

  @override
  void dispose() {
    _cityController.removeListener(_onCityChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  /// Smart-Fill / GPS Location Mapping for cities like Sunyani
  void _smartFillGPSLocation({
    String city = 'Sunyani',
    String region = 'Bono',
  }) {
    setState(() {
      _selectedRegion = region;
      _cityController.text = city;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('GPS Location mapped: $city ($region Region, Ghana)'),
        backgroundColor: const Color(0xFF6A11CB),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handlePlaceOrder() {
    // =========================================================================
    // Coursework Concept: Prevent checkout if information is invalid
    // =========================================================================
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please correct the errors in the form before proceeding.',
          ),
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

    // Simulate and persist order
    Future.delayed(const Duration(milliseconds: 900), () async {
      if (!mounted) return;
      setState(() => _isProcessing = false);

      final regionName = _selectedRegion ?? 'Greater Accra';
      final cityName = _cityController.text.trim();
      final orderId =
          'SHEI-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      final grandTotal = _cartService.grandTotal;

      final orderDetails = {
        'orderId': orderId,
        'customerName': _nameController.text.trim(),
        'customerEmail': _emailController.text.trim(),
        'customerPhone': _phoneController.text.trim(),
        'deliveryRegion': '$regionName Region',
        'city': cityName,
        'deliveryAddress':
            '${_addressController.text.trim()}, $cityName, $regionName Region, Ghana',
        'paymentMethod': _selectedPaymentMethod,
        'itemCount': _cartService.itemCount,
        'totalAmount': grandTotal,
        'orderDate': DateTime.now().toLocal().toString().split('.')[0],
        'status': 'Processing',
      };

      // Hybrid Storage Logic: Sync order text data to Firebase Firestore
      await _firebaseService.saveOrder(orderDetails);

      // Clear the shopping cart
      _cartService.clearCart();

      if (!mounted) return;

      // Trigger order notification immediately
      OrderNotificationService().notifyOrderPlaced(
        context,
        orderId: orderId,
        deliveryRegion: '$regionName Region',
        city: cityName,
        totalAmount: grandTotal,
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        itemsCount: _cartService.itemCount,
      );

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
                // ---------------- STEP 1: DELIVERY INFORMATION ----------------
                _buildSectionHeader(
                  '1. Delivery Information',
                  Icons.local_shipping_outlined,
                ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipient Contact Header
                      const Text(
                        'Recipient Contact Details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 10),

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
                        hintText: 'e.g. customer@sheistore.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email address is required';
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
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // =======================================================
                      // MANDATORY DELIVERY ADDRESS SEQUENCE:
                      // 1. Delivery Region (Ghana)
                      // 2. City / Town (with smart-fill / GPS location mapping)
                      // 3. Street / Campus Address
                      // =======================================================
                      const Text(
                        'Delivery Address Hierarchy (Ghana)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 1. DELIVERY REGION (GHANA) - COMPACT INLINE DROPDOWN UI
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery Region (Ghana) *',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedRegion,
                            isExpanded: true,
                            isDense: true,
                            menuMaxHeight: 260,
                            borderRadius: BorderRadius.circular(14),
                            icon: const Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              size: 20,
                              color: Color(0xFF6A11CB),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Select one of Ghana\'s 16 regions',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.map_outlined,
                                size: 20,
                                color: Color(0xFF6A11CB),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF6A11CB),
                                  width: 1.8,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.redAccent,
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.redAccent,
                                  width: 2,
                                ),
                              ),
                            ),
                            items: CheckoutScreen.ghanaRegions.map((region) {
                              return DropdownMenuItem<String>(
                                value: region,
                                child: Text(
                                  '$region Region',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRegion = value;
                                // If city is empty or default, suggest matching hub city
                                if (value != null &&
                                    CheckoutScreen.regionDefaultCityMap
                                        .containsKey(value) &&
                                    (_cityController.text.trim().isEmpty ||
                                        _cityController.text.trim() ==
                                            'Accra')) {
                                  _cityController.text = CheckoutScreen
                                      .regionDefaultCityMap[value]!;
                                }
                              });
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please select a delivery region';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // 2. CITY / TOWN (WITH SMART-FILL / GPS LOCATION MAPPING)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'City / Town *',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              // GPS Smart-Fill Action Button
                              InkWell(
                                onTap: () => _smartFillGPSLocation(
                                  city: 'Sunyani',
                                  region: 'Bono',
                                ),
                                borderRadius: BorderRadius.circular(6),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.my_location,
                                        size: 13,
                                        color: Color(0xFF6A11CB),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'GPS: Sunyani (Bono)',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6A11CB),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          CustomTextField(
                            controller: _cityController,
                            label: 'City / Town *',
                            hintText: 'e.g. Sunyani, Kumasi, Accra, Takoradi',
                            prefixIcon: Icons.location_city_outlined,
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.gps_fixed,
                                size: 18,
                                color: Color(0xFF6A11CB),
                              ),
                              tooltip: 'Smart-Fill GPS Location for Sunyani',
                              onPressed: () => _smartFillGPSLocation(
                                city: 'Sunyani',
                                region: 'Bono',
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'City or town is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 6),

                          // Smart-Fill Quick Chips Row
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const Text(
                                  'Smart-Fill: ',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                _buildSmartCityChip('Sunyani', 'Bono'),
                                const SizedBox(width: 6),
                                _buildSmartCityChip('Kumasi', 'Ashanti'),
                                const SizedBox(width: 6),
                                _buildSmartCityChip('Accra', 'Greater Accra'),
                                const SizedBox(width: 6),
                                _buildSmartCityChip('Techiman', 'Bono East'),
                                const SizedBox(width: 6),
                                _buildSmartCityChip('Takoradi', 'Western'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // 3. STREET / CAMPUS ADDRESS
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
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ---------------- STEP 2: PAYMENT METHOD ----------------
                _buildSectionHeader(
                  '2. Payment Method',
                  Icons.payment_outlined,
                ),
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
                            horizontal: 16,
                            vertical: 12,
                          ),
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
                _buildSectionHeader(
                  '3. Order Summary',
                  Icons.receipt_long_outlined,
                ),
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
                          Text(
                            'Items Count:',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            '${_cartService.itemCount} items',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal:',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            'GH₵ ${_cartService.subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Charge:',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            'GH₵ ${_cartService.deliveryFee.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tax (5%):',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            'GH₵ ${_cartService.tax.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                            'GH₵ ${grandTotal.toStringAsFixed(2)}',
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

  Widget _buildSmartCityChip(String city, String region) {
    final isSelected =
        _cityController.text.trim().toLowerCase() == city.toLowerCase();

    return InkWell(
      onTap: () => _smartFillGPSLocation(city: city, region: region),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6A11CB)
              : const Color(0xFF6A11CB).withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$city ($region)',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF6A11CB),
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
