// lib/data/models/customer/customer_detail_response.dart
class CustomerDetailResponse {
  final String status;
  final CustomerDetail data;

  CustomerDetailResponse({
    required this.status,
    required this.data,
  });

  factory CustomerDetailResponse.fromJson(Map<String, dynamic> json) {
    return CustomerDetailResponse(
      status: json['status'] ?? '',
      data: CustomerDetail.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class CustomerDetail {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String? address;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerDetail({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerDetail.fromJson(Map<String, dynamic> json) {
    return CustomerDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'],
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}