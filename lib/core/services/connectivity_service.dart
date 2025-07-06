// lib/core/services/connectivity_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/auth_controller.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus as void Function(List<ConnectivityResult> event)?) as StreamSubscription<ConnectivityResult>;
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result as ConnectivityResult);
    } catch (e) {
      print('❌ Connectivity check failed: $e');
      isConnected.value = false;
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final wasConnected = isConnected.value;
    isConnected.value = result != ConnectivityResult.none;

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
    final authController = Get.find<AuthController>();
    if (authController.isLoggedIn.value) {
      authController.validateTokenWithServer();
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
}
