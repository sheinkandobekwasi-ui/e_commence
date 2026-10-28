import 'package:flutter/foundation.dart';

/// ============================================================================
/// AdminService
/// Coursework Concept: Admin Authentication & Access Management
/// ============================================================================
/// Manages administrator session, credentials, and access control for the
/// Admin Panel & Product Management dashboard.
class AdminService extends ChangeNotifier {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  bool _isAdminLoggedIn = false;
  final String _adminName = 'System Administrator';
  String _adminEmail = 'admin@sheistore.com';

  bool get isAdminLoggedIn => _isAdminLoggedIn;
  String get adminName => _adminName;
  String get adminEmail => _adminEmail;

  /// Default credentials for administrator demo & grading access
  static const String defaultAdminEmail = 'admin@sheistore.com';
  static const String defaultAdminPassword = 'admin123';

  /// Authenticate administrator
  bool login(String email, String password) {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPass = password.trim();

    final isAuthorizedEmail = cleanEmail == defaultAdminEmail ||
        cleanEmail == 'admin@shei.com' ||
        cleanEmail == 'admin@hettysshop.com' ||
        cleanEmail == 'admin';

    final isAuthorizedPassword = cleanPass == defaultAdminPassword ||
        cleanPass == 'shei2026' ||
        cleanPass == 'hetty2026';

    if (isAuthorizedEmail && isAuthorizedPassword) {
      _isAdminLoggedIn = true;
      _adminEmail = cleanEmail.contains('@') ? cleanEmail : defaultAdminEmail;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Log out administrator
  void logout() {
    _isAdminLoggedIn = false;
    notifyListeners();
  }
}
