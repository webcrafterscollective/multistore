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
  const CustomerDashboardPage({Key? key}) : super(key: key);

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
            await vendorController.refreshVendors();
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

                // Categories Section
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
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) => _buildSkeletonCategory(index),
                            ),
                          );
                        }

                        if (vendorController.categories.isEmpty) {
                          return SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _defaultCategories.length,
                              itemBuilder: (context, index) {
                                final category = _defaultCategories[index];
                                return _buildCategoryItem(category, index, vendorController);
                              },
                            ),
                          );
                        }

                        return SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
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
        child: Column(
          children: [
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
            const SizedBox(height: 8),
            Text(
              category['name'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX(begin: 0.3);
  }

  Widget _buildSkeletonCategory(int index) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 12,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
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
