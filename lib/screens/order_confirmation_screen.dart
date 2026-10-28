import 'package:flutter/material.dart';
import 'package:hettys_shop/widgets/custom_button.dart';

/// ============================================================================
/// OrderConfirmationScreen
/// Coursework Concepts: StatelessWidget, Scaffold, Container, SizedBox,
/// child & children, Page Navigation with Arguments
/// ============================================================================
/// Displays complete invoice and success summary following checkout.
class OrderConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic>? orderData;

  const OrderConfirmationScreen({super.key, this.orderData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Retrieve order summary details passed as navigation arguments
    final Map<String, dynamic> data =
        orderData ??
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        {
          'orderId': 'SHEI-849201',
          'customerName': 'Shei Customer',
          'customerEmail': 'customer@sheistore.com',
          'customerPhone': '+233 24 555 0192',
          'deliveryAddress': 'Apartment B4, Residential Area, Accra, Ghana',
          'paymentMethod': 'Cash on Delivery',
          'itemCount': 3,
          'totalAmount': 245.50,
          'orderDate': DateTime.now().toLocal().toString().split('.')[0],
        };

    // Coursework Concept: Scaffold with body
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Order Confirmation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Animated Green Checkmark
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.shade200, width: 2),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 60,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Order Placed Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Thank you for shopping with Shei Store. Your package is being prepared for dispatch.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              // ===============================================================
              // ORDER NOTIFICATION BANNER
              // Mandatory requirement: Displays instant confirmation message:
              // "Order #HS-XXXX successfully placed! Delivery to [Region/City] is being processed."
              // ===============================================================
              Builder(
                builder: (context) {
                  final destination =
                      (data['city'] != null &&
                              data['city'].toString().trim().isNotEmpty)
                          ? '${data['city']}, ${data['deliveryRegion'] ?? 'Ghana'}'
                          : (data['deliveryRegion']?.toString() ??
                              data['deliveryAddress']?.toString() ??
                              'Ghana');
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF10B981).withOpacity(0.35),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_active_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ORDER NOTIFICATION CONFIRMATION',
                                style: TextStyle(
                                  color: Color(0xFF047857),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Order #${data['orderId']} successfully placed! Delivery to $destination is being processed.',
                                style: const TextStyle(
                                  color: Color(0xFF065F46),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Receipt / Invoice Container Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Order Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            data['orderId'].toString(),
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    _buildReceiptRow(
                      'Customer Name',
                      data['customerName'].toString(),
                    ),
                    const SizedBox(height: 10),
                    _buildReceiptRow(
                      'Email Address',
                      data['customerEmail'].toString(),
                    ),
                    const SizedBox(height: 10),
                    _buildReceiptRow(
                      'Contact Phone',
                      data['customerPhone'].toString(),
                    ),
                    const SizedBox(height: 10),
                    if (data['deliveryRegion'] != null) ...[
                      _buildReceiptRow(
                        'Delivery Region',
                        data['deliveryRegion'].toString(),
                      ),
                      const SizedBox(height: 10),
                    ],
                    _buildReceiptRow(
                      'Delivery Address',
                      data['deliveryAddress'].toString(),
                    ),
                    const SizedBox(height: 10),
                    _buildReceiptRow(
                      'Payment Method',
                      data['paymentMethod'].toString(),
                    ),
                    const SizedBox(height: 10),
                    _buildReceiptRow(
                      'Total Items',
                      '${data['itemCount']} items',
                    ),
                    const SizedBox(height: 10),
                    _buildReceiptRow(
                      'Date & Time',
                      data['orderDate'].toString(),
                    ),

                    const Divider(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Paid',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'GH₵ ${(data['totalAmount'] as num).toStringAsFixed(2)}',
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

              const SizedBox(height: 30),

              // Action button: Return to Home
              CustomButton(
                text: 'Back to Home',
                icon: Icons.home,
                onPressed: () {
                  // Navigate back to the home tab cleanly
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main',
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 14),

              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'A copy of this receipt has been emailed to your address.',
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                },
                icon: const Icon(Icons.email_outlined, size: 18),
                label: const Text('Email Invoice Receipt'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }
}
