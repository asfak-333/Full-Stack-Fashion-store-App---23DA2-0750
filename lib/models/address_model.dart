class Address {
  final String id;
  final String userId; // Added userId
  final String name;
  final String street;
  final String city;
  final String zipCode;
  final String country;

  Address({
    required this.id,
    required this.userId,
    required this.name,
    required this.street,
    required this.city,
    required this.zipCode,
    required this.country,
  });

  factory Address.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Address(
      id: documentId,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      street: data['street'] ?? '',
      city: data['city'] ?? '',
      zipCode: data['zipCode'] ?? '',
      country: data['country'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'street': street,
      'city': city,
      'zipCode': zipCode,
      'country': country,
    };
  }
}
