// lib/data/models/category/category_list_response.dart
class CategoryListResponse {
  final String status;
  final List<CategoryItem> data;

  CategoryListResponse({
    required this.status,
    required this.data,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) {
    return CategoryListResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => CategoryItem.fromJson(item))
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

class CategoryItem {
  final int id;
  final int parentId;
  final int adminId;
  final String name;
  final String title;
  final int? position;
  final String? tax;
  final String? img;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryItem({
    required this.id,
    required this.parentId,
    required this.adminId,
    required this.name,
    required this.title,
    this.position,
    this.tax,
    this.img,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
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
