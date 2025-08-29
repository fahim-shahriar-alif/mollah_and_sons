class CartItem {
  final String productId;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String category;
  final String companyName;
  final dynamic image;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.companyName,
    required this.image,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'category': category,
      'companyName': companyName,
      'image': image,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      category: json['category'] ?? '',
      companyName: json['companyName'] ?? '',
      image: json['image'],
      quantity: json['quantity'] ?? 1,
    );
  }

  factory CartItem.fromProduct(Map<String, dynamic> product, {int quantity = 1}) {
    print('DEBUG: CartItem.fromProduct - Creating cart item from: $product');
    final cartItem = CartItem(
      productId: product['id'].toString(),
      name: product['name'] ?? 'Unknown Product',
      description: product['description'] ?? 'No description',
      price: (product['price'] ?? 0).toDouble(),
      unit: product['unit'] ?? 'unit',
      category: product['category'] ?? 'Unknown',
      companyName: product['companyName'] ?? 'Unknown',
      image: product['image'],
      quantity: quantity,
    );
    print('DEBUG: CartItem.fromProduct - Created: ${cartItem.name} (ID: ${cartItem.productId})');
    return cartItem;
  }
}
