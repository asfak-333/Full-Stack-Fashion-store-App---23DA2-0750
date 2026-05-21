import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';
import '../core/app_exception.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<Product> _allProducts = [];
  List<Product> _featuredProducts = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get allProducts => _allProducts;
  List<Product> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allProducts = await _repository.getProducts();
      _featuredProducts = _allProducts.where((p) => p.isFeatured).toList();
    } catch (e) {
      _error = AppException.fromException(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      return await _repository.getProductById(id);
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching product by id: \$e");
      }
      return null;
    }
  }
}
