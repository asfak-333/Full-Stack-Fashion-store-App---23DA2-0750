import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_model.dart';

class AddressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Address>> getAddresses(String userId) async {
    final snapshot = await _firestore
        .collection('addresses')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Address.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> addAddress(String userId, Address address) async {
    await _firestore
        .collection('addresses')
        .doc(address.id)
        .set(address.toFirestore());
  }

  Future<void> removeAddress(String userId, String addressId) async {
    await _firestore.collection('addresses').doc(addressId).delete();
  }
}
