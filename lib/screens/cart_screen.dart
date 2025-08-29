import 'dart:math';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/language_toggle_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();

  late AnimationController _slideController;
  late AnimationController _bounceController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Initialize cart to load items from Firebase
    _cartService.initialize();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _slideController.forward();
    _bounceController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    print('DEBUG: CartScreen - Building with ${_cartService.items.length} items');
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1B5E20),
                Color(0xFF2E7D32),
                Color(0xFF388E3C),
              ],
            ),
          ),
        ),
        foregroundColor: Colors.white,
        title: SlideTransition(
          position: _slideAnimation,
          child: Text(localizations.shoppingCart),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          SlideTransition(
            position: _slideAnimation,
            child: LanguageToggleButton(),
          ),
          const SizedBox(width: 8),
          if (_cartService.items.isNotEmpty)
            TextButton(
              onPressed: () => _showClearCartDialog(),
              child: Text(
                localizations.clearAll,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _cartService,
        builder: (context, child) {
          print('DEBUG: CartScreen - ListenableBuilder rebuilding, items: ${_cartService.items.length}');
          if (_cartService.items.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.04,
                  ),
                  itemCount: _cartService.items.length,
                  itemBuilder: (context, index) {
                    final item = _cartService.items[index];
                    return _buildCartItem(item);
                  },
                ),
              ),
              _buildCartSummary(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: MediaQuery.of(context).size.width * 0.2,
            color: Colors.grey[400],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            localizations.cartEmpty,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            localizations.addSomeFertilizers,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.015,
      ),
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Icon
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF1F8E9),
                  Color(0xFFE8F5E8),
                  Color(0xFFDCEDC8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconFromString(item.image),
              size: MediaQuery.of(context).size.width * 0.08,
              color: const Color(0xFF2E7D32),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.04),
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: MediaQuery.of(context).size.width * 0.032,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                Wrap(
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 600 + (0 * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, animationValue, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - animationValue)),
                          child: Opacity(
                            opacity: animationValue,
                            child: Transform.translate(
                              offset: Offset(0, 2 * sin(animationValue * 2 * pi)),
                              child: Container(
                                child: Text(
                                  '৳${item.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      ' ${item.unit}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Quantity Controls
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: MediaQuery.of(context).size.width * 0.08,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _cartService.decreaseQuantity(item.productId);
                        });
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: const Color(0xFF2E7D32),
                      padding: EdgeInsets.zero,
                      iconSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: MediaQuery.of(context).size.width * 0.08,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _cartService.increaseQuantity(item.productId);
                        });
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: const Color(0xFF2E7D32),
                      padding: EdgeInsets.zero,
                      iconSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.008),
              Text(
                '৳${(item.price * item.quantity).toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E7D32),
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary() {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width * 0.05,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.totalItems,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_cartService.itemCount}',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.totalAmount,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${localizations.currency}${_cartService.totalAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.06,
            child: ElevatedButton(
              onPressed: () => _showCheckoutDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                localizations.checkout,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text('Are you sure you want to remove all items from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _cartService.clearCart();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cart cleared successfully'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  IconData _getIconFromString(dynamic iconValue) {
    // Handle different icon representations
    if (iconValue is IconData) {
      return iconValue;
    }
    
    // Convert string representation to IconData
    String iconString = iconValue?.toString() ?? '';
    
    // Map common icon strings to IconData
    switch (iconString.toLowerCase()) {
      case 'icons.eco':
      case 'eco':
        return Icons.eco;
      case 'icons.agriculture':
      case 'agriculture':
        return Icons.agriculture;
      case 'icons.grass':
      case 'grass':
        return Icons.grass;
      case 'icons.nature':
      case 'nature':
        return Icons.nature;
      case 'icons.local_florist':
      case 'local_florist':
        return Icons.local_florist;
      default:
        return Icons.eco; // Default fallback icon
    }
  }

  void _showCheckoutDialog() {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.checkout),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${localizations.totalItems} ${_cartService.itemCount}'),
              Text('${localizations.totalAmount} ৳${_cartService.totalAmount.toStringAsFixed(0)}'),
              const SizedBox(height: 16),
              Text(localizations.orderDeliveryInfo),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                // Save order to Firebase using OrderService
                final success = await _orderService.saveOrder(
                  _cartService.items,
                  _cartService.totalAmount,
                );
                
                if (success) {
                  _cartService.clearCart();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.orderPlaced),
                      backgroundColor: const Color(0xFF2E7D32),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.orderFailed),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              child: Text(localizations.placeOrder),
            ),
          ],
        );
      },
    );
  }
}
