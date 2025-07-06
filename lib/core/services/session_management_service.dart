// lib/core/services/session_management_service.dart
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
    _startSessionManagement();
  }

  @override
  void onClose() {
    _tokenRefreshTimer?.cancel();
    _sessionTimeoutTimer?.cancel();
    super.onClose();
  }

  void _startSessionManagement() {
    final apiClient = Get.find<ApiClient>();
    final token = apiClient.getToken();

    if (token != null) {
      _scheduleTokenRefresh();
      _scheduleSessionTimeout();
      print('✅ Session management started');
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
    final authController = Get.find<AuthController>();
    authController.handleTokenExpiry();
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
