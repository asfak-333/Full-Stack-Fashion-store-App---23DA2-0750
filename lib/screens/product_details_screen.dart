import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart';
import '../core/app_snack_bar.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? selectedColor;
  String? selectedSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = context.read<ProductProvider>();
      final product = productProvider.allProducts.cast<Product?>().firstWhere(
            (p) => p?.id == widget.productId,
            orElse: () => null,
          );
      if (product != null) {
        if (product.colors.isNotEmpty) {
          selectedColor = product.colors.first;
        }
        if (product.sizes.isNotEmpty) {
          selectedSize = product.sizes.first;
        }
        setState(() {});
      } else {
        productProvider.fetchProducts();
      }
    });
  }

  Product? _getProduct() {
    final products = context.watch<ProductProvider>().allProducts;
    return products.cast<Product?>().firstWhere(
          (p) => p?.id == widget.productId,
          orElse: () => null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final product = _getProduct();

    return Scaffold(
      extendBodyBehindAppBar: true,
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
              Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Color(0xFF7A5136),
                        ),
                        onPressed: () => context.go('/cart'),
                      ),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFBA1A1A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${cart.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: product == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                  bottom: 48,
                  left: 24,
                  right: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageGallery(product),
                    const SizedBox(height: 32),
                    _buildProductInfo(product),
                    const SizedBox(height: 32),
                    _buildSelectionOptions(product),
                    const SizedBox(height: 32),
                    _buildActionButtons(product),
                    const SizedBox(height: 64),
                    _buildRelatedItems(context, product),
                    const SizedBox(height: 64),
                    _buildReviews(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImageGallery(Product product) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 4 / 5,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: product.img,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              if (product.isFeatured)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDBC7).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      'Featured',
                      style: TextStyle(
                        color: Color(0xFF574236),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'NEW ARRIVAL',
              style: TextStyle(
                color: Color(0xFF51443D),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.circle, size: 4, color: Color(0xFFD5C3B9)),
            SizedBox(width: 8),
            Text(
              'SATIN COLLECTION',
              style: TextStyle(
                color: Color(0xFF51443D),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F1B16),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Rs. ${product.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A5136),
              ),
            ),
            const Spacer(),
            const Icon(Icons.star, color: Color(0xFF7F552F), size: 18),
            const SizedBox(width: 4),
            const Text(
              '4.9 (128 Reviews)',
              style: TextStyle(
                color: Color(0xFF7F552F),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          product.description,
          style: const TextStyle(
            color: Color(0xFF51443D),
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionOptions(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.colors.isNotEmpty) ...[
          const Text(
            'SELECT COLOR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Color(0xFF1F1B16),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: product.colors.map((c) {
              final isSelected = c == selectedColor;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = c;
                  });
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getColorFromString(c),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF7A5136)
                          : const Color(0xFFD5C3B9),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
        ],
        if (product.sizes.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SELECT SIZE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF1F1B16),
                ),
              ),
              const Text(
                'Size Guide',
                style: TextStyle(
                  color: Color(0xFF7A5136),
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: product.sizes.map((s) {
              final isSelected = s == selectedSize;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSize = s;
                  });
                },
                child: _buildSizeButton(s, isSelected: isSelected),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Color _getColorFromString(String colorStr) {
    switch (colorStr.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'brown':
        return const Color(0xFF7A5136);
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'pink':
        return Colors.pink;
      default:
        return const Color(0xFFEBE1D8);
    }
  }

  Widget _buildSizeButton(String size, {required bool isSelected}) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF7A5136) : const Color(0xFFFDF2E9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : const Color(0xFFD5C3B9).withOpacity(0.3),
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF7A5136).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Center(
        child: Text(
          size,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1F1B16),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Product product) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7A5136),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
            shadowColor: const Color(0xFF7A5136).withOpacity(0.3),
          ),
          onPressed: () {
            context.read<CartProvider>().addItem(
                  productId: product.id,
                  productName: product.name,
                  productImg: product.img,
                  price: product.price,
                  color: selectedColor,
                  size: selectedSize,
                );
            AppSnackBar.showSuccess(context, '${product.name} added to bag');
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, size: 20),
              SizedBox(width: 8),
              Text(
                'Add to Cart',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1F1B16),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            side: BorderSide(color: const Color(0xFFD5C3B9).withOpacity(0.5)),
          ),
          onPressed: () {
            context.read<CartProvider>().addItem(
                  productId: product.id,
                  productName: product.name,
                  productImg: product.img,
                  price: product.price,
                  color: selectedColor,
                  size: selectedSize,
                );
            context.push('/checkout');
          },
          child: const Text(
            'Buy Now',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedItems(BuildContext context, Product product) {
    final provider = context.read<ProductProvider>();
    final relatedProducts = provider.allProducts.where((p) => p.id != product.id).take(2).toList();
    if (relatedProducts.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete the Look',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F1B16),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Curated pairings recommended for you',
                  style: TextStyle(fontSize: 14, color: Color(0xFF51443D)),
                ),
              ],
            ),
            TextButton(
              onPressed: () => context.push('/shop'),
              child: const Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF7A5136),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: Color(0xFF7A5136), size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: relatedProducts.map((p) => Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildSmallProductCard(context, p),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildSmallProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: product.img,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xFF7A5136),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF1F1B16),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Rs. ${product.price.toStringAsFixed(0)}',
            style: const TextStyle(color: Color(0xFF51443D), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'The Satin Experience',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F1B16),
          ),
        ),
        const SizedBox(height: 24),
        _buildReviewCard(
          initials: 'EM',
          color: const Color(0xFFFFDBC7),
          name: 'Elena Moore',
          text:
              '"The drape on this skirt is unlike anything I\'ve owned. It feels heavy and luxurious, yet perfectly light for summer evenings."',
          stars: 5,
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          initials: 'SK',
          color: const Color(0xFFFFDCC1),
          name: 'Sarah K.',
          text:
              '"The terracotta color is even more beautiful in person. It has a subtle shimmer that isn\'t too overpowering. Worth every penny."',
          stars: 5,
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String initials,
    required Color color,
    required String name,
    required String text,
    required int stars,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF2E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD5C3B9).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < stars ? Icons.star : Icons.star_border,
                color: const Color(0xFF7A5136),
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Color(0xFF51443D),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 20,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF574236),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'Verified Buyer',
                    style: TextStyle(color: Color(0xFF51443D), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
