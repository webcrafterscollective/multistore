// lib/core/utils/security_utils.dart
import 'dart:convert';
import 'dart:math';

class SecurityUtils {
  /// Generate a secure random string
  static String generateSecureRandomString(int length) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final random = Random.secure();
    return String.fromCharCodes(
        Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }

  /// Validate JWT token format (basic validation)
  static bool isValidJWTFormat(String token) {
    if (token.isEmpty) return false;

    final parts = token.split('.');
    if (parts.length != 3) return false;

    try {
      // Try to decode header and payload
      base64Decode(base64.normalize(parts[0]));
      base64Decode(base64.normalize(parts[1]));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Extract JWT payload without verification
  static Map<String, dynamic>? getJWTPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64.normalize(payload);
      final decoded = utf8.decode(base64Decode(normalized));

      return json.decode(decoded) as Map<String, dynamic>;
    } catch (e) {
      print('❌ Error extracting JWT payload: $e');
      return null;
    }
  }

  /// Check if JWT token is expired
  static bool isJWTExpired(String token) {
    final payload = getJWTPayload(token);
    if (payload == null) return true;

    final exp = payload['exp'];
    if (exp == null) return false; // No expiry set

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiryDate);
  }

  /// Get token expiry time
  static DateTime? getTokenExpiry(String token) {
    final payload = getJWTPayload(token);
    if (payload == null) return null;

    final exp = payload['exp'];
    if (exp == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }
}