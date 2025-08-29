import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String name;
  final String image; // URL or asset path (for backward compatibility)
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool isAvailable;
  final int stockQuantity;
  final String unit; // kg, bag, liter, etc.
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String companyName; // For backward compatibility
  final IconData? iconData; // For backward compatibility

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    String? image,
    this.isAvailable = true,
    this.stockQuantity = 0,
    this.unit = 'kg',
    this.tags = const [],
    this.companyName = 'Mollah & Sons',
    this.iconData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : image = image ?? imageUrl,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'stockQuantity': stockQuantity,
      'unit': unit,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      image: json['image'] ?? json['imageUrl'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      stockQuantity: json['stockQuantity'] ?? 0,
      unit: json['unit'] ?? 'kg',
      tags: List<String>.from(json['tags'] ?? []),
      companyName: json['companyName'] ?? 'Mollah & Sons',
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] is String 
              ? DateTime.parse(json['createdAt'])
              : (json['createdAt'] as dynamic).toDate())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? (json['updatedAt'] is String 
              ? DateTime.parse(json['updatedAt'])
              : (json['updatedAt'] as dynamic).toDate())
          : DateTime.now(),
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    String? image,
    bool? isAvailable,
    int? stockQuantity,
    String? unit,
    List<String>? tags,
    String? companyName,
    IconData? iconData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      image: image ?? this.image,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      unit: unit ?? this.unit,
      tags: tags ?? this.tags,
      companyName: companyName ?? this.companyName,
      iconData: iconData ?? this.iconData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if product is in stock
  bool get isInStock => stockQuantity > 0;

  // Check if stock is low (less than 10)
  bool get isLowStock => stockQuantity < 10 && stockQuantity > 0;

  // Check if out of stock
  bool get isOutOfStock => stockQuantity == 0;

  // Get stock status color
  Color get stockStatusColor {
    if (isOutOfStock) return Colors.red;
    if (isLowStock) return Colors.orange;
    return Colors.green;
  }

  // Get stock status text
  String get stockStatusText {
    if (isOutOfStock) return 'Out of Stock';
    if (isLowStock) return 'Low Stock';
    return 'In Stock';
  }

  // Legacy format for backward compatibility with cart service
  Map<String, dynamic> toLegacyFormat() {
    return {
      'id': id, // Keep as string for Firebase compatibility
      'name': name,
      'image': image,
      'description': description,
      'price': price,
      'category': category,
      'companyName': companyName,
      'unit': unit, // Add missing unit field
    };
  }

}
