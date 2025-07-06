// lib/presentation/pages/dashboard/vendor_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_button.dart';

class VendorDashboardPage extends StatelessWidget {
  const VendorDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.vendorPrimary, AppColors.vendorSecondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Text(
                            authController.currentUser.value?.initials ?? 'V',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.vendorPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              Text(
                                authController.userName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (authController.storeName != null)
                                Text(
                                  authController.storeName!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.toNamed('/profile'),
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Store Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: authController.storeStatus == 'approved'
                            ? AppColors.success.withOpacity(0.2)
                            : AppColors.warning.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: authController.storeStatus == 'approved'
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            authController.storeStatus == 'approved'
                                ? Icons.check_circle
                                : Icons.pending,
                            size: 16,
                            color: authController.storeStatus == 'approved'
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Store ${authController.storeStatus?.toUpperCase() ?? 'PENDING'}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: authController.storeStatus == 'approved'
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: -0.3),

              const SizedBox(height: 30),

              // Quick Stats
              Text(
                'Quick Overview',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 16),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Products',
                      value: '0',
                      icon: Icons.inventory,
                      color: AppColors.vendorPrimary,
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      title: 'Orders',
                      value: '0',
                      icon: Icons.shopping_cart,
                      color: AppColors.info,
                    ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.3),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Revenue',
                      value: '₹0',
                      icon: Icons.monetization_on,
                      color: AppColors.success,
                    ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.3),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      title: 'Customers',
                      value: '0',
                      icon: Icons.people,
                      color: AppColors.warning,
                    ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.3),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Quick Actions
              Text(
                'Quick Actions',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(delay: 700.ms),

              const SizedBox(height: 16),

              // Action Cards
              Column(
                children: [
                  _QuickActionCard(
                    title: 'My Orders',
                    subtitle: 'Track your recent purchases',
                    icon: Icons.shopping_bag,
                    color: AppColors.customerPrimary,
                    onTap: () {
                      Get.snackbar('Info', 'My Orders feature coming soon!');
                    },
                  ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.3),

                  const SizedBox(height: 12),

                  _QuickActionCard(
                    title: 'Wishlist',
                    subtitle: 'View your saved items',
                    icon: Icons.favorite,
                    color: AppColors.error,
                    onTap: () {
                      Get.snackbar('Info', 'Wishlist feature coming soon!');
                    },
                  ).animate().fadeIn(delay: 900.ms).slideX(begin: 0.3),

                  const SizedBox(height: 12),

                  _QuickActionCard(
                    title: 'Cart',
                    subtitle: 'Review items in your cart',
                    icon: Icons.shopping_cart,
                    color: AppColors.success,
                    onTap: () {
                      Get.snackbar('Info', 'Cart feature coming soon!');
                    },
                  ).animate().fadeIn(delay: 1000.ms).slideX(begin: -0.3),

                  const SizedBox(height: 12),

                  _QuickActionCard(
                    title: 'Support',
                    subtitle: 'Get help and support',
                    icon: Icons.support_agent,
                    color: AppColors.warning,
                    onTap: () {
                      Get.snackbar('Info', 'Support feature coming soon!');
                    },
                  ).animate().fadeIn(delay: 1100.ms).slideX(begin: 0.3),
                ],
              ),

              const SizedBox(height: 30),

              // Logout Button
              CustomButton(
                text: 'Logout',
                backgroundColor: AppColors.error,
                icon: Icons.logout,
                outlined: true,
                onPressed: authController.logout,
              ).animate().fadeIn(delay: 1200.ms),
            ],
          )),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}