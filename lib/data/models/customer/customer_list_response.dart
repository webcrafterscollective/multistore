// lib/data/models/customer/customer_list_response.dart
class CustomerListResponse {
  final String status;
  final CustomerData data;

  CustomerListResponse({
    required this.status,
    required this.data,
  });

  factory CustomerListResponse.fromJson(Map<String, dynamic> json) {
    return CustomerListResponse(
      status: json['status'] ?? '',
      data: CustomerData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class CustomerData {
  final CustomerListData customers;
  final CustomerStatistics statistics;

  CustomerData({
    required this.customers,
    required this.statistics,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      customers: CustomerListData.fromJson(json['customers'] ?? {}),
      statistics: CustomerStatistics.fromJson(json['statistics'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customers': customers.toJson(),
      'statistics': statistics.toJson(),
    };
  }
}

class CustomerListData {
  final int currentPage;
  final List<CustomerItem> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  CustomerListData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory CustomerListData.fromJson(Map<String, dynamic> json) {
    return CustomerListData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List? ?? [])
          .map((item) => CustomerItem.fromJson(item))
          .toList(),
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'] ?? '',
      links: (json['links'] as List? ?? [])
          .map((item) => PaginationLink.fromJson(item))
          .toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((item) => item.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((item) => item.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class CustomerItem {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String? address;
  final DateTime createdAt;

  CustomerItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.address,
    required this.createdAt,
  });

  factory CustomerItem.fromJson(Map<String, dynamic> json) {
    return CustomerItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class CustomerStatistics {
  final int totalCustomers;
  final int newCustomers;
  final int activeCustomers;
  final int inactiveCustomers;

  CustomerStatistics({
    required this.totalCustomers,
    required this.newCustomers,
    required this.activeCustomers,
    required this.inactiveCustomers,
  });

  factory CustomerStatistics.fromJson(Map<String, dynamic> json) {
    return CustomerStatistics(
      totalCustomers: json['total_customers'] ?? 0,
      newCustomers: json['new_customers'] ?? 0,
      activeCustomers: json['active_customers'] ?? 0,
      inactiveCustomers: json['inactive_customers'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_customers': totalCustomers,
      'new_customers': newCustomers,
      'active_customers': activeCustomers,
      'inactive_customers': inactiveCustomers,
    };
  }
}

class PaginationLink {
  final String? url;
  final String label;
  final bool active;

  PaginationLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}