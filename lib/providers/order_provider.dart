import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';
import '../core/app_exception.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository = OrderRepository();

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUserOrders(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await _repository.getUserOrders(userId);
      _orders.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      _error = AppException.fromException(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> placeOrder(OrderModel order) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.placeOrder(order);
      _orders.insert(0, order);
    } catch (e) {
      _error = AppException.fromException(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
