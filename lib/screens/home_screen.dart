import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../core/app_snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
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
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  final name = auth.user?.displayName ?? 'User';
                  return Center(
                    child: CircleAvatar(
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
                    ),
                  );
                },
              ),
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
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroSection(),
              const SizedBox(height: 48),
              _buildCategoriesSection(),
              const SizedBox(height: 48),
              _buildPopularSales(),
              const SizedBox(height: 48),
              _buildNewsletterSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          height: 450,
          decoration: const BoxDecoration(color: Color(0xFFEBE1D8)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAV97IMHWqHxbKFiB1Ao4oc-kgbaHgBScNjixIHNUXAd55lEGBOPXiOG2gRrKY1IPO1iWeYpUR0b0rGHQYxSAAxpWWiDbDszLK-IiEz4SUfBnnhFXkVpiDuUXI8gmyJrwob6xrGt2GGYqUtHQ_qsaKWL5A_8YscGyC7DEIEwxtN-J7o0jjGi8DZE82o7WQfOGKi15_iaSHoSnro8cWm3b8k6TVzdJV-qf183SMMQV8RhzfG47T26haSRzxfuEROXo9KSpP0Ix_lRU0',
                fit: BoxFit.cover,
                errorWidget: (context, url, err) =>
                    const Icon(Icons.image_not_supported),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1F1B16).withOpacity(0.6),
                      Colors.transparent,
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AUTUMN / WINTER 24',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'The Minimalist\nCollective',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A5136),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => context.push('/shop'),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'New Collections',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {
        'name': 'Suits',
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAe1i07uKUfwU_Pws7XJiBsfg2scC8RTzcg2ghzO-g2xGO4aeBRHfKgqz4E809cEeCKnfgtQ6o8t5-ktF4wTvQKeqLNxo9Rg-t_ePDtb_ErO-7a5FXHDOVwiLVREWMwO5gfFMNKT7y_gVXEEdrhCYl4TdOT2cOseTPLsEyjMWn6S7VmeB833p1-yG9HpWisVI10H9i1NsaiffDUrJIDFtGUU1xoy05SQbojfIgKP74dbnjKFYJMNKeEfngTvE9HJMQGdQAb6RqR_5A',
      },
      {
        'name': 'Bags',
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA2ZwutADhJj3zw7UUtA6dQ7U0oDKN_BEnVCSaylX-ha2IjxTOPqFengdDXVj2fvtXxjKyUCxsTG4xJH2IYDlimoTMe2AJY3s6rw6w1GAKpvdbdqP2E3gOq_SnIT3pRc7w9a0JuMcYs1dPFupuwBASWEh3Hu3Hn8OCGpvnkTzdmQX4MwaJJ5F_nlepD3sEzfOXr2OBqGWV0-TFZIjk8oNPryhDr8rX-zPvF47WU3aAEBfUh4DH9FrqStkKoSip8bhoDQjSyVvqFcoA',
      },
      {
        'name': 'Dresses',
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBkRhscLHF9RQSFFjZ1NBixgSBrzVqPI6cMsR7ZD-j8fF7VP8ctI0mI2KuDZkTyRDcNtRQ6aA-Ia3nB6SgaDZGuK_qa4VlKGfidu3BN-VZHqH1LIIsJtr5VJEwrvuVIgeWmDGXx8Jy_MSx-NXUKZN6tO23qXLwPNObro-BaEbdpbIL0fC4xfNIFfJNba5_IxEV0ICHHU2KKmOBi09hrGq64FLYUrjM7L42SnJ_0t2hAhfqb94ua_JHWYR9cVad3cDRLk8SX2GwpX5k',
      },
      {
        'name': 'Kids',
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCCqKEqniS9yiaYS3gc7KjA1rUCMUex9kyhUqPChvoHd2ARaNX4yXXRi7ATyE6NLV5Zyp1OgBcYAiNTMw4QSJo_AQFTmE4wn8k6c34OzVcPEhp0pGoio2dREZVW7JuGpzHpzZybvR_jgoQcKvY5rV7g3rxuUA6zWnmXHjIdiQNQAtut2HSf5yt1-9cpIOeZgxGIryOLtnFCiX2dVru5TtmEIj0RMl3BImcIOgy1jXpD5zpwa3DI0dzHRlqGdMO3uyqYgpQaFiV2qfE',
      },
      {
        'name': 'Shoes',
        'img':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCSLuGrj6pE0lxeviuZxKLqyvAYfXO7lfy6oiGHuJeH3TXbhcnvAtNf9B_ROKLHdEUyqZIrcSneYxW7YtNh81pyJQQoVbbXa9XPWQyHYFNrgdUIljNg_SjIHgo4kSdWa_EyrzD7rPkwb6cuYt4QeOKXl5Wk_uLyPA494js_mTNaechga-1Gj8GcqvPszNltmJHXCMtnoZLuKg2Zb81y8wRZeh4oZkGLg5HoJbzEvf5aDY47Jm5Pl29D9K4ZA9Wwyvcm8b0654YiiR4',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Curated Edit',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1B16),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Shop by department',
                style: TextStyle(fontSize: 14, color: Color(0xFF51443D)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 110,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return GestureDetector(
                onTap: () => context.push('/shop?category=${cat['name']}'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF1E6DD),
                          border: Border.all(
                            color: const Color(0xFFD5C3B9).withOpacity(0.3),
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: cat['img']!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, err) =>
                                Container(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cat['name']!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F1B16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularSales() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
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
                        'Popular Series',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F1B16),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Our most featured and coveted pieces',
                        style: TextStyle(fontSize: 14, color: Color(0xFF51443D)),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.push('/shop'),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFF7A5136),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (provider.isLoading)
                const Center(child: CircularProgressIndicator(
                  color: Color(0xFF7A5136),
                ))
              else if (provider.error != null)
                _buildProductErrorState(provider)
              else if (provider.featuredProducts.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Text('No featured products right now.'),
                )
              else
                _buildProductGrid(provider.featuredProducts),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductErrorState(ProductProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD6).withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFDAD6),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 40,
            color: Color(0xFFBA1A1A),
          ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            onPressed: () => provider.fetchProducts(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text(
              'Retry',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    final leftCol = <Product>[];
    final rightCol = <Product>[];
    for (int i = 0; i < products.length; i++) {
      if (i % 2 == 0) {
        leftCol.add(products[i]);
      } else {
        rightCol.add(products[i]);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: leftCol.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: _buildProductCard(p),
            )).toList(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: rightCol.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: _buildProductCard(p),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return Builder(
      builder: (context) {
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
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: const Color(0xFFFDF2E9),
                        child: CachedNetworkImage(
                          imageUrl: product.img,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, err) => const Icon(Icons.error),
                        ),
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
                            color: product.colors.isNotEmpty ? product.colors.first : null,
                            size: product.sizes.isNotEmpty ? product.sizes.first : null,
                          );
                          AppSnackBar.showSuccess(
                            context,
                            '${product.name} added to bag',
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
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
              Row(
                children: [
                  Text(
                    'Rs. ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFF7A5136),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewsletterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF2E9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFD5C3B9).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Text(
              'Join the Collective',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1B16),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Receive early access to seasonal edits and private sales.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF51443D)),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F4),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email Address',
                  hintStyle: TextStyle(color: Color(0xFFD5C3B9)),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A5136),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'SUBSCRIBE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
