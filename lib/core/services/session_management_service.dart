// lib/core/services/session_management_service.dart (Fixed)
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/providers/api_client.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../constants/app_constants.dart';

class SessionManagementService extends GetxService {
  final GetStorage _storage = GetStorage();
  Timer? _tokenRefreshTimer;
  Timer? _sessionTimeoutTimer;

  // Session timeout duration (24 hours)
  static const Duration sessionTimeout = Duration(hours: 24);

  // Token refresh interval (refresh 1 hour before expiry)
  static const Duration tokenRefreshInterval = Duration(hours: 23);

  @override
  void onInit() {
    super.onInit();
    // Defer session management start to allow other services to initialize
    Future.delayed(const Duration(milliseconds: 100), () {
      _startSessionManagement();
    });
  }

  @override
  void onClose() {
    _tokenRefreshTimer?.cancel();
    _sessionTimeoutTimer?.cancel();
    super.onClose();
  }

  void _startSessionManagement() {
    try {
      // Check if ApiClient is available
      if (!Get.isRegistered<ApiClient>()) {
        print('⚠️ ApiClient not yet registered, deferring session management');
        // Retry after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          _startSessionManagement();
        });
        return;
      }

      final apiClient = Get.find<ApiClient>();
      final token = apiClient.getToken();

      if (token != null) {
        _scheduleTokenRefresh();
        _scheduleSessionTimeout();
        print('✅ Session management started');
      } else {
        print('ℹ️ No token found, session management not started');
      }
    } catch (e) {
      print('❌ Error starting session management: $e');
      // Retry after a delay if there's an error
      Future.delayed(const Duration(seconds: 1), () {
        _startSessionManagement();
      });
    }
  }

  void _scheduleTokenRefresh() {
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = Timer.periodic(tokenRefreshInterval, (timer) {
      _refreshTokenIfNeeded();
    });
  }

  void _scheduleSessionTimeout() {
    _sessionTimeoutTimer?.cancel();
    _sessionTimeoutTimer = Timer(sessionTimeout, () {
      _handleSessionTimeout();
    });
  }

  Future<void> _refreshTokenIfNeeded() async {
    try {
      // Check if AuthController is available
      if (!Get.isRegistered<AuthController>()) {
        print('⚠️ AuthController not available for token refresh');
        return;
      }

      final authController = Get.find<AuthController>();
      if (authController.isLoggedIn.value && authController.currentUserType.value != null) {
        print('🔄 Refreshing session...');
        await authController.validateTokenWithServer();
      }
    } catch (e) {
      print('❌ Token refresh failed: $e');
      _handleSessionTimeout();
    }
  }

  void _handleSessionTimeout() {
    print('⏰ Session timeout - logging out user');
    try {
      if (Get.isRegistered<AuthController>()) {
        final authController = Get.find<AuthController>();
        authController.handleTokenExpiry();
      }
    } catch (e) {
      print('❌ Error handling session timeout: $e');
    }
    _stopSessionManagement();
  }

  void startSession() {
    print('🚀 Starting new session');
    _scheduleTokenRefresh();
    _scheduleSessionTimeout();
  }

  void _stopSessionManagement() {
    print('🛑 Stopping session management');
    _tokenRefreshTimer?.cancel();
    _sessionTimeoutTimer?.cancel();
  }

  void extendSession() {
    print('⏱️ Extending session');
    _scheduleSessionTimeout(); // Reset the timeout
  }

  void endSession() {
    print('🏁 Ending session');
    _stopSessionManagement();
  }

  /// Check if session is still valid based on stored timestamp
  bool isSessionValid() {
    final loginTime = _storage.read('login_time');
    if (loginTime == null) return false;

    final loginDateTime = DateTime.fromMillisecondsSinceEpoch(loginTime);
    final now = DateTime.now();

    return now.difference(loginDateTime) < sessionTimeout;
  }

  /// Store login timestamp
  void recordLoginTime() {
    _storage.write('login_time', DateTime.now().millisecondsSinceEpoch);
  }

  /// Clear login timestamp
  void clearLoginTime() {
    _storage.remove('login_time');
  }
}