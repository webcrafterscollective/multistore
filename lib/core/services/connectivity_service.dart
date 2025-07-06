// lib/core/services/connectivity_service.dart (Fixed)
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/auth_controller.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      print('❌ Connectivity check failed: $e');
      isConnected.value = false;
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final wasConnected = isConnected.value;

    // Check if any of the connectivity results indicate a connection
    // ConnectivityResult.none means no connectivity
    isConnected.value = results.any((result) => result != ConnectivityResult.none);

    if (!wasConnected && isConnected.value) {
      print('🌐 Internet connection restored');
      // Optionally trigger data sync or token validation
      _onConnectionRestored();
    } else if (wasConnected && !isConnected.value) {
      print('📵 Internet connection lost');
      _onConnectionLost();
    }
  }

  void _onConnectionRestored() {
    // Validate session when connection is restored
    try {
      if (Get.isRegistered<AuthController>()) {
        final authController = Get.find<AuthController>();
        if (authController.isLoggedIn.value) {
          authController.validateTokenWithServer();
        }
      }
    } catch (e) {
      print('⚠️ Could not validate token on connection restore: $e');
    }
  }

  void _onConnectionLost() {
    // Handle offline state
    Get.snackbar(
      'Connection Lost',
      'Please check your internet connection',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  /// Get the primary connectivity type
  ConnectivityResult get primaryConnectivity {
    // This is a helper method if you need to get a single connectivity type
    // for backward compatibility or specific use cases
    if (!isConnected.value) {
      return ConnectivityResult.none;
    }

    // You could implement logic here to determine the "primary" connection
    // For now, we'll just return a default
    return ConnectivityResult.wifi; // or mobile, depending on your logic
  }

  /// Check if connected to WiFi
  Future<bool> get isConnectedToWiFi async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.contains(ConnectivityResult.wifi);
    } catch (e) {
      return false;
    }
  }

  /// Check if connected to mobile data
  Future<bool> get isConnectedToMobile async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.contains(ConnectivityResult.mobile);
    } catch (e) {
      return false;
    }
  }

  /// Get detailed connectivity information
  Future<List<ConnectivityResult>> get connectivityResults async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (e) {
      return [ConnectivityResult.none];
    }
  }
}