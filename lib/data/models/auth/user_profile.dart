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

  // Constructor for vendor login response (different structure)
  factory UserProfile.fromVendorJson(Map<String, dynamic> json) {
    // Handle the case where json might be Map<dynamic, dynamic>
    final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);

    // For vendor login response, the data structure is different
    // Check if this is from login response (has data wrapper) or direct user data
    final userData = safeJson.containsKey('data') ? safeJson['data'] : safeJson;
    final Map<String, dynamic> userInfo = Map<String, dynamic>.from(userData);

    return UserProfile(
      id: userInfo['id'] ?? 0,
      name: userInfo['name'] ?? '',
      email: userInfo['email'] ?? '',
      phone: userInfo['phone'] ?? '',
      userType: UserType.vendor,
      vendorInfo: userInfo['vendor'] != null
          ? VendorInfo.fromJson(userInfo['vendor'])
          : null,
      picture: userInfo['picture'],
      address: userInfo['address'],
      type: 'vendor',
      createdAt: DateTime.parse(userInfo['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(userInfo['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Constructor specifically for profile API response
  factory UserProfile.fromVendorProfileJson(Map<String, dynamic> json) {
    // Handle the case where json might be Map<dynamic, dynamic>
    final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);

    // For profile response, data is nested under 'data' key
    final userData = safeJson['data'];
    if (userData == null) {
      throw ArgumentError('Profile response does not contain data field');
    }

    final Map<String, dynamic> userInfo = Map<String, dynamic>.from(userData);

    return UserProfile(
      id: userInfo['id'] ?? 0,
      name: userInfo['name'] ?? '',
      email: userInfo['email'] ?? '',
      phone: userInfo['phone'] ?? '',
      userType: UserType.vendor,
      vendorInfo: userInfo['vendor'] != null
          ? VendorInfo.fromJson(userInfo['vendor'])
          : null,
      picture: userInfo['picture'],
      address: userInfo['address'],
      type: 'vendor',
      createdAt: DateTime.parse(userInfo['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(userInfo['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Alternative constructor for API responses with different structure
  factory UserProfile.fromApiResponse(Map<String, dynamic> apiResponse) {
    // Handle the case where apiResponse might be Map<dynamic, dynamic>
    final Map<String, dynamic> safeResponse = Map<String, dynamic>.from(apiResponse);

    final data = safeResponse['data'];
    if (data == null) {
      throw ArgumentError('API response does not contain data field');
    }

    final Map<String, dynamic> userData = Map<String, dynamic>.from(data);

    return UserProfile(
      id: userData['id'] ?? 0,
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      phone: userData['phone'] ?? '',
      userType: UserType.vendor,
      vendorInfo: userData['vendor'] != null
          ? VendorInfo.fromJson(userData['vendor'])
          : null,
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

  // Constructor specifically for customer profile API response
  factory UserProfile.fromCustomerProfileJson(Map<String, dynamic> json) {
    // Handle the case where json might be Map<dynamic, dynamic>
    final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);

    // For profile response, data is nested under 'data' key
    final userData = safeJson['data'];
    if (userData == null) {
      throw ArgumentError('Profile response does not contain data field');
    }

    final Map<String, dynamic> userInfo = Map<String, dynamic>.from(userData);

    return UserProfile(
      id: userInfo['id'] ?? 0,
      name: userInfo['name'] ?? '',
      email: userInfo['email'] ?? '',
      phone: userInfo['phone'] ?? '',
      userType: UserType.customer,
      vendorInfo: null,
      picture: userInfo['picture'],
      address: userInfo['address'],
      type: userInfo['type'], // This will be "user" from the API response
      createdAt: DateTime.parse(userInfo['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(userInfo['updated_at'] ?? DateTime.now().toIso8601String()),
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
  final int adminId;
  final String vendorId;
  final String storeName;
  final String storeSlug;
  final String storeType;
  final String? logo;
  final String? banner;
  final String? address;
  final String contactNumber;
  final String about;
  final String? workingHours;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  VendorInfo({
    required this.id,
    required this.adminId,
    required this.vendorId,
    required this.storeName,
    required this.storeSlug,
    required this.storeType,
    this.logo,
    this.banner,
    this.address,
    required this.contactNumber,
    required this.about,
    this.workingHours,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VendorInfo.fromJson(Map<String, dynamic> json) {
    // Handle the case where json might be Map<dynamic, dynamic>
    final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);

    return VendorInfo(
      id: safeJson['id'] ?? 0,
      adminId: safeJson['admin_id'] ?? 0,
      vendorId: safeJson['vendor_id'] ?? '',
      storeName: safeJson['store_name'] ?? '',
      storeSlug: safeJson['store_slug'] ?? '',
      storeType: safeJson['store_type'] ?? '',
      logo: safeJson['logo'],
      banner: safeJson['banner'],
      address: safeJson['address'],
      contactNumber: safeJson['contact_number'] ?? '',
      about: safeJson['about'] ?? '',
      workingHours: safeJson['working_hours'],
      status: safeJson['status'] ?? '',
      createdAt: DateTime.parse(safeJson['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(safeJson['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'vendor_id': vendorId,
      'store_name': storeName,
      'store_slug': storeSlug,
      'store_type': storeType,
      'logo': logo,
      'banner': banner,
      'address': address,
      'contact_number': contactNumber,
      'about': about,
      'working_hours': workingHours,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}