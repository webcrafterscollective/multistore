// lib/presentation/pages/customer/store/store_detail_page.dart - Part 1
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/vendor/vendor_list_response.dart';
import '../../../../data/models/product/product_list_response.dart';
import '../../../controllers/vendor_controller.dart';
import '../../../controllers/product_controller.dart';
import '../../../widgets/common/loading_overlay.dart';

class StoreDetailPage extends StatefulWidget {
  const StoreDetailPage({super.key});

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> with SingleTickerProviderStateMixin {
  late VendorItem vendor;
  late VendorController vendorController;
  late ProductController productController;
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late ScrollController scrollController;

  bool isGridView = true;
  bool showFAB = false;
  int cartItemCount = 0;

  @override
  void initState() {
    super.initState();

    // Get vendor data from arguments
    vendor = Get.arguments as VendorItem;

    // Initialize controllers
    vendorController = Get.find<VendorController>();
    productController = Get.put(ProductController(Get.find()));

    // Initialize animations
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    // Initialize scroll controller
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);

    // Load store-specific products
    _loadStoreProducts();

    // Start animations
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _loadStoreProducts() {
    productController.queryParams.value = productController.queryParams.value.copyWith(
      adminId: vendor.adminId,
      perPage: 20,
    );
    productController.getProducts();
  }

  void _onScroll() {
    // Show/hide FAB based on scroll position
    if (scrollController.offset > 200 && !showFAB) {
      setState(() => showFAB = true);
    } else if (scrollController.offset <= 200 && showFAB) {
      setState(() => showFAB = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          // Store Header with Hero Image
          _buildStoreHeader(),

          // Store Information Card
          _buildStoreInfoCard(),

          // Quick Actions Bar
          _buildQuickActionsBar(),

          // Product Categories Filter
          _buildCategoriesFilter(),

          // Search and Sort Bar
          _buildSearchSortBar(),

          // Products Section Header
          _buildProductsSectionHeader(),

          // Products Grid/List
          _buildProductsGrid(),

          // Load More Section
          _buildLoadMoreSection(),

          // Footer Spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),

      // Floating Action Button for Cart
      floatingActionButton: AnimatedScale(
        scale: showFAB ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton.extended(
          onPressed: _openCart,
          backgroundColor: AppColors.customerPrimary,
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          label: Text(
            'Cart ($cartItemCount)',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Store Header with Hero Image and Basic Info
  Widget _buildStoreHeader() {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.customerPrimary,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: _toggleFavorite,
            icon: const Icon(Icons.favorite_border, color: Colors.white),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: _shareStore,
            icon: const Icon(Icons.share, color: Colors.white),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Store Banner/Image
            vendor.displayImage.isNotEmpty
                ? Image.network(
              vendor.displayImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildDefaultStoreBackground(),
            )
                : _buildDefaultStoreBackground(),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),

            // Store Information Overlay
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Name
                    Text(
                      vendor.storeName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Store Type and Status Row
                    Row(
                      children: [
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: vendor.isOpen ? AppColors.success : AppColors.error,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                vendor.statusBadge,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Store Type Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Text(
                            vendor.storeType,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Rating and Reviews
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: AppColors.warning, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                vendor.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                ' (${vendor.reviewCount})',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Store Description
                    if (vendor.about.isNotEmpty)
                      Text(
                        vendor.about,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                    const SizedBox(height: 12),

                    // Delivery Info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.customerPrimary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.delivery_dining, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                vendor.deliveryTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        if (vendor.admin?.fullAddress.isNotEmpty == true)
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.white70, size: 14),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    vendor.admin!.fullAddress,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildDefaultStoreBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.customerPrimary,
            AppColors.customerSecondary,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.store,
          size: 80,
          color: Colors.white,
        ),
      ),
    );
  }

  // Store Information Card with Statistics
  Widget _buildStoreInfoCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
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
          children: [
            // Statistics Row
            Row(
              children: [
                Expanded(
                  child: _StoreStatItem(
                    icon: Icons.schedule,
                    label: 'Delivery',
                    value: vendor.deliveryTime,
                    color: AppColors.customerPrimary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: _StoreStatItem(
                    icon: Icons.phone,
                    label: 'Contact',
                    value: vendor.contactNumber,
                    color: AppColors.success,
                    onTap: _callStore,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: Obx(() => _StoreStatItem(
                    icon: Icons.inventory,
                    label: 'Products',
                    value: productController.totalItems.toString(),
                    color: AppColors.warning,
                  )),
                ),
              ],
            ),

            // Store Address (if available)
            if (vendor.admin != null && vendor.admin!.fullAddress.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.customerPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.customerPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Store Address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vendor.admin!.fullAddress,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _openMap,
                    icon: const Icon(
                      Icons.directions,
                      color: AppColors.customerPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
    );
  }

  // Quick Actions Bar
  Widget _buildQuickActionsBar() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.phone,
                label: 'Call',
                color: AppColors.success,
                onTap: _callStore,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.directions,
                label: 'Directions',
                color: AppColors.info,
                onTap: _openMap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.share,
                label: 'Share',
                color: AppColors.warning,
                onTap: _shareStore,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.favorite_border,
                label: 'Save',
                color: AppColors.error,
                onTap: _toggleFavorite,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3),
    );
  }

  // Product Categories Filter
  Widget _buildCategoriesFilter() {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Obx(() {
          // Get unique categories from products
          final categories = <String>{'All Products'};
          for (final product in productController.products) {
            categories.add(product.product.category.name);
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories.elementAt(index);
              final isSelected = category == 'All Products'
                  ? productController.queryParams.value.categoryId == null
                  : productController.queryParams.value.categoryId != null;

              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected && category == 'All Products',
                  onSelected: (selected) {
                    if (category == 'All Products') {
                      productController.filterByCategory(null);
                    } else {
                      // Find category ID and filter
                      final categoryItem = productController.products
                          .firstWhere((p) => p.product.category.name == category)
                          .product.category;
                      productController.filterByCategory(categoryItem.id);
                    }
                  },
                  backgroundColor: Colors.white,
                  selectedColor: AppColors.customerPrimary.withOpacity(0.2),
                  checkmarkColor: AppColors.customerPrimary,
                  side: BorderSide(
                    color: isSelected && category == 'All Products'
                        ? AppColors.customerPrimary
                        : Colors.grey[300]!,
                  ),
                ),
              );
            },
          );
        }),
      ).animate().fadeIn(delay: 400.ms),
    );
  }

  // Search and Sort Bar
  Widget _buildSearchSortBar() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Search Field
            Expanded(
              child: Container(
                height: 48,
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
                child: TextField(
                  onChanged: (value) {
                    productController.searchProducts(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products in ${vendor.storeName}...',
                    hintStyle: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Sort Button
            Container(
              height: 48,
              width: 48,
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
              child: IconButton(
                onPressed: () => _showSortBottomSheet(context),
                icon: const Icon(
                  Icons.sort,
                  color: AppColors.customerPrimary,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // View Toggle Button
            Container(
              height: 48,
              width: 48,
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
              child: IconButton(
                onPressed: _toggleView,
                icon: Icon(
                  isGridView ? Icons.list : Icons.grid_view,
                  color: AppColors.customerPrimary,
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.3),
    );
  }

  // Products Section Header
  Widget _buildProductsSectionHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Text(
              'Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Obx(() => Text(
              '${productController.products.length} items',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            )),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.customerPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() {
                final inStockCount = productController.products
                    .where((p) => p.stock > 0)
                    .length;
                return Text(
                  '$inStockCount in stock',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.customerPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 600.ms),
    );
  }

  // Helper method implementations for actions
  void _callStore() {
    Get.snackbar(
      'Calling Store',
      'Calling ${vendor.storeName} at ${vendor.contactNumber}...',
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      icon: const Icon(Icons.phone, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  void _openMap() {
    Get.snackbar(
      'Opening Directions',
      'Opening map directions to ${vendor.storeName}...',
      backgroundColor: AppColors.info,
      colorText: Colors.white,
      icon: const Icon(Icons.directions, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  void _shareStore() {
    Get.snackbar(
      'Sharing Store',
      'Sharing ${vendor.storeName} with friends...',
      backgroundColor: AppColors.warning,
      colorText: Colors.white,
      icon: const Icon(Icons.share, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  void _toggleFavorite() {
    Get.snackbar(
      'Added to Favorites',
      '${vendor.storeName} added to your favorites!',
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      icon: const Icon(Icons.favorite, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  void _toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  void _openCart() {
    Get.snackbar(
      'Opening Cart',
      'Cart feature coming soon!',
      backgroundColor: AppColors.customerPrimary,
      colorText: Colors.white,
      icon: const Icon(Icons.shopping_cart, color: Colors.white),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            _SortOption(
              title: 'Price: Low to High',
              onTap: () {
                productController.setSortOrder('price', 'asc');
                Get.back();
              },
            ),
            _SortOption(
              title: 'Price: High to Low',
              onTap: () {
                productController.setSortOrder('price', 'desc');
                Get.back();
              },
            ),
            _SortOption(
              title: 'Name: A to Z',
              onTap: () {
                productController.setSortOrder('name', 'asc');
                Get.back();
              },
            ),
            _SortOption(
              title: 'Newest First',
              onTap: () {
                productController.setSortOrder('created_at', 'desc');
                Get.back();
              },
            ),
            _SortOption(
              title: 'Most Popular',
              onTap: () {
                productController.setSortOrder('total_sold', 'desc');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }