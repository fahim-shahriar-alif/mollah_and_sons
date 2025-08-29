import '../models/cart_item.dart';

class OrderModel {
  final String id;
  final DateTime orderDate;
  final List<CartItem> items;
  final double totalAmount;
  final String status;

  OrderModel({
    required this.id,
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    this.status = 'pending',
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderDate': orderDate.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderDate: DateTime.parse(json['orderDate']),
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
    );
  }

  // Convert to legacy format for order history screen
  Map<String, dynamic> toLegacyFormat() {
    return {
      'id': id,
      'date': orderDate.toIso8601String().split('T')[0], // Just the date part
      'items': itemCount,
      'total': totalAmount,
      'status': status,
      'products': items.map((item) => {
        'name': item.name,
        'quantity': item.quantity,
        'price': item.price,
      }).toList(),
    };
  }
}
