import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderHistoryService extends ChangeNotifier {
  static final OrderHistoryService _instance = OrderHistoryService._internal();
  factory OrderHistoryService() => _instance;
  OrderHistoryService._internal();

  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders.reversed);

  void addOrder(List<CartItem> cartItems, double totalAmount) {
    final order = OrderModel(
      id: _generateOrderId(),
      orderDate: DateTime.now(),
      items: cartItems,
      totalAmount: totalAmount,
      status: 'Processing',
    );

    _orders.add(order);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String status) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      final updatedOrder = OrderModel(
        id: _orders[index].id,
        orderDate: _orders[index].orderDate,
        items: _orders[index].items,
        totalAmount: _orders[index].totalAmount,
        status: status,
      );
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }

  OrderModel? getOrder(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> getOrdersInLegacyFormat() {
    return _orders.reversed.map((order) => order.toLegacyFormat()).toList();
  }

  String _generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final orderNumber = (_orders.length + 1).toString().padLeft(3, '0');
    return 'ORD$orderNumber';
  }

  // For demo purposes, add some sample orders
  void addSampleOrders() {
    if (_orders.isEmpty) {
      // Add sample orders with dates in the past
      final sampleOrder1 = OrderModel(
        id: 'ORD001',
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        items: [
          CartItem(
            productId: '1',
            name: 'NPK 20-20-20',
            description: 'Complete fertilizer for all crops',
            companyName: 'AgroTech Ltd.',
            price: 850.0,
            unit: 'per 50kg bag',
            category: 'Chemical Fertilizer',
            image: Icons.eco,
            quantity: 2,
          ),
          CartItem(
            productId: '2',
            name: 'Urea 46%',
            description: 'High nitrogen fertilizer',
            companyName: 'GreenGrow Industries',
            price: 720.0,
            unit: 'per 50kg bag',
            category: 'Chemical Fertilizer',
            image: Icons.agriculture,
            quantity: 1,
          ),
        ],
        totalAmount: 2420.0,
        status: 'Delivered',
      );

      final sampleOrder2 = OrderModel(
        id: 'ORD002',
        orderDate: DateTime.now().subtract(const Duration(days: 6)),
        items: [
          CartItem(
            productId: '3',
            name: 'DAP Fertilizer',
            description: 'Phosphorus rich fertilizer',
            companyName: 'FarmMax Corporation',
            price: 950.0,
            unit: 'per 50kg bag',
            category: 'Chemical Fertilizer',
            image: Icons.local_florist,
            quantity: 1,
          ),
        ],
        totalAmount: 950.0,
        status: 'In Transit',
      );

      _orders.addAll([sampleOrder1, sampleOrder2]);
    }
  }
}
