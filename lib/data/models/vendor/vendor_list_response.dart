// lib/data/models/vendor/vendor_list_response.dart
class VendorListResponse {
  final String status;
  final List<VendorItem> data;

  VendorListResponse({
    required this.status,
    required this.data,
  });

  factory VendorListResponse.fromJson(Map<String, dynamic> json) {
    return VendorListResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => VendorItem.fromJson(item))
          .toList(),
    );
  }
}

// Simple wrapper for compatibility with existing controller
class VendorListData {
  final int currentPage;
  final List<VendorItem> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  VendorListData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  // For the simple list API, we'll create a mock pagination structure
  factory VendorListData.fromSimpleList(List<VendorItem> vendors) {
    return VendorListData(
      currentPage: 1,
      data: vendors,
      firstPageUrl: '',
      from: vendors.isNotEmpty ? 1 : 0,
      lastPage: 1,
      lastPageUrl: '',
      nextPageUrl: null,
      path: '',
      perPage: vendors.length,
      prevPageUrl: null,
      to: vendors.length,
      total: vendors.length,
    );
  }

  factory VendorListData.fromJson(Map<String, dynamic> json) {
    return VendorListData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List? ?? [])
          .map((item) => VendorItem.fromJson(item))
          .toList(),
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'] ?? '',
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class VendorItem {
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
  final VendorAdmin? admin;

  VendorItem({
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
    this.admin,
  });

  factory VendorItem.fromJson(Map<String, dynamic> json) {
    return VendorItem(
      id: json['id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      vendorId: json['vendor_id'] ?? '',
      storeName: json['store_name'] ?? '',
      storeSlug: json['store_slug'] ?? '',
      storeType: json['store_type'] ?? '',
      logo: json['logo'],
      banner: json['banner'],
      address: json['address'],
      contactNumber: json['contact_number'] ?? '',
      about: json['about'] ?? '',
      workingHours: json['working_hours'],
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      admin: json['admin'] != null ? VendorAdmin.fromJson(json['admin']) : null,
    );
  }

  // Helper getters
  bool get isOpen => status == 'approved';
  bool get isPending => status == 'pending';
  String get displayImage {
    if (logo != null && logo!.isNotEmpty) {
      // Handle relative URLs by adding base URL if needed
      if (logo!.startsWith('vendor_logo/')) {
        return 'https://multistore.webinastore.in/public/storage/$logo';
      }
      return logo!;
    }
    if (banner != null && banner!.isNotEmpty) {
      if (banner!.startsWith('vendor_banner/')) {
        return 'https://multistore.webinastore.in/public/storage/$banner';
      }
      return banner!;
    }
    return '';
  }
  double get rating => 4.5; // Default rating, replace with actual rating from API
  int get reviewCount => 100; // Default review count, replace with actual count from API
  String get deliveryTime => '30-45 min'; // Default delivery time
  String get statusBadge {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Open';
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Closed';
      default:
        return 'Unknown';
    }
  }
}

class VendorAdmin {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? picture;
  final String? address;
  final String? city;
  final String? state;
  final String? country;

  VendorAdmin({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.picture,
    this.address,
    this.city,
    this.state,
    this.country,
  });

  factory VendorAdmin.fromJson(Map<String, dynamic> json) {
    return VendorAdmin(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      picture: json['picture'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }

  String get displayPicture {
    if (picture != null && picture!.isNotEmpty) {
      if (picture!.startsWith('admin_profile/')) {
        return 'https://multistore.webinastore.in/public/storage/$picture';
      }
      return picture!;
    }
    return '';
  }

  String get fullAddress {
    List<String> addressParts = [];
    if (address != null && address!.isNotEmpty) addressParts.add(address!);
    if (city != null && city!.isNotEmpty) addressParts.add(city!);
    if (state != null && state!.isNotEmpty) addressParts.add(state!);
    if (country != null && country!.isNotEmpty) addressParts.add(country!);
    return addressParts.join(', ');
  }
}
