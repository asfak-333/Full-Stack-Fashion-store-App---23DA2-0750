import 'package:flutter/foundation.dart';
import '../models/address_model.dart';
import '../repositories/address_repository.dart';
import '../core/app_exception.dart';

class AddressProvider extends ChangeNotifier {
  final AddressRepository _repository = AddressRepository();
  
  List<Address> _addresses = [];
  Address? _selectedAddress;
  bool _isLoading = false;
  String? _error;

  List<Address> get addresses => _addresses;
  Address? get selectedAddress => _selectedAddress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void selectAddress(Address address) {
    _selectedAddress = address;
    notifyListeners();
  }

  Future<void> fetchAddresses(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _addresses = await _repository.getAddresses(userId);
      if (_addresses.isNotEmpty && _selectedAddress == null) {
        _selectedAddress = _addresses.first;
      } else if (_addresses.isEmpty) {
        _selectedAddress = null;
      }
    } catch (e) {
      _error = AppException.fromException(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAddress(String userId, Address address) async {
    try {
      await _repository.addAddress(userId, address);
      await fetchAddresses(userId);
    } catch (e) {
      _error = AppException.fromException(e);
      notifyListeners();
    }
  }

  Future<void> removeAddress(String userId, String addressId) async {
    try {
      await _repository.removeAddress(userId, addressId);
      if (_selectedAddress?.id == addressId) {
        _selectedAddress = null;
      }
      await fetchAddresses(userId);
    } catch (e) {
      _error = AppException.fromException(e);
      notifyListeners();
    }
  }
}
