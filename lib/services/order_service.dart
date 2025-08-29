import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // Save order to Firebase
  Future<bool> saveOrder(List<CartItem> cartItems, double totalAmount) async {
    if (_userId == null) {
      print('DEBUG: OrderService - No user logged in');
      return false;
    }

    try {
      print('DEBUG: OrderService - Saving order to Firebase');
      
      final order = OrderModel(
        id: _generateOrderId(),
        orderDate: DateTime.now(),
        items: cartItems,
        totalAmount: totalAmount,
        status: 'pending',
      );

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('orders')
          .doc(order.id)
          .set(order.toJson());
      
      print('DEBUG: OrderService - Order ${order.id} saved successfully');
      return true;
    } catch (e) {
      print('DEBUG: OrderService - Error saving order: $e');
      return false;
    }
  }

  // Get orders stream from Firebase
  Stream<List<OrderModel>> getOrdersStream() {
    if (_userId == null) return Stream.value([]);

    print('DEBUG: OrderService - Getting orders stream from Firebase');
    
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        final data = doc.data();
        return OrderModel.fromJson(data);
      }).toList();
      
      print('DEBUG: OrderService - Loaded ${orders.length} orders from stream');
      return orders;
    });
  }

  // Get single order by ID
  Future<OrderModel?> getOrder(String orderId) async {
    if (_userId == null) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('orders')
          .doc(orderId)
          .get();

      if (doc.exists) {
        return OrderModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('DEBUG: OrderService - Error getting order: $e');
      return null;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, String status) async {
    if (_userId == null) return false;

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('orders')
          .doc(orderId)
          .update({'status': status});
      
      print('DEBUG: OrderService - Order $orderId status updated to $status');
      return true;
    } catch (e) {
      print('DEBUG: OrderService - Error updating order status: $e');
      return false;
    }
  }

  String _generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORD${timestamp.toString().substring(8)}';
  }
}
