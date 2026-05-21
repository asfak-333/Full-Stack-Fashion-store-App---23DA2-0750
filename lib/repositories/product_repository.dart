import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs
        .map((doc) => Product.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<List<Product>> getFeaturedProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .where('isFeatured', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => Product.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<Product?> getProductById(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();
    if (doc.exists && doc.data() != null) {
      return Product.fromFirestore(doc.data()!, doc.id);
    }
    return null;
  }
}
