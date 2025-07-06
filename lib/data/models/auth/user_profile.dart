// lib/data/models/auth/user_profile.dart
import 'user_type.dart';

class UserProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final UserType userType;
  final VendorInfo? vendorInfo;
  final String? picture;
  final String? address;
  final String? type;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.vendorInfo,
    this.picture,
    this.address,
    this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  // Fixed constructor to match your actual API response
  factory UserProfile.fromVendorJson(Map<String, dynamic> json) {
    // Handle the case where json might be Map<dynamic, dynamic>
    final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);

    // Extract data from the actual API response structure
    final data = safeJson['data'] ?? safeJson; // Handle both cases
    final vendor = data['vendor'] ?? {};

    return UserProfile(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      userType: UserType.vendor,
      vendorInfo: vendor.isNotEmpty ? VendorInfo.fromJson(vendor) : null,
      picture: data['picture'],
      address: data['address'],
      type: 'vendor',
      createdAt: DateTime.parse(data['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(data['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Alternative constructor if you're passing the entire API response
  factory UserProfile.fromApiResponse(Map<String, dynamic> apiResponse) {
    // Handle the case where apiResponse might be Map<dynamic, dynamic>
    final Map<String, dynamic> safeResponse = Map<String, dynamic>.from(apiResponse);

    final data = safeResponse['data'];
    if (data == null) {
      throw ArgumentError('API response does not contain data field');
    }

    final Map<String, dynamic> userData = Map<String, dynamic>.from(data);
    final vendor = userData['vendor'] ?? {};

    return UserProfile(
      id: userData['id'] ?? 0,
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      phone: userData['phone'] ?? '',
      userType: UserType.vendor,
      vendorInfo: vendor.isNotEmpty ? VendorInfo.fromJson(vendor) : null,
      picture: userData['picture'],
      address: userData['address'],
      type: 'vendor',
      createdAt: DateTime.parse(userData['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(userData['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  factory UserProfile.fromCustomerJson(Map<String, dynamic> json) {
    // Handle the case where json might be Map<dynamic, dynamic>
    final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);

    return UserProfile(
      id: safeJson['id'] ?? 0,
      name: safeJson['name'] ?? '',
      email: safeJson['email'] ?? '',
      phone: safeJson['phone'] ?? '',
      userType: UserType.customer,
      vendorInfo: null,
      picture: safeJson['picture'],
      address: safeJson['address'],
      type: safeJson['type'],
      createdAt: DateTime.parse(safeJson['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(safeJson['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'user_type': userType.name,
      'vendor_info': vendorInfo?.toJson(),
      'picture': picture,
      'address': address,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get displayName => name.isNotEmpty ? name : email.split('@').first;
  String get initials {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}

class VendorInfo {
  final int id;
  final String vendorId;
  final String storeName;
  final String storeSlug;
  final String storeType;
  final String? logo;
  final String address;
  final String contactNumber;
  final String about;
  final String status;

  VendorInfo({
    required this.id,
    required this.vendorId,
    required this.storeName,
    required this.storeSlug,
    required this.storeType,
    this.logo,
    required this.address,
    required this.contactNumber,
    required this.about,
    required this.status,
  });

  factory VendorInfo.fromJson(Map<String, dynamic> json) {
    // Handle the case where json might be Map<dynamic, dynamic>
    final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);

    return VendorInfo(
      id: safeJson['id'] ?? 0,
      vendorId: safeJson['vendor_id'] ?? '',
      storeName: safeJson['store_name'] ?? '',
      storeSlug: safeJson['store_slug'] ?? '',
      storeType: safeJson['store_type'] ?? '',
      logo: safeJson['logo'],
      address: safeJson['address'] ?? '',
      contactNumber: safeJson['contact_number'] ?? '',
      about: safeJson['about'] ?? '',
      status: safeJson['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor_id': vendorId,
      'store_name': storeName,
      'store_slug': storeSlug,
      'store_type': storeType,
      'logo': logo,
      'address': address,
      'contact_number': contactNumber,
      'about': about,
      'status': status,
    };
  }
}