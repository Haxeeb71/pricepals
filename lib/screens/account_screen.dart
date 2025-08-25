import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import 'wishlist_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (!authProvider.isAuthenticated) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Please sign in to access your account',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileSection(context, authProvider),
                const SizedBox(height: 24),
                _buildQuickStats(context),
                const SizedBox(height: 24),
                _buildMenuItems(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, AuthProvider authProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                authProvider.userEmail?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              authProvider.userEmail ?? 'User',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Member since ${DateTime.now().year}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              return _buildStatCard(
                context,
                'Wishlist',
                '${wishlistProvider.itemCount}',
                Icons.favorite,
                Colors.red,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WishlistScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return _buildStatCard(
                context,
                'Cart',
                '${cartProvider.itemCount}',
                Icons.shopping_cart,
                Colors.blue,
                () {
                  // Navigate to cart (already in bottom nav)
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      {
        'title': 'Edit Profile',
        'icon': Icons.edit,
        'onTap': () {
          // TODO: Implement edit profile
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit profile coming soon!')),
          );
        },
      },
      {
        'title': 'Order History',
        'icon': Icons.history,
        'onTap': () {
          // TODO: Implement order history
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order history coming soon!')),
          );
        },
      },
      {
        'title': 'Addresses',
        'icon': Icons.location_on,
        'onTap': () {
          // TODO: Implement addresses
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Addresses coming soon!')),
          );
        },
      },
      {
        'title': 'Payment Methods',
        'icon': Icons.payment,
        'onTap': () {
          // TODO: Implement payment methods
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment methods coming soon!')),
          );
        },
      },
      {
        'title': 'Notifications',
        'icon': Icons.notifications,
        'onTap': () {
          // TODO: Implement notifications
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notifications coming soon!')),
          );
        },
      },
      {
        'title': 'Help & Support',
        'icon': Icons.help,
        'onTap': () {
          // TODO: Implement help & support
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Help & support coming soon!')),
          );
        },
      },
      {
        'title': 'About',
        'icon': Icons.info,
        'onTap': () {
          // TODO: Implement about
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('About coming soon!')),
          );
        },
      },
    ];

    return Column(
      children: menuItems.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              item['icon'] as IconData,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(item['title'] as String),
            trailing: const Icon(Icons.chevron_right),
            onTap: item['onTap'] as VoidCallback,
          ),
        );
      }).toList(),
    );
  }
}
