// lib/data/models/category/subcategory_response.dart
class SubcategoryListResponse {
  final String status;
  final List<SubcategoryItem> data;

  SubcategoryListResponse({
    required this.status,
    required this.data,
  });

  factory SubcategoryListResponse.fromJson(Map<String, dynamic> json) {
    return SubcategoryListResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => SubcategoryItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class SubcategoryItem {
  final int id;
  final int parentId;
  final int adminId;
  final int catId;
  final String pageType;
  final String name;
  final String title;
  final int? position;
  final String? tax;
  final String? img;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubcategoryItem({
    required this.id,
    required this.parentId,
    required this.adminId,
    required this.catId,
    required this.pageType,
    required this.name,
    required this.title,
    this.position,
    this.tax,
    this.img,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubcategoryItem.fromJson(Map<String, dynamic> json) {
    return SubcategoryItem(
      id: json['id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      catId: json['cat_id'] ?? 0,
      pageType: json['page_type'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      position: json['position'],
      tax: json['tax']?.toString(),
      img: json['img'],
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'admin_id': adminId,
      'cat_id': catId,
      'page_type': pageType,
      'name': name,
      'title': title,
      'position': position,
      'tax': tax,
      'img': img,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
