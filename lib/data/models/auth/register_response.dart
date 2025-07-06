// lib/data/models/auth/register_response.dart
class RegisterResponse {
  final String status;
  final String message;
  final RegisterData data;

  RegisterResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: RegisterData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class RegisterData {
  final RegisterAdmin admin;
  final RegisterVendor vendor;
  final String token;

  RegisterData({
    required this.admin,
    required this.vendor,
    required this.token,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      admin: RegisterAdmin.fromJson(json['admin'] ?? {}),
      vendor: RegisterVendor.fromJson(json['vendor'] ?? {}),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin': admin.toJson(),
      'vendor': vendor.toJson(),
      'token': token,
    };
  }
}

class RegisterAdmin {
  final String name;
  final String email;
  final String phone;
  final String? address;
  final int roleId;
  final int status;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  RegisterAdmin({
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    required this.roleId,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory RegisterAdmin.fromJson(Map<String, dynamic> json) {
    return RegisterAdmin(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'],
      roleId: json['role_id'] ?? 0,
      status: json['status'] ?? 0,
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role_id': roleId,
      'status': status,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'id': id,
    };
  }
}

class RegisterVendor {
  final int adminId;
  final String vendorId;
  final String storeName;
  final String storeSlug;
  final String storeType;
  final String contactNumber;
  final String? about;
  final String? workingHours;
  final String status;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  RegisterVendor({
    required this.adminId,
    required this.vendorId,
    required this.storeName,
    required this.storeSlug,
    required this.storeType,
    required this.contactNumber,
    this.about,
    this.workingHours,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory RegisterVendor.fromJson(Map<String, dynamic> json) {
    return RegisterVendor(
      adminId: json['admin_id'] ?? 0,
      vendorId: json['vendor_id'] ?? '',
      storeName: json['store_name'] ?? '',
      storeSlug: json['store_slug'] ?? '',
      storeType: json['store_type'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      about: json['about'],
      workingHours: json['working_hours'],
      status: json['status'] ?? '',
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin_id': adminId,
      'vendor_id': vendorId,
      'store_name': storeName,
      'store_slug': storeSlug,
      'store_type': storeType,
      'contact_number': contactNumber,
      'about': about,
      'working_hours': workingHours,
      'status': status,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'id': id,
    };
  }
}
