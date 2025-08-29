import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Get all products
  Stream<List<ProductModel>> getProducts() {
    print('DEBUG: ProductService - Starting to fetch products from Firestore');
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) {
          print('DEBUG: ProductService - Received snapshot with ${snapshot.docs.length} documents');
          final products = <ProductModel>[];
          
          for (var doc in snapshot.docs) {
            try {
              print('DEBUG: ProductService - Processing document ${doc.id}: ${doc.data()}');
              final product = ProductModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              });
              products.add(product);
            } catch (e) {
              print('DEBUG: ProductService - Error processing document ${doc.id}: $e');
            }
          }
          
          // Sort by createdAt if available, otherwise by id
          products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          
          print('DEBUG: ProductService - Returning ${products.length} products');
          return products;
        });
  }

  // Get products by category
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  // Get available products only
  Stream<List<ProductModel>> getAvailableProducts() {
    return _firestore
        .collection(_collection)
        .where('isAvailable', isEqualTo: true)
        .where('stockQuantity', isGreaterThan: 0)
        .orderBy('stockQuantity', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  // Search products
  Stream<List<ProductModel>> searchProducts(String query) {
    return _firestore
        .collection(_collection)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  // Add new product (Admin function)
  Future<String> addProduct(ProductModel product) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'category': product.category,
        'imageUrl': product.imageUrl,
        'isAvailable': product.isAvailable,
        'stockQuantity': product.stockQuantity,
        'unit': product.unit,
        'tags': product.tags,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw 'Error adding product: $e';
    }
  }

  // Update product (Admin function)
  Future<void> updateProduct(String productId, ProductModel product) async {
    try {
      await _firestore.collection(_collection).doc(productId).update({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'category': product.category,
        'imageUrl': product.imageUrl,
        'isAvailable': product.isAvailable,
        'stockQuantity': product.stockQuantity,
        'unit': product.unit,
        'tags': product.tags,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Error updating product: $e';
    }
  }

  // Update stock quantity
  Future<void> updateStock(String productId, int newQuantity) async {
    try {
      await _firestore.collection(_collection).doc(productId).update({
        'stockQuantity': newQuantity,
        'isAvailable': newQuantity > 0,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Error updating stock: $e';
    }
  }

  // Delete product (Admin function)
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection(_collection).doc(productId).delete();
    } catch (e) {
      throw 'Error deleting product: $e';
    }
  }

  // Get product categories
  Future<List<String>> getCategories() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final categories = snapshot.docs
          .map((doc) => doc.data()['category'] as String)
          .toSet()
          .toList();
      return categories;
    } catch (e) {
      return ['Chemical Fertilizer', 'Organic Fertilizer', 'Seeds', 'Tools'];
    }
  }

  // Initialize with demo products (call this once to populate database)
  Future<void> initializeDemoProducts() async {
    try {
      final snapshot = await _firestore.collection(_collection).limit(1).get();
      if (snapshot.docs.isEmpty) {
        // Add demo products if collection is empty
        final demoProducts = [
          {
            'name': 'NPK Fertilizer (20-20-20)',
            'description': 'High-quality NPK fertilizer with balanced nutrients for all crops. Suitable for vegetables, fruits, and field crops.',
            'price': 850.0,
            'category': 'Chemical Fertilizer',
            'imageUrl': 'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=NPK+Fertilizer',
            'isAvailable': true,
            'stockQuantity': 100,
            'unit': 'bag (50kg)',
            'tags': ['npk', 'chemical', 'all-crops', 'balanced'],
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Urea Fertilizer',
            'description': 'Premium urea fertilizer providing 46% nitrogen for rapid plant growth and green foliage.',
            'price': 720.0,
            'category': 'Chemical Fertilizer',
            'imageUrl': 'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Urea+Fertilizer',
            'isAvailable': true,
            'stockQuantity': 150,
            'unit': 'bag (50kg)',
            'tags': ['urea', 'nitrogen', 'chemical', 'growth'],
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Organic Compost',
            'description': 'Natural organic compost made from decomposed plant matter. Improves soil structure and fertility.',
            'price': 450.0,
            'category': 'Organic Fertilizer',
            'imageUrl': 'https://via.placeholder.com/300x200/8BC34A/FFFFFF?text=Organic+Compost',
            'isAvailable': true,
            'stockQuantity': 80,
            'unit': 'bag (25kg)',
            'tags': ['organic', 'compost', 'natural', 'soil-health'],
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Potash Fertilizer (MOP)',
            'description': 'Muriate of Potash providing 60% K2O for fruit development and disease resistance.',
            'price': 920.0,
            'category': 'Chemical Fertilizer',
            'imageUrl': 'https://via.placeholder.com/300x200/FF9800/FFFFFF?text=Potash+Fertilizer',
            'isAvailable': true,
            'stockQuantity': 75,
            'unit': 'bag (50kg)',
            'tags': ['potash', 'potassium', 'fruits', 'disease-resistance'],
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'DAP Fertilizer',
            'description': 'Di-ammonium Phosphate with 18% Nitrogen and 46% Phosphorus for root development.',
            'price': 980.0,
            'category': 'Chemical Fertilizer',
            'imageUrl': 'https://via.placeholder.com/300x200/9C27B0/FFFFFF?text=DAP+Fertilizer',
            'isAvailable': true,
            'stockQuantity': 60,
            'unit': 'bag (50kg)',
            'tags': ['dap', 'phosphorus', 'nitrogen', 'roots'],
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Vermicompost',
            'description': 'Premium vermicompost produced by earthworms. Rich in nutrients and beneficial microorganisms.',
            'price': 380.0,
            'category': 'Organic Fertilizer',
            'imageUrl': 'https://via.placeholder.com/300x200/795548/FFFFFF?text=Vermicompost',
            'isAvailable': true,
            'stockQuantity': 45,
            'unit': 'bag (20kg)',
            'tags': ['vermicompost', 'organic', 'earthworm', 'microorganisms'],
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
        ];

        for (var product in demoProducts) {
          await _firestore.collection(_collection).add(product);
        }
      }
    } catch (e) {
      print('Error initializing demo products: $e');
    }
  }
}
