import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<OrderProvider>().fetchUserOrders(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.orders;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4), // Surface
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: AppBar(
            backgroundColor: const Color(0xFFFFF8F4).withOpacity(0.7),
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: BackdropFilter(
              filter: ColorFilter.mode(
                Colors.white.withOpacity(0.0),
                BlendMode.dstATop,
              ),
            ),
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
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/profile');
                }
              },
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
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Orders',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F1B16),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Trace your curated selections and past acquisitions.',
                style: TextStyle(fontSize: 16, color: Color(0xFF51443D)),
              ),
              const SizedBox(height: 32),
              _buildFilterChips(),
              const SizedBox(height: 32),
              if (orderProvider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: CircularProgressIndicator(
                      color: Color(0xFF7A5136),
                    ),
                  ),
                )
              else if (orderProvider.error != null)
                _buildErrorState(context, orderProvider)
              else if (orders.isEmpty)
                _buildEmptyState()
              else
                ...orders.map((order) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildOrderCard(order),
                  );
                }),
              const SizedBox(height: 48),
              _buildHelpSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, OrderProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFDAD6).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_outlined,
                size: 48,
                color: Color(0xFFBA1A1A),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Could not load orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1B16),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF51443D),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A5136),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                final user = context.read<AuthProvider>().user;
                if (user != null) {
                  provider.fetchUserOrders(user.uid);
                }
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Color(0xFFD5C3B9),
            ),
            SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1B16),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your curated selections will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF51443D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('All Orders', isSelected: true),
          const SizedBox(width: 12),
          _buildChip('In Progress', isSelected: false),
          const SizedBox(width: 12),
          _buildChip('Delivered', isSelected: false),
          const SizedBox(width: 12),
          _buildChip('Returns', isSelected: false),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF7A5136) : const Color(0xFFFDF2E9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF7A5136).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF51443D),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    Color statusColor = const Color(0xFF51443D);
    Color statusBgColor = const Color(0xFF83746C);
    IconData actionIcon = Icons.schedule;
    String actionText = 'Processing your order';

    if (order.status.toLowerCase() == 'shipped') {
      statusColor = const Color(0xFF7F552F);
      statusBgColor = const Color(0xFF7F552F);
      actionIcon = Icons.local_shipping_outlined;
      actionText = 'Estimated arrival: Soon';
    } else if (order.status.toLowerCase() == 'delivered') {
      statusColor = const Color(0xFF96694C);
      statusBgColor = const Color(0xFF96694C);
      actionIcon = Icons.check_circle_outline;
      actionText = 'Delivered';
    }

    final images = order.items.map((e) => e.productImg).take(3).toList();
    final extraItems = order.items.length > 3 ? order.items.length - 3 : 0;
    
    final formattedDate = DateFormat.yMMMd().format(order.timestamp);
    final isDelivered = order.status.toLowerCase() == 'delivered';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD5C3B9).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F1B16).withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusBgColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.id.substring(0, 8).toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1F1B16),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Placed on $formattedDate',
                    style: const TextStyle(
                      color: Color(0xFF51443D),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rs. ${order.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF7A5136),
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '${order.items.length} ITEMS',
                    style: const TextStyle(
                      color: Color(0xFF51443D),
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ...images.map((img) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: img,
                      width: 80,
                      height: 96,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, err) => const Icon(Icons.image_not_supported),
                    ),
                  ),
                );
              }),
              if (extraItems > 0)
                Container(
                  width: 80,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF2E9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFD5C3B9).withOpacity(0.5),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '+$extraItems',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF51443D),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1E6DD)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(actionIcon, size: 16, color: const Color(0xFF51443D)),
                  const SizedBox(width: 8),
                  Text(
                    actionText,
                    style: const TextStyle(
                      color: Color(0xFF51443D),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (isDelivered)
                const Text(
                  'Buy it again',
                  style: TextStyle(
                    color: Color(0xFF7A5136),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )
              else
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF7A5136),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDBC7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Need assistance with an order?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF301401),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Our curators are available 24/7 to help you with returns or shipping inquiries.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF643E24), fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7A5136),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
            ),
            onPressed: () {},
            child: const Text(
              'Contact Support',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
