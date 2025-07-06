// lib/presentation/pages/vendor/products/vendor_products_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/product/product_list_response.dart';
import '../../../controllers/product_controller.dart';
import '../../../controllers/category_controller.dart';
import '../../../widgets/common/loading_overlay.dart';

class VendorProductsPage extends StatelessWidget {
  const VendorProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController(Get.find()));
    final categoryController = Get.put(CategoryController(Get.find()));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Products',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showSearchBottomSheet(context, productController),
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
          ),
          IconButton(
            onPressed: () => _showFilterBottomSheet(context, productController, categoryController),
            icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'sort':
                  _showSortBottomSheet(context, productController);
                  break;
                case 'refresh':
                  productController.refreshProducts();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort, size: 20),
                    SizedBox(width: 12),
                    Text('Sort'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 12),
                    Text('Refresh'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() => LoadingOverlay(
        isLoading: productController.isLoading.value && productController.products.isEmpty,
        child: RefreshIndicator(
          onRefresh: () async => productController.refreshProducts(),
          child: Column(
            children: [
              // Stats Header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.vendorPrimary, AppColors.vendorSecondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        title: 'Total Products',
                        value: productController.totalItems.toString(),
                        icon: Icons.inventory,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    Expanded(
                      child: _StatItem(
                        title: 'In Stock',
                        value: productController.products
                            .where((p) => p.stock > 0)
                            .length
                            .toString(),
                        icon: Icons.check_circle,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    Expanded(
                      child: _StatItem(
                        title: 'Low Stock',
                        value: productController.products
                            .where((p) => p.stock > 0 && p.stock <= 10)
                            .length
                            .toString(),
                        icon: Icons.warning,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: -0.3),

              // Filter Chips
              if (productController.queryParams.value.search?.isNotEmpty == true ||
                  productController.queryParams.value.categoryId != null ||
                  productController.queryParams.value.inStock != null)
                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      if (productController.queryParams.value.search?.isNotEmpty == true)
                        FilterChip(
                          label: Text('Search: ${productController.queryParams.value.search}'),
                          onDeleted: () {
                            productController.searchProducts('');
                          },
                          deleteIcon: const Icon(Icons.close, size: 16),
                        ),
                      const SizedBox(width: 8),
                      if (productController.queryParams.value.categoryId != null)
                        FilterChip(
                          label: const Text('Category Filter'),
                          onDeleted: () {
                            productController.filterByCategory(null);
                          },
                          deleteIcon: const Icon(Icons.close, size: 16),
                        ),
                      const SizedBox(width: 8),
                      if (productController.queryParams.value.inStock != null)
                        FilterChip(
                          label: Text(productController.queryParams.value.inStock! ? 'In Stock' : 'Out of Stock'),
                          onDeleted: () {
                            productController.filterByStock(null);
                          },
                          deleteIcon: const Icon(Icons.close, size: 16),
                        ),
                      const SizedBox(width: 8),
                      ActionChip(
                        label: const Text('Clear All'),
                        onPressed: () {
                          productController.clearFilters();
                        },
                        avatar: const Icon(Icons.clear_all, size: 16),
                      ),
                    ],
                  ),
                ),

              // Products List
              Expanded(
                child: Obx(() {
                  if (productController.isLoading.value && productController.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (productController.products.isEmpty) {
                    return _EmptyState(
                      onAddProduct: () => _showAddProductBottomSheet(context),
                      onClearFilters: () => productController.clearFilters(),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: productController.products.length +
                        (productController.hasMorePages.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == productController.products.length) {
                        // Load more indicator
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: productController.isLoadingMore.value
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                              onPressed: () => productController.getProducts(loadMore: true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.vendorPrimary,
                              ),
                              child: const Text('Load More'),
                            ),
                          ),
                        );
                      }

                      final product = productController.products[index];
                      return _ProductCard(
                        product: product,
                        onTap: () => _navigateToProductDetail(product),
                        onEdit: () => _showEditProductBottomSheet(context, product),
                        onDelete: () => _showDeleteConfirmation(context, product, productController),
                      ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductBottomSheet(context),
        backgroundColor: AppColors.vendorPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _navigateToProductDetail(ProductVariant product) {
    Get.snackbar(
      'Product',
      'Opening ${product.name}...',
      backgroundColor: AppColors.vendorPrimary,
      colorText: Colors.white,
    );
    // TODO: Navigate to product detail page
    // Get.toNamed('/vendor/products/${product.id}');
  }

  void _showSearchBottomSheet(BuildContext context, ProductController controller) {
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
                        if (value.isEmpty) {
                          controller.clearFilters();
                        } else {
                          controller.searchProducts(value);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () => controller.clearFilters(),
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
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.products.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
                        SizedBox(height: 16),
                        Text(
                          'No products found',
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
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text('₹${product.price} • Stock: ${product.stock}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.back();
                          _navigateToProductDetail(product);
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

  void _showFilterBottomSheet(BuildContext context, ProductController productController, CategoryController categoryController) {
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
              'Filter Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Stock Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilterChip(
                    label: const Text('All'),
                    selected: productController.queryParams.value.inStock == null,
                    onSelected: (selected) {
                      productController.filterByStock(null);
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChip(
                    label: const Text('In Stock'),
                    selected: productController.queryParams.value.inStock == true,
                    onSelected: (selected) {
                      productController.filterByStock(true);
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChip(
                    label: const Text('Out of Stock'),
                    selected: productController.queryParams.value.inStock == false,
                    onSelected: (selected) {
                      productController.filterByStock(false);
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
                      productController.clearFilters();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                    child: const Text('Clear All', style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.vendorPrimary),
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

  void _showSortBottomSheet(BuildContext context, ProductController controller) {
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
            const Text('Sort By', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Name (A-Z)'),
              onTap: () {
                controller.setSortOrder('name', 'asc');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Name (Z-A)'),
              onTap: () {
                controller.setSortOrder('name', 'desc');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Price (Low to High)'),
              onTap: () {
                controller.setSortOrder('price', 'asc');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Price (High to Low)'),
              onTap: () {
                controller.setSortOrder('price', 'desc');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Recently Added'),
              onTap: () {
                controller.setSortOrder('created_at', 'desc');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductBottomSheet(BuildContext context) {
    Get.snackbar(
      'Coming Soon',
      'Add product feature will be available soon!',
      backgroundColor: AppColors.info,
      colorText: Colors.white,
    );
  }

  void _showEditProductBottomSheet(BuildContext context, ProductVariant product) {
    Get.snackbar(
      'Edit Product',
      'Edit feature for ${product.name} coming soon!',
      backgroundColor: AppColors.warning,
      colorText: Colors.white,
    );
  }

  void _showDeleteConfirmation(BuildContext context, ProductVariant product, ProductController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteProduct(product.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductVariant product;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Product Image Placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.vendorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.inventory,
                  color: AppColors.vendorPrimary,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.product.category.name} • ${product.product.subcategory.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: product.stock > 0 ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            product.stock > 0 ? 'In Stock (${product.stock})' : 'Out of Stock',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: product.stock > 0 ? AppColors.success : AppColors.error,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₹${product.price}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.vendorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddProduct;
  final VoidCallback onClearFilters;

  const _EmptyState({
    required this.onAddProduct,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.vendorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.inventory,
                size: 60,
                color: AppColors.vendorPrimary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Products Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Start building your inventory by adding your first product',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onAddProduct,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add Product', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vendorPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: onClearFilters,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear Filters'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.vendorPrimary,
                    side: const BorderSide(color: AppColors.vendorPrimary),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}