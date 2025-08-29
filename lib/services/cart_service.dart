import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import 'firebase_cart_service.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];
  final FirebaseCartService _firebaseCartService = FirebaseCartService();
  bool _isLoaded = false;

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Load cart items from Firebase on first access
  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    
    final savedItems = await _firebaseCartService.loadCartItems();
    _items.clear();
    _items.addAll(savedItems);
    _isLoaded = true;
    notifyListeners();
  }

  void addItem(Map<String, dynamic> product, {int quantity = 1}) async {
    await _ensureLoaded();
    
    print('DEBUG: CartService - Adding item: $product');
    final existingIndex = _items.indexWhere((item) => item.productId == product['id']);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
      print('DEBUG: CartService - Updated existing item quantity to ${_items[existingIndex].quantity}');
    } else {
      final cartItem = CartItem.fromProduct(product, quantity: quantity);
      _items.add(cartItem);
      print('DEBUG: CartService - Added new item: ${cartItem.name}');
    }
    
    print('DEBUG: CartService - Total items in cart: ${_items.length}');
    
    // Save to Firebase
    await _firebaseCartService.saveCartItems(_items);
    notifyListeners();
  }

  void removeItem(String productId) async {
    _items.removeWhere((item) => item.productId == productId);
    await _firebaseCartService.saveCartItems(_items);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      await _firebaseCartService.saveCartItems(_items);
      notifyListeners();
    }
  }

  void clearCart() async {
    _items.clear();
    await _firebaseCartService.clearCartItems();
    notifyListeners();
  }

  // Initialize cart by loading from Firebase
  Future<void> initialize() async {
    await _ensureLoaded();
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.productId == productId);
  }

  int getQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItem(
        productId: '',
        name: '',
        description: '',
        price: 0,
        unit: '',
        category: '',
        companyName: '',
        image: null,
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  void increaseQuantity(String productId) async {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _items[index].quantity++;
      await _firebaseCartService.saveCartItems(_items);
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) async {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        await _firebaseCartService.saveCartItems(_items);
        notifyListeners();
      } else {
        removeItem(productId);
      }
    }
  }
}
