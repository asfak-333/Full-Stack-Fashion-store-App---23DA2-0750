import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../core/app_snack_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _editName(BuildContext context, AuthProvider authProvider) {
    final controller = TextEditingController(
      text: authProvider.user?.displayName ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter your new name'),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newName = controller.text.trim();
                if (newName.isEmpty) {
                  AppSnackBar.showError(context, 'Name cannot be empty.');
                  return;
                }
                await authProvider.updateDisplayName(newName);
                if (!context.mounted) return;
                context.pop();
                if (authProvider.error != null) {
                  AppSnackBar.showError(context, authProvider.error!);
                } else {
                  AppSnackBar.showSuccess(
                    context,
                    'Name updated successfully.',
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final user = authProvider.user;

    if (!orderProvider.isLoading &&
        orderProvider.orders.isEmpty &&
        user != null) {
    }

    final String displayName = user?.displayName ?? 'Anonymous';
    final int orderCount = orderProvider.orders.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: AppBar(
            backgroundColor: const Color(0xFFFDF2E9),
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
              icon: const Icon(Icons.menu, color: Color(0xFF7A5136)),
              onPressed: () {},
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeroSection(context, authProvider, displayName),
              const SizedBox(height: 48),
              _buildMenuOptions(context, authProvider, orderCount),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    AuthProvider authProvider,
    String displayName,
  ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF1E6DD), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                color: const Color(0xFFF1E6DD),
                child: Center(
                  child: Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A5136),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _editName(context, authProvider),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7A5136),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          displayName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F1B16),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          authProvider.user?.email ?? 'No email',
          style: const TextStyle(
            color: Color(0xFF51443D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOptions(
    BuildContext context,
    AuthProvider authProvider,
    int orderCount,
  ) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.person_outline,
          iconColor: const Color(0xFF7A5136),
          iconBgColor: const Color(0xFFFFDBC7),
          title: 'My Account',
          onTap: () => _editName(context, authProvider),
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.shopping_bag_outlined,
          iconColor: const Color(0xFF7F552F),
          iconBgColor: const Color(0xFFFFDCC1),
          title: 'Orders',
          badgeText: '$orderCount ACTIVE',
          onTap: () => context.push('/orders'),
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.location_on_outlined,
          iconColor: const Color(0xFF6C5649),
          iconBgColor: const Color(0xFFFCDCCC),
          title: 'Shipping Addresses',
          onTap: () => context.push('/personal-details'),
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.credit_card_outlined,
          iconColor: const Color(0xFF643E24),
          iconBgColor: const Color(0xFFF2BB99),
          title: 'Payment Methods',
          onTap: () => context.push('/payment-details'),
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.settings_outlined,
          iconColor: const Color(0xFF51443D),
          iconBgColor: const Color(0xFFEBE1D8),
          title: 'Settings',
        ),
        const SizedBox(height: 32),
        const Divider(color: Color(0xFFD5C3B9), thickness: 1),
        _buildMenuItem(
          icon: Icons.logout,
          iconColor: const Color(0xFFBA1A1A),
          iconBgColor: const Color(0xFFFFDAD6).withOpacity(0.3),
          title: 'Logout',
          isLogout: true,
          onTap: () async {
            await authProvider.signOut();
            if (!context.mounted) return;
            context.go('/signin');
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? badgeText,
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isLogout
                        ? const Color(0xFFBA1A1A)
                        : const Color(0xFF1F1B16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (badgeText != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7A5136),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (!isLogout)
                  const Icon(Icons.chevron_right, color: Color(0xFF83746C)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
