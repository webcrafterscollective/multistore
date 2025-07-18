// lib/presentation/pages/customer/product/product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/product/product_list_response.dart';
import '../../../controllers/product_controller.dart';
import '../../../widgets/common/loading_overlay.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> with SingleTickerProviderStateMixin {
  late ProductVariant product;
  late ProductController productController;
  late AnimationController animationController;
  late ScrollController scrollController;

  int quantity = 1;
  bool isFavorite = false;
  bool showFAB = false;

  @override
  void initState() {
    super.initState();

    // Get product data from arguments
    product = Get.arguments as ProductVariant;

    // Initialize controllers
    productController = Get.find<ProductController>();

    // Initialize animations
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize scroll controller
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);

    // Start animations
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
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
          // Product Image Header
          _buildProductHeader(),

          // Product Info Card
          _buildProductInfoCard(),

          // Product Details
          _buildProductDetails(),

          // Similar Products
          _buildSimilarProducts(),

          // Footer Spacing
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // Add to Cart FAB
      floatingActionButton: AnimatedScale(
        scale: showFAB ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton.extended(
          onPressed: product.stock > 0 ? _addToCart : null,
          backgroundColor: product.stock > 0 ? AppColors.customerPrimary : Colors.grey,
          icon: Icon(
            Icons.add_shopping_cart,
            color: Colors.white,
          ),
          label: Text(
            product.stock > 0 ? 'Add to Cart' : 'Out of Stock',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildProductHeader() {
    return SliverAppBar(
      expandedHeight: 300,
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
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.error : Colors.white,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: _shareProduct,
            icon: const Icon(Icons.share, color: Colors.white),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.customerPrimary.withOpacity(0.8),
                AppColors.customerSecondary,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Product Image Placeholder
              const Center(
                child: Icon(
                  Icons.inventory,
                  size: 120,
                  color: Colors.white,
                ),
              ),

              // Stock Badge
              Positioned(
                top: 100,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: product.stock > 0 ? AppColors.success : AppColors.error,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    product.stock > 0 ? 'In Stock (${product.stock})' : 'Out of Stock',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
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

  Widget _buildProductInfoCard() {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // Category and Subcategory
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.customerPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.product.category.name,
                    style: const TextStyle(
                      color: AppColors.customerPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.customerSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.product.subcategory.name,
                    style: const TextStyle(
                      color: AppColors.customerSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Price Section
            Row(
              children: [
                Text(
                  '₹${product.price}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.customerPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                if (product.optionValue.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.optionValue,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Quantity Selector (if in stock)
            if (product.stock > 0) ...[
              Row(
                children: [
                  const Text(
                    'Quantity:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                          icon: const Icon(Icons.remove),
                          iconSize: 18,
                        ),
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: quantity < product.stock
                              ? () => setState(() => quantity++)
                              : null,
                          icon: const Icon(Icons.add),
                          iconSize: 18,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Total: ₹${(double.parse(product.price) * quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.customerPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: product.stock > 0 ? _addToCart : null,
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                    label: Text(
                      product.stock > 0 ? 'Add to Cart' : 'Out of Stock',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: product.stock > 0
                          ? AppColors.customerPrimary
                          : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _buyNow,
                  icon: const Icon(Icons.flash_on),
                  label: const Text('Buy Now'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.customerPrimary,
                    side: const BorderSide(color: AppColors.customerPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
    );
  }

  Widget _buildProductDetails() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Information
            Container(
              width: double.infinity,
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
                  const Text(
                    'Product Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Product Stats
                  _InfoRow(
                    label: 'Product ID',
                    value: product.variantUid,
                  ),
                  _InfoRow(
                    label: 'Category',
                    value: '${product.product.category.name} > ${product.product.subcategory.name}',
                  ),
                  _InfoRow(
                    label: 'Stock Available',
                    value: '${product.stock} units',
                  ),
                  if (product.totalSold != '0')
                    _InfoRow(
                      label: 'Total Sold',
                      value: '${product.totalSold} units',
                    ),
                  _InfoRow(
                    label: 'Status',
                    value: product.status == 1 ? 'Active' : 'Inactive',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Store Information
            Container(
              width: double.infinity,
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
                      const Text(
                        'Sold by',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _viewStore,
                        child: const Text('View Store'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.customerPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.store,
                          color: AppColors.customerPrimary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Store Name', // Would be populated from vendor data
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: AppColors.warning),
                                const SizedBox(width: 4),
                                const Text('4.5'),
                                const SizedBox(width: 8),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Open',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
    );
  }

  Widget _buildSimilarProducts() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Similar Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Similar Products List
            Container(
              height: 200,
              child: Obx(() {
                // Filter products from same category
                final similarProducts = productController.products
                    .where((p) =>
                p.product.category.id == product.product.category.id &&
                    p.id != product.id)
                    .take(5)
                    .toList();

                if (similarProducts.isEmpty) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'No similar products found',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: similarProducts.length,
                  itemBuilder: (context, index) {
                    final similarProduct = similarProducts[index];
                    return Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () => Get.off(
                              () => const ProductDetailPage(),
                          arguments: similarProduct,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.customerPrimary.withOpacity(0.1),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.inventory,
                                  size: 40,
                                  color: AppColors.customerPrimary,
                                ),
                              ),
                            ),

                            // Product Info
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      similarProduct.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '₹${similarProduct.price}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.customerPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 600.ms),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Product Summary
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Total: ₹${(double.parse(product.price) * quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.customerPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Add to Cart Button
            ElevatedButton(
              onPressed: product.stock > 0 ? _addToCart : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: product.stock > 0
                    ? AppColors.customerPrimary
                    : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_shopping_cart, size: 18),
                  const SizedBox(width: 8),
                  Text(product.stock > 0 ? 'Add to Cart' : 'Out of Stock'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Methods
  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    Get.snackbar(
      isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
      isFavorite
          ? '${product.name} added to your favorites!'
          : '${product.name} removed from favorites',
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 2),
    );
  }

  void _shareProduct() {
    Get.snackbar(
      'Sharing Product',
      'Sharing ${product.name} with friends...',
      backgroundColor: AppColors.warning,
      colorText: Colors.white,
      icon: const Icon(Icons.share, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  void _addToCart() {
    Get.snackbar(
      'Added to Cart',
      '${product.name} (Qty: $quantity) added to cart!',
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      icon: const Icon(Icons.shopping_cart, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  void _buyNow() {
    Get.snackbar(
      'Buy Now',
      'Proceeding to checkout with ${product.name}...',
      backgroundColor: AppColors.customerPrimary,
      colorText: Colors.white,
      icon: const Icon(Icons.flash_on, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  void _viewStore() {
    Get.back(); // Go back to store detail page
  }
}

// Helper Widgets
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}