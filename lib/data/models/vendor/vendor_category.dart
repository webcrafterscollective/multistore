// lib/data/models/vendor/vendor_category.dart
class VendorCategory {
  final int id;
  final String name;
  final String? icon;
  final String? description;
  final int vendorCount;

  VendorCategory({
    required this.id,
    required this.name,
    this.icon,
    this.description,
    required this.vendorCount,
  });

  factory VendorCategory.fromJson(Map<String, dynamic> json) {
    return VendorCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'],
      description: json['description'],
      vendorCount: json['vendor_count'] ?? 0,
    );
  }
}