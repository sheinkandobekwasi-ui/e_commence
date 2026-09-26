/// ============================================================================
/// UserProfile Model
/// Coursework Concept: User Authentication & State Modeling
/// ============================================================================
class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String avatarUrl;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    this.avatarUrl = 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80',
  });
}
