import 'package:flutter/material.dart';
import 'package:hettys_shop/data/cart_service.dart';

/// ============================================================================
/// ProfileScreen
/// Coursework Concepts: StatefulWidget, Scaffold, AppBar, ListView, Container,
/// SizedBox, child & children, Page Navigation
/// ============================================================================
/// Displays current user details (Name, Email, Phone, Address),
/// profile actions, and a Logout button that securely clears the session
/// and routes back to the Login screen.
class ProfileScreen extends StatefulWidget {
  final VoidCallback? onViewOrders;

  const ProfileScreen({super.key, this.onViewOrders});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CartService _cartService = CartService();

  void _showEditProfileDialog() {
    final user = _cartService.currentUser;
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);
    final addressController = TextEditingController(text: user.address);
    final cityController = TextEditingController(text: user.city);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Campus / Street Address'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _cartService.login(
                name: nameController.text.trim(),
                email: user.email,
                phone: phoneController.text.trim(),
                address: addressController.text.trim(),
                city: cityController.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out of Hetty\'s Shop?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _cartService.logout();
              // Page navigation: Replace whole stack and push Login screen
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Coursework Concept: Scaffold with AppBar & body
    return ListenableBuilder(
      listenable: _cartService,
      builder: (context, _) {
        final user = _cartService.currentUser;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text(
              'My Profile',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Profile',
                onPressed: _showEditProfileDialog,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ---------------- USER INFO HEADER CARD ----------------
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // User Avatar
                      Stack(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                              ),
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6A11CB).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.person, size: 50, color: Colors.white),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _showEditProfileDialog,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // User Name
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // User Email
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),

                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn('Orders', '4', theme.primaryColor),
                          Container(
                              height: 24, width: 1, color: Colors.grey.shade300),
                          _buildStatColumn('Wishlist', '12', Colors.redAccent),
                          Container(
                              height: 24, width: 1, color: Colors.grey.shade300),
                          _buildStatColumn('Coupons', '2', Colors.amber.shade800),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------- USER CONTACT & ADDRESS INFO ----------------
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
                      const Text(
                        'Contact & Delivery Details',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        Icons.phone_outlined,
                        'Phone Number',
                        user.phone,
                      ),
                      const Divider(height: 18),
                      _buildInfoTile(
                        Icons.location_on_outlined,
                        'Delivery Address',
                        '${user.address}, ${user.city}',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------- SETTINGS & OPTIONS ----------------
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
                    children: [
                      ListTile(
                        leading: const Icon(Icons.receipt_long_outlined,
                            color: Color(0xFF6A11CB)),
                        title: const Text('Order History',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Displaying your most recent coursework orders.'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.notifications_outlined,
                            color: Color(0xFF6A11CB)),
                        title: const Text('Notifications',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notifications are currently active.'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.help_outline,
                            color: Color(0xFF6A11CB)),
                        title: const Text('Help & Support',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: "Hetty's Shop",
                            applicationVersion: "1.0.0",
                            applicationLegalese: "University Mobile Application Coursework Project",
                            children: const [
                              SizedBox(height: 10),
                              Text('Built with Flutter & Dart for Android Studio coursework demonstration.'),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ---------------- LOGOUT BUTTON ----------------
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Hetty’s Shop • Version 1.0.0 (Coursework Build)',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
