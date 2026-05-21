import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: AppBar(
            backgroundColor: const Color(
              0xFFFDF2E9,
            ),
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text(
              'Satin & Stone',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1B16),
                letterSpacing: -0.5,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF7A5136)),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Color(0xFF7A5136),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.black.withOpacity(0.05),
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final items = cartProvider.items.values.toList();
          final total = cartProvider.totalAmount;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Color(0xFFD5C3B9),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your bag is empty',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1B16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A5136),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => context.go('/shop'),
                    child: const Text('Continue Shopping'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shopping Bag',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F1B16),
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${items.length} item${items.length > 1 ? 's' : ''} curated for you',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF51443D),
                  ),
                ),
                const SizedBox(height: 32),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: _buildCartItem(context: context, item: item),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEBE1D8)),
                const SizedBox(height: 24),
                _buildSummaryRow(
                  'Subtotal',
                  'Rs. ${total.toStringAsFixed(0)}',
                  isBold: true,
                ),
                const SizedBox(height: 16),
                _buildSummaryRow('Shipping', 'FREE', isPrimary: true),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEBE1D8)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1B16),
                      ),
                    ),
                    Text(
                      'Rs. ${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1F1B16),
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A5136),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    shadowColor: const Color(0xFF7A5136).withOpacity(0.4),
                  ),
                  onPressed: () {
                    context.push('/checkout');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartItem({
    required BuildContext context,
    required CartItem item,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF2E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item.productImg,
              width: 90,
              height: 120,
              fit: BoxFit.cover,
              errorWidget: (context, url, err) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1F1B16),
                          height: 1.2,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<CartProvider>().removeItem(item.id);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFFD5C3B9),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (item.size != null)
                  Text.rich(
                    TextSpan(
                      text: 'Size: ',
                      style: const TextStyle(
                        color: Color(0xFF51443D),
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: item.size,
                          style: const TextStyle(
                            color: Color(0xFF1F1B16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (item.color != null)
                  Text.rich(
                    TextSpan(
                      text: 'Color: ',
                      style: const TextStyle(
                        color: Color(0xFF51443D),
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: item.color,
                          style: const TextStyle(
                            color: Color(0xFF1F1B16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rs. ${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Color(0xFF7A5136),
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBE1D8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<CartProvider>().updateQuantity(
                                item.id,
                                item.quantity - 1,
                              );
                            },
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.remove,
                                size: 14,
                                color: Color(0xFF51443D),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF1F1B16),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<CartProvider>().updateQuantity(
                                item.id,
                                item.quantity + 1,
                              );
                            },
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Color(0xFF7A5136),
                              child: Icon(
                                Icons.add,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    bool isPrimary = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF51443D),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isBold || isPrimary
                ? FontWeight.bold
                : FontWeight.normal,
            color: isPrimary
                ? const Color(0xFF96694C)
                : const Color(0xFF1F1B16),
          ),
        ),
      ],
    );
  }
}
