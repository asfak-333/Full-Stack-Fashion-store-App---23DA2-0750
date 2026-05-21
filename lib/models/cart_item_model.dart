class CartItem {
  final String id; // unique id for this cart item
  final String productId;
  final String productName;
  final String productImg;
  final double price;
  final int quantity;
  final String? color;
  final String? size;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImg,
    required this.price,
    this.quantity = 1,
    this.color,
    this.size,
  });

  CartItem copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImg,
    double? price,
    int? quantity,
    String? color,
    String? size,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImg: productImg ?? this.productImg,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productImg': productImg,
      'price': price,
      'quantity': quantity,
      if (color != null) 'color': color,
      if (size != null) 'size': size,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImg: map['productImg'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      color: map['color'],
      size: map['size'],
    );
  }
}
