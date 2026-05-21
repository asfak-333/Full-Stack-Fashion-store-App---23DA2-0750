import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/shop')) {
      currentIndex = 1;
    } else if (location.startsWith('/cart')) {
      currentIndex = 2;
    } else if (location.startsWith('/profile')) {
      currentIndex = 3;
    }

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 16.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 64,
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: const Color(0xFFEBE1D8).withOpacity(0.8),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1F1B16).withOpacity(0.08),
                    blurRadius: 40,
                    offset: const Offset(0, 24),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      context: context,
                      icon: Icons.home_filled,
                      label: 'Home',
                      index: 0,
                      currentIndex: currentIndex,
                      onTap: () => context.go('/'),
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.storefront,
                      label: 'Shop',
                      index: 1,
                      currentIndex: currentIndex,
                      onTap: () => context.go('/shop'),
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.shopping_bag_outlined,
                      label: 'Cart',
                      index: 2,
                      currentIndex: currentIndex,
                      onTap: () => context.go('/cart'),
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.person_outline,
                      label: 'Profile',
                      index: 3,
                      currentIndex: currentIndex,
                      onTap: () => context.go('/profile'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: isSelected
            ? const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7A5136), Color(0xFF96694C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              )
            : null,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF51443D),
          size: 26,
        ),
      ),
    );
  }
}
