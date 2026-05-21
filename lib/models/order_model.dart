import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item_model.dart';
import 'address_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalPrice;
  final Address selectedAddress;
  final DateTime timestamp;
  final String status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.selectedAddress,
    required this.timestamp,
    this.status = 'Pending',
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return OrderModel(
      id: documentId,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>? ?? [])
          .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
      selectedAddress: Address.fromFirestore(
          data['selectedAddress'] as Map<String, dynamic>? ?? {}, ''),
      timestamp: data['timestamp'] != null 
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      status: data['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((e) => e.toMap()).toList(),
      'totalPrice': totalPrice,
      'selectedAddress': selectedAddress.toFirestore(),
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status,
    };
  }
}
