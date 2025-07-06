// lib/data/models/category/features_response.dart
class FeaturesListResponse {
  final String status;
  final List<FeatureDetail> data;

  FeaturesListResponse({
    required this.status,
    required this.data,
  });

  factory FeaturesListResponse.fromJson(Map<String, dynamic> json) {
    return FeaturesListResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => FeatureDetail.fromJson(item))
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

class FeatureDetail {
  final int id;
  final String name;
  final String? description;
  final String type;
  final List<String> options;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeatureDetail({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.options,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeatureDetail.fromJson(Map<String, dynamic> json) {
    return FeatureDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      type: json['type'] ?? '',
      options: List<String>.from(json['options'] ?? []),
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
      'type': type,
      'options': options,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}