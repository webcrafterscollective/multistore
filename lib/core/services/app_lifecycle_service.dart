// lib/core/services/app_lifecycle_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/auth_controller.dart';
import 'session_management_service.dart';

class AppLifecycleService extends GetxService with WidgetsBindingObserver {
  final RxBool isAppInForeground = true.obs;
  DateTime? _backgroundTime;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
      case AppLifecycleState.inactive:
      // App is inactive but still visible
        break;
      case AppLifecycleState.hidden:
      // App is hidden
        break;
    }
  }

  void _onAppResumed() {
    print('📱 App resumed');
    isAppInForeground.value = true;

    // Check if app was in background for too long
    if (_backgroundTime != null) {
      final backgroundDuration = DateTime.now().difference(_backgroundTime!);

      // If app was in background for more than 30 minutes, validate session
      if (backgroundDuration.inMinutes > 30) {
        _validateSessionAfterBackground();
      }

      _backgroundTime = null;
    }

    // Extend session if user is logged in
    final sessionService = Get.find<SessionManagementService>();
    sessionService.extendSession();
  }

  void _onAppPaused() {
    print('📱 App paused');
    isAppInForeground.value = false;
    _backgroundTime = DateTime.now();
  }

  void _onAppDetached() {
    print('📱 App detached');
    isAppInForeground.value = false;
  }

  void _validateSessionAfterBackground() {
    print('🔍 Validating session after long background period');
    final authController = Get.find<AuthController>();
    final sessionService = Get.find<SessionManagementService>();

    if (authController.isLoggedIn.value) {
      if (sessionService.isSessionValid()) {
        authController.validateTokenWithServer();
      } else {
        authController.handleTokenExpiry();
      }
    }
  }
}
