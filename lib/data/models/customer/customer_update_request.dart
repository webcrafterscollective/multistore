// lib/data/models/customer/customer_update_request.dart
class CustomerUpdateRequest {
  final String? name;
  final String? phone;
  final String? email;
  final String? address;

  CustomerUpdateRequest({
    this.name,
    this.phone,
    this.email,
    this.address,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (email != null) data['email'] = email;
    if (address != null) data['address'] = address;

    return data;
  }
}