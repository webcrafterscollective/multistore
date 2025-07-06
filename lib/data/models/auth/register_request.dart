// lib/data/models/auth/register_request.dart
class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;
  final String storeName;
  final String storeSlug;
  final String storeType;
  final String contactNumber;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
    required this.storeName,
    required this.storeSlug,
    required this.storeType,
    required this.contactNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
      'store_name': storeName,
      'store_slug': storeSlug,
      'store_type': storeType,
      'contact_number': contactNumber,
    };
  }
}