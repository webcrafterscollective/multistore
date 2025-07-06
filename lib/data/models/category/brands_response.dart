// lib/data/models/category/brands_response.dart
class BrandsListResponse {
  final String status;
  final List<BrandDetail> data;

  BrandsListResponse({
    required this.status,
    required this.data,
  });

  factory BrandsListResponse.fromJson(Map<String, dynamic> json) {
    return BrandsListResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => BrandDetail.fromJson(item))
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

class BrandDetail {
  final int id;
  final String name;
  final String? logo;
  final String? description;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  BrandDetail({
    required this.id,
    required this.name,
    this.logo,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BrandDetail.fromJson(Map<String, dynamic> json) {
    return BrandDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logo: json['logo'],
      description: json['description'],
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'description': description,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
