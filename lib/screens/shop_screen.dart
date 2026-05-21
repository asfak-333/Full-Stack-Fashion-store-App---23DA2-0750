import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../models/product_model.dart';
import '../core/app_snack_bar.dart';

class ShopScreen extends StatefulWidget {
  final String? initialCategory;
  const ShopScreen({super.key, this.initialCategory});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _selectedCategory = 'All Items';

  final List<String> _categories = [
    'All Items',
    'Suits',
    'Bags',
    'Dresses',
    'Kids',
    'Shoes',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Color(0xFF7A5136),
                ),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    final name = auth.user?.displayName ?? 'User';
                    return CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFFF1E6DD),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A5136),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 100,
                bottom: 120,
                left: 24,
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 32),
                  const Text(
                    'SUMMER 2024',
                    style: TextStyle(
                      color: Color(0xFF7A5136),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Curated Essentials for the Modern Wardrobe',
                    style: TextStyle(
                      fontSize: 32,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F1B16),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildFilters(),
                  const SizedBox(height: 32),
                  if (provider.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: CircularProgressIndicator(color: Color(0xFF7A5136)),
                      ),
                    )
                  else if (provider.error != null)
                    _buildProductErrorState(provider)
                  else if (provider.allProducts.isEmpty)
                    const Center(child: Text('No products found.'))
                  else
                    _buildProductGrid(
                      context,
                      _selectedCategory == 'All Items'
                          ? provider.allProducts
                          : provider.allProducts
                              .where((p) => p.category == _selectedCategory)
                              .toList(),
                    ),
                  const SizedBox(height: 48),
                  _buildPagination(provider.allProducts.length),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductErrorState(ProductProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD6).withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFDAD6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_outlined, size: 40, color: Color(0xFFBA1A1A)),
          const SizedBox(height: 12),
          const Text(
            'Could not load products',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F1B16),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            provider.error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF51443D),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF7A5136),
              side: const BorderSide(color: Color(0xFF7A5136)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => provider.fetchProducts(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDF2E9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Color(0xFF51443D)),
          border: InputBorder.none,
          hintText: 'Search our collection',
          hintStyle: TextStyle(color: Color(0xFFD5C3B9)),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? const Color(0xFF7A5136)
                    : const Color(0xFFFDF2E9),
                foregroundColor: isSelected
                    ? Colors.white
                    : const Color(0xFF51443D),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Text(
                category,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0),
          child: Column(
            children: [
              Icon(Icons.search_off_outlined, size: 64, color: const Color(0xFFD5C3B9)),
              const SizedBox(height: 16),
              const Text(
                'No products in this category',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF51443D),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final leftCol = <Product>[];
    final rightCol = <Product>[];

    final featuredProduct = products.first;
    final remainingProducts = products.sublist(1);

    for (int i = 0; i < remainingProducts.length; i++) {
      if (i % 2 == 0) {
        leftCol.add(remainingProducts[i]);
      } else {
        rightCol.add(remainingProducts[i]);
      }
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => context.push('/product/${featuredProduct.id}'),
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: featuredProduct.img,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (featuredProduct.isFeatured)
                          const Text(
                            'BEST SELLER',
                            style: TextStyle(
                              color: Color(0xFF7A5136),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          featuredProduct.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF1F1B16),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rs. ${featuredProduct.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xFF51443D),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 24,
                  right: 24,
                  child: GestureDetector(
                    onTap: () {
                      context.read<CartProvider>().addItem(
                        productId: featuredProduct.id,
                        productName: featuredProduct.name,
                        productImg: featuredProduct.img,
                        price: featuredProduct.price,
                        color: featuredProduct.colors.isNotEmpty
                            ? featuredProduct.colors.first
                            : null,
                        size: featuredProduct.sizes.isNotEmpty
                            ? featuredProduct.sizes.first
                            : null,
                      );
                      AppSnackBar.showSuccess(context, '${featuredProduct.name} added to bag');
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF96694C),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: leftCol
                    .map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: _buildSmallProductCard(context, p),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: rightCol
                    .map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: _buildSmallProductCard(context, p),
                        ))
                    .toList(),
              ),
            ),
          ],
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
                    placeholder: (context, url) =>
                        Container(color: const Color(0xFFFDF2E9)),
                    errorWidget: (context, url, err) =>
                        const Icon(Icons.error),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      context.read<CartProvider>().addItem(
                        productId: product.id,
                        productName: product.name,
                        productImg: product.img,
                        price: product.price,
                        color: product.colors.isNotEmpty
                            ? product.colors.first
                            : null,
                        size: product.sizes.isNotEmpty
                            ? product.sizes.first
                            : null,
                      );
                      AppSnackBar.showSuccess(context, '${product.name} added to bag');
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBE1D8).withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag,
                        color: Color(0xFF7A5136),
                        size: 18,
                      ),
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
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF1F1B16),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Rs. ${product.price.toStringAsFixed(0)}',
                style: const TextStyle(color: Color(0xFF51443D), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(int totalItems) {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7A5136),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Explore More',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Viewing $totalItems items',
            style: const TextStyle(color: Color(0xFF51443D), fontSize: 14),
          ),
        ),
      ],
    );
  }
}
