class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? oldPrice;
  final String img;
  final bool isFeatured;
  final List<String> colors;
  final List<String> sizes;

  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.img,
    required this.category,
    this.isFeatured = false,
    this.colors = const [],
    this.sizes = const [],
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      oldPrice: data['oldPrice'] != null ? data['oldPrice'].toDouble() : null,
      img: data['img'] ?? '',
      category: data['category'] ?? 'Uncategorized',
      isFeatured: data['isFeatured'] ?? false,
      colors: List<String>.from(data['colors'] ?? []),
      sizes: List<String>.from(data['sizes'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      if (oldPrice != null) 'oldPrice': oldPrice,
      'img': img,
      'category': category,
      'isFeatured': isFeatured,
      'colors': colors,
      'sizes': sizes,
    };
  }
}
