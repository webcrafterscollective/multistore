// lib/data/models/auth/customer_register_request.dart
class CustomerRegisterRequest {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;

  CustomerRegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
    };
  }
}