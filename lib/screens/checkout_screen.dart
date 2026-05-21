import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../providers/address_provider.dart';
import '../models/order_model.dart';
import '../models/address_model.dart';
import '../core/app_snack_bar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<AddressProvider>().fetchAddresses(authProvider.user!.uid);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cartProvider = context.read<CartProvider>();
    final authProvider = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();

    if (!authProvider.isAuthenticated) {
      AppSnackBar.showInfo(
        context,
        'Please sign in to complete your purchase.',
      );
      context.push('/signin');
      return;
    }

    if (cartProvider.items.isEmpty) {
      AppSnackBar.showInfo(context, 'Your cart is empty.');
      return;
    }

    final address = context.read<AddressProvider>().selectedAddress;

    if (address == null) {
      AppSnackBar.showError(context, 'Please add a shipping address first.');
      context.push('/personal-details');
      return;
    }

    final userId = authProvider.user!.uid;

    final newOrder = OrderModel(
      id: const Uuid().v4(),
      userId: userId,
      items: cartProvider.items.values.toList(),
      totalPrice: cartProvider.totalAmount,
      selectedAddress: address,
      timestamp: DateTime.now(),
      status: 'Processing',
    );

    await orderProvider.placeOrder(newOrder);

    if (orderProvider.error == null) {
      cartProvider.clear();
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Order Placed Successfully'),
          content: const Text('Thank you for shopping with Satin & Stone.'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
                context.go('/');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      if (!mounted) return;
      AppSnackBar.showError(
        context,
        orderProvider.error ?? 'Failed to place order. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final cartItems = cartProvider.items.values.toList();
    final subtotal = cartProvider.totalAmount;
    final total = subtotal;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
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
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_bag, color: Color(0xFF7A5136)),
                onPressed: () => context.go('/cart'),
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
            bottom: 48,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F1B16),
                  ),
                ),
                const SizedBox(height: 32),
                _buildStepper(),
                const SizedBox(height: 48),
                _buildSectionTitle('Shipping Address'),
                const SizedBox(height: 24),
                Consumer<AddressProvider>(
                  builder: (context, addressProvider, child) {
                    final selectedAddress = addressProvider.selectedAddress;
                    if (selectedAddress == null) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDAD6).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFDAD6)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'No shipping address found',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.push('/personal-details'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7A5136),
                              ),
                              child: const Text('Add Address'),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF2E9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFF7A5136)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedAddress.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${selectedAddress.street}, ${selectedAddress.city} ${selectedAddress.zipCode}',
                                  style: const TextStyle(color: Color(0xFF51443D), fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/personal-details'),
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),
                _buildSectionTitle('Payment Method'),
                const SizedBox(height: 24),
                _buildPaymentMethods(),
                const SizedBox(height: 48),
                _buildOrderSummary(cartItems, subtotal, total, orderProvider.isLoading),
                const SizedBox(height: 24),
                _buildProtectionPlanBadge(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _buildStep(number: '1', label: 'SHIPPING', isActive: true),
        Expanded(
          child: Container(
            height: 2,
            color: const Color(0xFF83746C).withOpacity(0.3),
          ),
        ),
        _buildStep(number: '2', label: 'PAYMENT', isActive: true),
        Expanded(
          child: Container(
            height: 2,
            color: const Color(0xFF83746C).withOpacity(0.3),
          ),
        ),
        _buildStep(number: '3', label: 'REVIEW', isActive: true),
      ],
    );
  }

  Widget _buildStep({
    required String number,
    required String label,
    required bool isActive,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF7A5136) : Colors.transparent,
            shape: BoxShape.circle,
            border: isActive
                ? null
                : Border.all(
                    color: const Color(0xFF83746C).withOpacity(0.4),
                    width: 2,
                  ),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : const Color(0xFF1F1B16).withOpacity(0.4),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive
                ? const Color(0xFF7A5136)
                : const Color(0xFF1F1B16).withOpacity(0.4),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F1B16),
          ),
        ),
      ],
    );
  }



  Widget _buildInputField({
    required String label,
    required String hint,
    IconData? suffixIcon,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Color(0xFF51443D),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFDF2E9),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF83746C)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, color: const Color(0xFF83746C))
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => context.push('/payment-details'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7A5136), Color(0xFF96694C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7A5136).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.credit_card, color: Colors.white),
                    Text(
                      'PREMIUM SAVED',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  '**** **** **** 4242',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'JULIANNE MOORE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }





  Widget _buildOrderSummary(List<dynamic> items, double subtotal, double total, bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E6DD),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F1B16),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFD5C3B9)),
          const SizedBox(height: 24),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: _buildSummaryItem(
                  img: item.productImg,
                  title: item.productName,
                  desc: '${item.color ?? ''} ${item.size != null ? '/ Size ${item.size}' : ''} x${item.quantity}',
                  price: 'Rs. ${(item.price * item.quantity).toStringAsFixed(0)}',
                ),
              )),
          const Divider(color: Color(0xFFD5C3B9)),
          const SizedBox(height: 24),
          _buildTotalsRow('Subtotal', 'Rs. ${subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 12),
          _buildTotalsRow('Shipping', 'Free', isPrimary: true),
          const SizedBox(height: 16),
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1B16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7A5136),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
            ),
            onPressed: isLoading ? null : _placeOrder,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Place Order',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'SECURE CHECKOUT POWERED BY SATIN & STONE',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF51443D),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String img,
    required String title,
    required String desc,
    required String price,
  }) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: img,
            width: 70,
            height: 90,
            fit: BoxFit.cover,
            errorWidget: (context, url, err) => const Icon(Icons.image_not_supported),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(color: Color(0xFF51443D), fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalsRow(String label, String value, {bool isPrimary = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF51443D), fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
            color: isPrimary
                ? const Color(0xFF96694C)
                : const Color(0xFF51443D),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildProtectionPlanBadge() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDBC7).withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user, color: Color(0xFF7A5136)),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stone Protection Plan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Your order is protected by our 30-day premium return policy and quality guarantee.',
                  style: TextStyle(
                    color: Color(0xFF51443D),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
