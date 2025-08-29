import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';
import '../models/order_model.dart';

class FirebaseCartService {
  static final FirebaseCartService _instance = FirebaseCartService._internal();
  factory FirebaseCartService() => _instance;
  FirebaseCartService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // Save cart items to Firebase
  Future<void> saveCartItems(List<CartItem> items) async {
    if (_userId == null) return;

    try {
      print('DEBUG: FirebaseCartService - Saving ${items.length} cart items to Firebase');
      
      final cartRef = _firestore.collection('users').doc(_userId).collection('cart');
      
      // Clear existing cart items
      final existingItems = await cartRef.get();
      for (var doc in existingItems.docs) {
        await doc.reference.delete();
      }

      // Add new cart items
      for (var item in items) {
        await cartRef.add(item.toJson());
      }
      
      print('DEBUG: FirebaseCartService - Cart items saved successfully');
    } catch (e) {
      print('DEBUG: FirebaseCartService - Error saving cart items: $e');
    }
  }

  // Load cart items from Firebase
  Future<List<CartItem>> loadCartItems() async {
    if (_userId == null) return [];

    try {
      print('DEBUG: FirebaseCartService - Loading cart items from Firebase');
      
      final cartRef = _firestore.collection('users').doc(_userId).collection('cart');
      final snapshot = await cartRef.get();
      
      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID
        return CartItem.fromJson(data);
      }).toList();
      
      print('DEBUG: FirebaseCartService - Loaded ${items.length} cart items');
      return items;
    } catch (e) {
      print('DEBUG: FirebaseCartService - Error loading cart items: $e');
      return [];
    }
  }

  // Clear cart items from Firebase
  Future<void> clearCartItems() async {
    if (_userId == null) return;

    try {
      print('DEBUG: FirebaseCartService - Clearing cart items from Firebase');
      
      final cartRef = _firestore.collection('users').doc(_userId).collection('cart');
      final existingItems = await cartRef.get();
      
      for (var doc in existingItems.docs) {
        await doc.reference.delete();
      }
      
      print('DEBUG: FirebaseCartService - Cart items cleared successfully');
    } catch (e) {
      print('DEBUG: FirebaseCartService - Error clearing cart items: $e');
    }
  }

  // Save order to Firebase
  Future<void> saveOrder(OrderModel order) async {
    if (_userId == null) return;

    try {
      print('DEBUG: FirebaseCartService - Saving order to Firebase');
      
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('orders')
          .add(order.toJson());
      
      print('DEBUG: FirebaseCartService - Order saved successfully');
    } catch (e) {
      print('DEBUG: FirebaseCartService - Error saving order: $e');
    }
  }

  // Get orders stream from Firebase
  Stream<List<OrderModel>> getOrdersStream() {
    if (_userId == null) return Stream.value([]);

    print('DEBUG: FirebaseCartService - Getting orders stream from Firebase');
    
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return OrderModel.fromJson(data);
      }).toList();
      
      print('DEBUG: FirebaseCartService - Loaded ${orders.length} orders from stream');
      return orders;
    });
  }
}
