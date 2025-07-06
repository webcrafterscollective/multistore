// lib/presentation/pages/dashboard/customer_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/vendor_controller.dart';
import '../../widgets/common/custom_button.dart';

class CustomerDashboardPage extends StatelessWidget {
  const CustomerDashboardPage({super.key});

  // Default categories for fallback
  static const List<Map<String, dynamic>> _defaultCategories = [
    {
      'name': 'Electronics',
      'icon': Icons.phone_android,
      'color': AppColors.customerPrimary,
      'count': 0,
    },
    {
      'name': 'Fashion',
      'icon': Icons.checkroom,
      'color': AppColors.vendorPrimary,
      'count': 0,
    },
    {
      'name': 'Groceries',
      'icon': Icons.shopping_cart,
      'color': AppColors.success,
      'count': 0,
    },
    {
      'name': 'Books',
      'icon': Icons.book,
      'color': AppColors.warning,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final vendorController = Get.put(VendorController(Get.find())); // Inject vendor controller

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Explore Stores',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Search functionality
              _showSearchBottomSheet(context, vendorController);
            },
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
          ),
          IconButton(
            onPressed: () {
              // Filter functionality
              _showFilterBottomSheet(context, vendorController);
            },
            icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/profile'),
            icon: const Icon(Icons.person, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // await vendorController.refreshVendors();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Header
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.customerPrimary, AppColors.customerSecondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Obx(() => Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${authController.userName}! 👋',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Discover amazing stores and products',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(() => Text(
                              '${vendorController.totalVendorsCount} stores available',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.store,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  )),
                ).animate().fadeIn().slideY(begin: -0.3),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Shop by Category',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Obx(() => Text(
                            '${vendorController.categoriesCount} categories',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        if (vendorController.categories.isEmpty && vendorController.isLoading.value) {
                          return SizedBox(
                            height: 110, // Conservative height that accommodates all content
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemCount: 4,
                              itemBuilder: (context, index) => _buildSkeletonCategory(index),
                            ),
                          );
                        }

                        if (vendorController.categories.isEmpty) {
                          return SizedBox(
                            height: 110, // Conservative height that accommodates all content
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemCount: _defaultCategories.length,
                              itemBuilder: (context, index) {
                                final category = _defaultCategories[index];
                                return _buildCategoryItem(category, index, vendorController);
                              },
                            ),
                          );
                        }

                        return SizedBox(
                          height: 110, // Conservative height that accommodates all content
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            itemCount: vendorController.categories.length,
                            itemBuilder: (context, index) {
                              final category = vendorController.categories[index];
                              final categoryData = {
                                'name': category.name,
                                'icon': _getCategoryIcon(category.name),
                                'color': _getCategoryColor(index),
                                'count': category.vendorCount,
                              };
                              return _buildCategoryItem(categoryData, index, vendorController);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                // Categories Section - Flexible Height Approach
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           const Text(
                //             'Shop by Category',
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //               color: AppColors.textPrimary,
                //             ),
                //           ),
                //           Obx(() => Text(
                //             '${vendorController.categoriesCount} categories',
                //             style: const TextStyle(
                //               fontSize: 12,
                //               color: AppColors.textSecondary,
                //             ),
                //           )),
                //         ],
                //       ),
                //       const SizedBox(height: 16),
                //       Obx(() {
                //         if (vendorController.categories.isEmpty && vendorController.isLoading.value) {
                //           return Container(
                //             constraints: const BoxConstraints(
                //               minHeight: 100,
                //               maxHeight: 140, // Allow flexible height
                //             ),
                //             child: ListView.builder(
                //               scrollDirection: Axis.horizontal,
                //               padding: EdgeInsets.zero,
                //               itemCount: 4,
                //               itemBuilder: (context, index) => _buildSkeletonCategory(index),
                //             ),
                //           );
                //         }
                //
                //         if (vendorController.categories.isEmpty) {
                //           return Container(
                //             constraints: const BoxConstraints(
                //               minHeight: 100,
                //               maxHeight: 140, // Allow flexible height
                //             ),
                //             child: ListView.builder(
                //               scrollDirection: Axis.horizontal,
                //               padding: EdgeInsets.zero,
                //               itemCount: _defaultCategories.length,
                //               itemBuilder: (context, index) {
                //                 final category = _defaultCategories[index];
                //                 return _buildCategoryItem(category, index, vendorController);
                //               },
                //             ),
                //           );
                //         }
                //
                //         return Container(
                //           constraints: const BoxConstraints(
                //             minHeight: 100,
                //             maxHeight: 140, // Allow flexible height
                //           ),
                //           child: ListView.builder(
                //             scrollDirection: Axis.horizontal,
                //             padding: EdgeInsets.zero,
                //             itemCount: vendorController.categories.length,
                //             itemBuilder: (context, index) {
                //               final category = vendorController.categories[index];
                //               final categoryData = {
                //                 'name': category.name,
                //                 'icon': _getCategoryIcon(category.name),
                //                 'color': _getCategoryColor(index),
                //                 'count': category.vendorCount,
                //               };
                //               return _buildCategoryItem(categoryData, index, vendorController);
                //             },
                //           ),
                //         );
                //       }),
                //     ],
                //   ),
                // ),
                // Categories Section
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           const Text(
                //             'Shop by Category',
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //               color: AppColors.textPrimary,
                //             ),
                //           ),
                //           Obx(() => Text(
                //             '${vendorController.categoriesCount} categories',
                //             style: const TextStyle(
                //               fontSize: 12,
                //               color: AppColors.textSecondary,
                //             ),
                //           )),
                //         ],
                //       ),
                //       const SizedBox(height: 16),
                //
                //       Obx(() {
                //         if (vendorController.categories.isEmpty && vendorController.isLoading.value) {
                //           return SizedBox(
                //             height: 120, // Increased height to accommodate content
                //             child: ListView.builder(
                //               scrollDirection: Axis.horizontal,
                //               itemCount: 4,
                //               itemBuilder: (context, index) => _buildSkeletonCategory(index),
                //             ),
                //           );
                //         }
                //
                //         if (vendorController.categories.isEmpty) {
                //           return SizedBox(
                //             height: 120, // Increased height to accommodate content
                //             child: ListView.builder(
                //               scrollDirection: Axis.horizontal,
                //               itemCount: _defaultCategories.length,
                //               itemBuilder: (context, index) {
                //                 final category = _defaultCategories[index];
                //                 return _buildCategoryItem(category, index, vendorController);
                //               },
                //             ),
                //           );
                //         }
                //
                //         return SizedBox(
                //           height: 120, // Increased height to accommodate content
                //           child: ListView.builder(
                //             scrollDirection: Axis.horizontal,
                //             itemCount: vendorController.categories.length,
                //             itemBuilder: (context, index) {
                //               final category = vendorController.categories[index];
                //               final categoryData = {
                //                 'name': category.name,
                //                 'icon': _getCategoryIcon(category.name),
                //                 'color': _getCategoryColor(index),
                //                 'count': category.vendorCount,
                //               };
                //               return _buildCategoryItem(categoryData, index, vendorController);
                //             },
                //           ),
                //         );
                //       }),
                //     ],
                //   ),
                // ),

                const SizedBox(height: 30),

                // Featured Stores Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Featured Stores',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Obx(() => Text(
                            '${vendorController.approvedVendorsCount} approved stores',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          )),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to all stores
                          _showAllStoresBottomSheet(context, vendorController);
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: AppColors.customerPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Featured Stores Horizontal List
                Obx(() {
                  if (vendorController.isLoading.value && vendorController.featuredVendors.isEmpty) {
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: 3,
                        itemBuilder: (context, index) => _buildSkeletonFeaturedCard(),
                      ),
                    );
                  }

                  if (vendorController.featuredVendors.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.store_outlined, size: 48, color: AppColors.textSecondary),
                              SizedBox(height: 12),
                              Text(
                                'No featured stores available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                'Check back later for new stores',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: vendorController.featuredVendors.length,
                      itemBuilder: (context, index) {
                        final vendor = vendorController.featuredVendors[index];
                        return _FeaturedStoreCard(
                          vendor: vendor,
                          onTap: () => _navigateToStoreDetail(vendor),
                        ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX(begin: 0.5);
                      },
                    ),
                  );
                }),

                const SizedBox(height: 30),

                // Store Statistics
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(() => Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Total Stores',
                          value: vendorController.totalVendorsCount.toString(),
                          icon: Icons.store,
                          color: AppColors.customerPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Open Now',
                          value: vendorController.approvedVendorsCount.toString(),
                          icon: Icons.schedule,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Categories',
                          value: vendorController.categoriesCount.toString(),
                          icon: Icons.category,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  )),
                ),

                const SizedBox(height: 30),

                // All Stores Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'All Stores',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Obx(() => Text(
                            'Showing ${vendorController.vendors.length} stores',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Toggle view mode (grid/list)
                              _showViewOptionsBottomSheet(context, vendorController);
                            },
                            icon: const Icon(Icons.view_module, size: 20),
                          ),
                          IconButton(
                            onPressed: () {
                              // Sort options
                              _showSortBottomSheet(context, vendorController);
                            },
                            icon: const Icon(Icons.sort, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // All Stores Grid
                Obx(() {
                  if (vendorController.isLoading.value && vendorController.vendors.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) => _buildSkeletonStoreCard(),
                      ),
                    );
                  }

                  if (vendorController.vendors.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.store_outlined, size: 64, color: AppColors.textSecondary),
                            const SizedBox(height: 16),
                            const Text(
                              'No stores found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Try adjusting your filters or search terms',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => vendorController.clearFilters(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.customerPrimary,
                              ),
                              child: const Text('Clear Filters'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: vendorController.vendors.length,
                      itemBuilder: (context, index) {
                        final vendor = vendorController.vendors[index];
                        return _StoreCard(
                          vendor: vendor,
                          onTap: () => _navigateToStoreDetail(vendor),
                        ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).scale(begin: const Offset(0.8, 0.8));
                      },
                    ),
                  );
                }),

                // Load More Button (if needed for pagination)
                Obx(() {
                  if (vendorController.hasMorePages.value) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: vendorController.isLoadingMore.value
                              ? null
                              : () => vendorController.getVendors(loadMore: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.customerPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: vendorController.isLoadingMore.value
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text(
                            'Load More Stores',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                const SizedBox(height: 100), // Bottom padding for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => authController.logout(),
        backgroundColor: AppColors.error,
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'Logout',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Helper Methods
  // Helper Methods - Final Category Item Fix
  // Ultra-Safe Category Item - Prevents any overflow
  Widget _buildCategoryItem(Map<String, dynamic> category, int index, VendorController vendorController) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          vendorController.filterByCategory(category['name']);
          Get.snackbar(
            'Category Filter',
            'Showing ${category['name']} stores',
            backgroundColor: AppColors.customerPrimary,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        },
        child: IntrinsicHeight( // This prevents overflow by sizing to content
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Category Icon Container
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: category['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: category['color'].withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  category['icon'],
                  color: category['color'],
                  size: 28,
                ),
              ),

              // Spacing
              const SizedBox(height: 6), // Reduced spacing

              // Category Name - with ClipRect to prevent overflow
              ClipRect(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 32, // Maximum height for text
                  ),
                  child: Text(
                    category['name'],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      height: 1.0, // Minimal line height
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX(begin: 0.3);
  }

  Widget _buildSkeletonCategory(int index) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: SizedBox(
        height: 120, // Fixed container height
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Skeleton Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            // Fixed spacing
            const SizedBox(height: 8),

            // Skeleton Text Area
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 10,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().shimmer(delay: Duration(milliseconds: 100 * index));
  }

  Widget _buildSkeletonFeaturedCard() {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
    ).animate().shimmer();
  }

  Widget _buildSkeletonStoreCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
    ).animate().shimmer();
  }

  void _navigateToStoreDetail(dynamic vendor) {
    Get.snackbar(
      'Store Selected',
      'Opening ${vendor.storeName} store...',
      backgroundColor: AppColors.customerPrimary,
      colorText: Colors.white,
      icon: const Icon(Icons.store, color: Colors.white),
      duration: const Duration(seconds: 2),
    );

    // TODO: Navigate to store detail page
    // Get.toNamed('/store-detail', arguments: vendor);
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electronics':
        return Icons.phone_android;
      case 'fashion':
        return Icons.checkroom;
      case 'retail':
      case 'groceries':
      case 'food':
        return Icons.shopping_cart;
      case 'books':
        return Icons.book;
      case 'home':
      case 'home & garden':
        return Icons.home;
      case 'sports':
        return Icons.sports_soccer;
      case 'beauty':
        return Icons.face;
      case 'automotive':
        return Icons.directions_car;
      case 'health':
        return Icons.local_pharmacy;
      case 'toys':
        return Icons.toys;
      default:
        return Icons.store;
    }
  }

  Color _getCategoryColor(int index) {
    final colors = [
      AppColors.customerPrimary,
      AppColors.vendorPrimary,
      AppColors.warning,
      AppColors.success,
      AppColors.error,
      AppColors.info,
    ];
    return colors[index % colors.length];
  }

  void _showSearchBottomSheet(BuildContext context, VendorController vendorController) {
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      onChanged: (value) {
                        searchQuery = value;
                        if (value.isEmpty) {
                          vendorController.clearFilters();
                        } else {
                          vendorController.searchVendors(value);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Search stores, categories...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            vendorController.clearFilters();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (vendorController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vendorController.vendors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.isEmpty ? 'Start typing to search stores' : 'No stores found',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (searchQuery.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Try different keywords or clear filters',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: vendorController.vendors.length,
                  itemBuilder: (context, index) {
                    final vendor = vendorController.vendors[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: vendor.displayImage.isNotEmpty
                              ? NetworkImage(vendor.displayImage)
                              : null,
                          backgroundColor: AppColors.customerPrimary.withOpacity(0.1),
                          child: vendor.displayImage.isEmpty
                              ? const Icon(Icons.store, color: AppColors.customerPrimary)
                              : null,
                        ),
                        title: Text(
                          vendor.storeName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vendor.storeType),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: vendor.isOpen ? AppColors.success : AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  vendor.statusBadge,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: vendor.isOpen ? AppColors.success : AppColors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, size: 14, color: AppColors.warning),
                                const SizedBox(width: 2),
                                Text(vendor.rating.toStringAsFixed(1)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vendor.deliveryTime,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.customerPrimary,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.back();
                          _navigateToStoreDetail(vendor);
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, VendorController vendorController) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Stores',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilterChip(
                    label: const Text('All'),
                    selected: false,
                    onSelected: (selected) {
                      vendorController.filterByStatus(null);
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChip(
                    label: const Text('Open'),
                    selected: false,
                    onSelected: (selected) {
                      vendorController.filterByStatus(true);
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChip(
                    label: const Text('Closed'),
                    selected: false,
                    onSelected: (selected) {
                      vendorController.filterByStatus(false);
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      vendorController.clearFilters();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.customerPrimary,
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAllStoresBottomSheet(BuildContext context, VendorController vendorController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    'All Stores',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (vendorController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vendorController.vendors.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.store_outlined, size: 64, color: AppColors.textSecondary),
                        SizedBox(height: 16),
                        Text(
                          'No stores available',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: vendorController.vendors.length,
                  itemBuilder: (context, index) {
                    final vendor = vendorController.vendors[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: vendor.displayImage.isNotEmpty
                              ? NetworkImage(vendor.displayImage)
                              : null,
                          backgroundColor: AppColors.customerPrimary.withOpacity(0.1),
                          child: vendor.displayImage.isEmpty
                              ? const Icon(Icons.store, color: AppColors.customerPrimary)
                              : null,
                        ),
                        title: Text(
                          vendor.storeName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vendor.storeType),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: vendor.isOpen ? AppColors.success : AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  vendor.statusBadge,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: vendor.isOpen ? AppColors.success : AppColors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.back();
                          _navigateToStoreDetail(vendor);
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showViewOptionsBottomSheet(BuildContext context, VendorController vendorController) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'View Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.grid_view),
              title: const Text('Grid View'),
              trailing: const Icon(Icons.check, color: AppColors.success),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('List View'),
              onTap: () {
                Get.back();
                Get.snackbar('Info', 'List view coming soon!');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context, VendorController vendorController) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Store Name (A-Z)'),
              onTap: () {
                vendorController.setSortOrder('store_name', 'asc');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Store Name (Z-A)'),
              onTap: () {
                vendorController.setSortOrder('store_name', 'desc');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Category'),
              onTap: () {
                vendorController.setSortOrder('store_type', 'asc');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Recently Added'),
              onTap: () {
                vendorController.setSortOrder('created_at', 'desc');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Classes
class _FeaturedStoreCard extends StatelessWidget {
  final dynamic vendor;
  final VoidCallback onTap;

  const _FeaturedStoreCard({
    required this.vendor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.customerPrimary.withOpacity(0.7),
                      AppColors.customerPrimary,
                    ],
                  ),
                ),
                child: vendor.displayImage.isNotEmpty
                    ? Image.network(
                  vendor.displayImage,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.customerPrimary.withOpacity(0.1),
                    child: const Icon(
                      Icons.store,
                      size: 48,
                      color: AppColors.customerPrimary,
                    ),
                  ),
                )
                    : const Center(
                  child: Icon(
                    Icons.store,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),

              // Gradient Overlay
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.storeName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vendor.storeType,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: vendor.isOpen ? AppColors.success : AppColors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            vendor.statusBadge,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.warning, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              vendor.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    vendor.deliveryTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final dynamic vendor;
  final VoidCallback onTap;

  const _StoreCard({
    required this.vendor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Store Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: AppColors.customerPrimary.withOpacity(0.1),
                ),
                child: vendor.displayImage.isNotEmpty
                    ? ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    vendor.displayImage,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.store,
                        size: 32,
                        color: AppColors.customerPrimary,
                      ),
                    ),
                  ),
                )
                    : const Center(
                  child: Icon(
                    Icons.store,
                    size: 32,
                    color: AppColors.customerPrimary,
                  ),
                ),
              ),
            ),

            // Store Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.storeName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vendor.storeType,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: vendor.isOpen ? AppColors.success : AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vendor.statusBadge,
                          style: TextStyle(
                            fontSize: 10,
                            color: vendor.isOpen ? AppColors.success : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.warning, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              vendor.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}