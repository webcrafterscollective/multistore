// lib/data/providers/api_client.dart (Enhanced)
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/security_utils.dart';
import '../../core/services/session_management_service.dart';

class ApiClient extends GetxService {
  late Dio dio;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  void _initializeDio() {
    dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl + AppConstants.apiVersion,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    // Add request/response interceptors
    dio.interceptors.add(_createAuthInterceptor());
    dio.interceptors.add(_createLoggingInterceptor());
    dio.interceptors.add(_createRetryInterceptor());
  }

  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token to requests
        final token = getToken();
        if (token != null && _isValidToken(token)) {
          options.headers['Authorization'] = 'Bearer $token';
          print('🔑 Using token: ${token.substring(0, 20)}...');
        }

        // Add request ID for tracking
        options.headers['X-Request-ID'] = SecurityUtils.generateSecureRandomString(16);

        handler.next(options);
      },
      onResponse: (response, handler) {
        // Update session on successful authenticated requests
        if (response.statusCode == 200 && _hasAuthToken(response.requestOptions)) {
          _extendSession();
        }
        handler.next(response);
      },
      onError: (error, handler) {
        // Handle authentication errors
        if (error.response?.statusCode == 401) {
          print('🚪 Unauthorized - handling token expiry');
          _handleUnauthorizedError();
        } else if (error.response?.statusCode == 403) {
          print('🚫 Forbidden - insufficient permissions');
          _handleForbiddenError();
        }
        handler.next(error);
      },
    );
  }

  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🌐 API Request: ${options.method} ${options.path}');
        if (options.data != null) {
          // Don't log sensitive data
          final sanitizedData = _sanitizeLogData(options.data);
          print('📤 Request Data: $sanitizedData');
        }
        if (options.queryParameters.isNotEmpty) {
          print('📋 Query Params: ${options.queryParameters}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ API Response: ${response.statusCode} ${response.requestOptions.path}');
        print('📥 Response Data: ${_sanitizeLogData(response.data)}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('❌ API Error: ${error.response?.statusCode} ${error.requestOptions.path}');
        print('❌ Error Data: ${error.response?.data}');
        print('❌ Error Message: ${error.message}');
        handler.next(error);
      },
    );
  }

  Interceptor _createRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        // Retry on network errors (not auth errors)
        if (_shouldRetryRequest(error)) {
          try {
            print('🔄 Retrying request: ${error.requestOptions.path}');
            final response = await dio.fetch(error.requestOptions);
            handler.resolve(response);
            return;
          } catch (e) {
            print('❌ Retry failed: $e');
          }
        }
        handler.next(error);
      },
    );
  }

  bool _shouldRetryRequest(DioException error) {
    // Only retry on network errors, not auth errors
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }

  bool _hasAuthToken(RequestOptions options) {
    return options.headers.containsKey('Authorization');
  }

  void _extendSession() {
    try {
      final sessionService = Get.find<SessionManagementService>();
      sessionService.extendSession();
    } catch (e) {
      // Session service might not be initialized yet
      print('⚠️ Could not extend session: $e');
    }
  }

  void _handleUnauthorizedError() {
    try {
      // Clear token and redirect to login
      clearToken();
      Get.offAllNamed('/');

      Get.snackbar(
        'Session Expired',
        'Your session has expired. Please login again.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      print('❌ Error handling unauthorized: $e');
    }
  }

  void _handleForbiddenError() {
    Get.snackbar(
      'Access Denied',
      'You don\'t have permission to perform this action.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  dynamic _sanitizeLogData(dynamic data) {
    if (data is Map) {
      final sanitized = Map<String, dynamic>.from(data);
      // Remove sensitive fields from logs
      final sensitiveFields = ['password', 'token', 'secret', 'key', 'authorization'];

      for (final field in sensitiveFields) {
        if (sanitized.containsKey(field)) {
          sanitized[field] = '***HIDDEN***';
        }
      }
      return sanitized;
    }
    return data;
  }

  bool _isValidToken(String token) {
    // Basic validation
    if (token.isEmpty || token.length < 10) {
      return false;
    }

    // If it's a JWT token, validate format and expiry
    if (SecurityUtils.isValidJWTFormat(token)) {
      return !SecurityUtils.isJWTExpired(token);
    }

    // For non-JWT tokens, assume valid if present
    return true;
  }

  String? getToken() {
    final token = storage.read(AppConstants.authTokenKey);
    print('🔍 Getting token from storage: ${token != null ? 'Found' : 'Not found'}');

    if (token != null && !_isValidToken(token)) {
      print('⚠️ Token is invalid or expired, clearing...');
      clearToken();
      return null;
    }

    return token;
  }

  void saveToken(String token) {
    print('💾 Saving token to storage: ${token.substring(0, 20)}...');
    storage.write(AppConstants.authTokenKey, token);

    // Record login time for session management
    try {
      final sessionService = Get.find<SessionManagementService>();
      sessionService.recordLoginTime();
      sessionService.startSession();
    } catch (e) {
      print('⚠️ Could not start session management: $e');
    }
  }

  void clearToken() {
    print('🗑️ Clearing token from storage');
    storage.remove(AppConstants.authTokenKey);

    // Clear session data
    try {
      final sessionService = Get.find<SessionManagementService>();
      sessionService.clearLoginTime();
      sessionService.endSession();
    } catch (e) {
      print('⚠️ Could not end session: $e');
    }
  }

  bool get isLoggedIn {
    final token = getToken();
    final hasToken = token != null;
    print('🔐 Is logged in: $hasToken');
    return hasToken;
  }

  /// Get token expiry information
  TokenInfo? getTokenInfo() {
    final token = getToken();
    if (token == null) return null;

    if (SecurityUtils.isValidJWTFormat(token)) {
      final payload = SecurityUtils.getJWTPayload(token);
      final expiry = SecurityUtils.getTokenExpiry(token);

      return TokenInfo(
        isValid: !SecurityUtils.isJWTExpired(token),
        expiryDate: expiry,
        payload: payload,
      );
    }

    return TokenInfo(isValid: true);
  }

  /// Manually refresh token
  Future<bool> refreshToken() async {
    try {
      // This would typically call a refresh endpoint
      // For now, we'll validate the current token
      final token = getToken();
      if (token == null) return false;

      if (_isValidToken(token)) {
        _extendSession();
        return true;
      } else {
        clearToken();
        return false;
      }
    } catch (e) {
      print('❌ Token refresh failed: $e');
      return false;
    }
  }
}

/// Token information class
class TokenInfo {
  final bool isValid;
  final DateTime? expiryDate;
  final Map<String, dynamic>? payload;

  TokenInfo({
    required this.isValid,
    this.expiryDate,
    this.payload,
  });

  Duration? get timeUntilExpiry {
    if (expiryDate == null) return null;
    return expiryDate!.difference(DateTime.now());
  }

  bool get isExpiringSoon {
    final timeLeft = timeUntilExpiry;
    if (timeLeft == null) return false;
    return timeLeft.inMinutes < 60; // Expiring in less than 1 hour
  }
}