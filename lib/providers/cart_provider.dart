import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import 'package:uuid/uuid.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void addItem({
    required String productId,
    required String productName,
    required String productImg,
    required double price,
    String? color,
    String? size,
  }) {
    String? existingKey;
    _items.forEach((key, item) {
      if (item.productId == productId &&
          item.color == color &&
          item.size == size) {
        existingKey = key;
      }
    });

    if (existingKey != null) {
      _items.update(
        existingKey!,
        (existingItem) => existingItem.copyWith(
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      final newId = const Uuid().v4();
      _items.putIfAbsent(
        newId,
        () => CartItem(
          id: newId,
          productId: productId,
          productName: productName,
          productImg: productImg,
          price: price,
          color: color,
          size: size,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeItem(id);
    } else {
      if (_items.containsKey(id)) {
        _items.update(
          id,
          (existingItem) => existingItem.copyWith(quantity: quantity),
        );
        notifyListeners();
      }
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
