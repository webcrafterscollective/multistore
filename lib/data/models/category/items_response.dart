// lib/data/models/category/items_response.dart
class ItemsListResponse {
  final String status;
  final List<ItemDetail> data;

  ItemsListResponse({
    required this.status,
    required this.data,
  });

  factory ItemsListResponse.fromJson(Map<String, dynamic> json) {
    return ItemsListResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => ItemDetail.fromJson(item))
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

class ItemDetail {
  final int id;
  final String name;
  final String? description;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItemDetail({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) {
    return ItemDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
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
      'description': description,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
