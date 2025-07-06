// lib/data/models/vendor/vendor_detail_response.dart
import 'vendor_list_response.dart';

class VendorDetailResponse {
  final String status;
  final VendorDetail data;

  VendorDetailResponse({
    required this.status,
    required this.data,
  });

  factory VendorDetailResponse.fromJson(Map<String, dynamic> json) {
    return VendorDetailResponse(
      status: json['status'] ?? '',
      data: VendorDetail.fromJson(json['data'] ?? {}),
    );
  }
}

class VendorDetail extends VendorItem {
  final List<VendorProduct>? products;
  final VendorStatistics? statistics;

  VendorDetail({
    required super.id,
    required super.adminId,
    required super.vendorId,
    required super.storeName,
    required super.storeSlug,
    required super.storeType,
    super.logo,
    super.banner,
    super.address,
    required super.contactNumber,
    required super.about,
    super.workingHours,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.admin,
    this.products,
    this.statistics,
  });

  factory VendorDetail.fromJson(Map<String, dynamic> json) {
    return VendorDetail(
      id: json['id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      vendorId: json['vendor_id'] ?? '',
      storeName: json['store_name'] ?? '',
      storeSlug: json['store_slug'] ?? '',
      storeType: json['store_type'] ?? '',
      logo: json['logo'],
      banner: json['banner'],
      address: json['address'],
      contactNumber: json['contact_number'] ?? '',
      about: json['about'] ?? '',
      workingHours: json['working_hours'],
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      admin: json['admin'] != null ? VendorAdmin.fromJson(json['admin']) : null,
      products: json['products'] != null
          ? (json['products'] as List).map((item) => VendorProduct.fromJson(item)).toList()
          : null,
      statistics: json['statistics'] != null
          ? VendorStatistics.fromJson(json['statistics'])
          : null,
    );
  }
}

class VendorProduct {
  final int id;
  final String name;
  final String? image;
  final String price;
  final String category;

  VendorProduct({
    required this.id,
    required this.name,
    this.image,
    required this.price,
    required this.category,
  });

  factory VendorProduct.fromJson(Map<String, dynamic> json) {
    return VendorProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      price: json['price']?.toString() ?? '0',
      category: json['category'] ?? '',
    );
  }
}

class VendorStatistics {
  final int totalProducts;
  final int totalOrders;
  final double averageRating;
  final int totalReviews;

  VendorStatistics({
    required this.totalProducts,
    required this.totalOrders,
    required this.averageRating,
    required this.totalReviews,
  });

  factory VendorStatistics.fromJson(Map<String, dynamic> json) {
    return VendorStatistics(
      totalProducts: json['total_products'] ?? 0,
      totalOrders: json['total_orders'] ?? 0,
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
    );
  }
}
