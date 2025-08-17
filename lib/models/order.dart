class Order {
  final String id;
  final String buyerId;
  final double totalAmount;
  final String status;
  final Map<String, dynamic> shippingAddress;
  final String? paymentMethod;
  final String? paymentId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.buyerId,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    this.paymentMethod,
    this.paymentId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      buyerId: json['buyer_id'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String,
      shippingAddress: json['shipping_address'] as Map<String, dynamic>,
      paymentMethod: json['payment_method'] as String?,
      paymentId: json['payment_id'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyerId,
      'total_amount': totalAmount,
      'status': status,
      'shipping_address': shippingAddress,
      'payment_method': paymentMethod,
      'payment_id': paymentId,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get formattedAddress {
    final street = shippingAddress['street'] ?? '';
    final city = shippingAddress['city'] ?? '';
    final state = shippingAddress['state'] ?? '';
    final zipCode = shippingAddress['zipCode'] ?? '';
    return '$street, $city, $state $zipCode';
  }

  String get customerName => shippingAddress['name'] ?? 'Unknown';
  String get customerPhone => shippingAddress['phone'] ?? '';
}
