import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderModel order) async {
    await _firestore.collection('orders').add(order.toFirestore());
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    final snapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => OrderModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
