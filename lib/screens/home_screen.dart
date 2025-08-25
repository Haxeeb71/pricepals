import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../providers/wishlist_provider.dart';
import '../models/product.dart';
import '../services/image_service.dart';
import 'category_screen.dart';
import 'search_screen.dart';
import 'cart_screen.dart';
import 'account_screen.dart';
import 'product_detail_screen.dart';
import 'price_comparison_screen.dart';
import '../utils/screen_utils.dart';
import '../utils/responsive_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const _HomeTab(),
    const CategoryScreen(),
    const SearchScreen(),
    const CartScreen(),
    const AccountScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Add refresh logic here when needed
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: ScreenUtils.getResponsiveHeight(
                  context,
                  percent: 0.06,
                ),
                toolbarHeight: ScreenUtils.getResponsiveHeight(
                  context,
                  percent: 0.05,
                ),
                floating: true,
                pinned: true,
                centerTitle: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(
                      ScreenUtils.spacing(context, multiplier: 2),
                    ),
                  ),
                ),
                title: Text(
                  'PricePals',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtils.getFontSize(context, baseSize: 18),
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtils.spacing(context, multiplier: 2),
                    vertical: ScreenUtils.spacing(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildWelcomeSection(context),
                      SizedBox(
                        height: ScreenUtils.spacing(context, multiplier: 2),
                      ),
                      _buildQuickActions(context),
                      SizedBox(
                        height: ScreenUtils.spacing(context, multiplier: 2),
                      ),
                      _buildRecentSearches(context),
                      SizedBox(
                        height: ScreenUtils.spacing(context, multiplier: 2),
                      ),
                      _buildFeaturedProducts(context),
                      SizedBox(
                        height: ScreenUtils.spacing(context, multiplier: 2),
                      ),
                      // Add bottom padding to prevent content from being hidden by bottom navigation
                      SizedBox(
                        height:
                            kBottomNavigationBarHeight +
                            ScreenUtils.spacing(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return ScreenUtils.responsiveContainer(
      context,
      padding: EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 2)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(
          ScreenUtils.spacing(context, multiplier: 1.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              ScreenUtils.spacing(context, multiplier: 1.5),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ScreenUtils.spacing(context, multiplier: 1.5),
              ),
            ),
            child: Icon(
              Icons.waving_hand,
              color: Colors.orange,
              size: ScreenUtils.getIconSize(context, baseSize: 32),
            ),
          ),
          SizedBox(width: ScreenUtils.spacing(context, multiplier: 2)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: ScreenUtils.getResponsiveTextStyle(
                    context,
                    baseSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ScreenUtils.spacing(context, multiplier: 0.5)),
                Text(
                  'Ready to find the best deals?',
                  style: ScreenUtils.getResponsiveTextStyle(
                    context,
                    baseSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final quickActions = [
      {
        'title': 'Compare Prices',
        'image':
            'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=400&h=300&fit=crop', // Shows price tags and comparison
        'onTap': (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        ),
      },
      {
        'title': 'Track Deals',
        'image':
            'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=400&h=300&fit=crop', // Shows a graph trending upward
        'onTap': (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        ),
      },
      {
        'title': 'Price Alerts',
        'image':
            'https://images.unsplash.com/photo-1533749047139-189de3cf06d3?w=400&h=300&fit=crop', // Shows a notification bell
        'onTap': (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        ),
      },
      {
        'title': 'Shopping List',
        'image':
            'https://images.unsplash.com/photo-1594980596870-8aa52a78d8cd?w=400&h=300&fit=crop', // Shows a checklist or shopping list
        'onTap': (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        ),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: ScreenUtils.getResponsiveTextStyle(
            context,
            baseSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ScreenUtils.spacing(context, multiplier: 2)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ScreenUtils.isTablet(context) ? 4 : 2,
            crossAxisSpacing: ScreenUtils.spacing(context, multiplier: 1),
            mainAxisSpacing: ScreenUtils.spacing(context, multiplier: 1),
            childAspectRatio: ScreenUtils.isTablet(context) ? 0.9 : 1.1,
          ),
          itemCount: quickActions.length,
          itemBuilder: (context, index) {
            final action = quickActions[index];
            return _buildQuickActionCard(
              context,
              title: action['title'] as String,
              image: action['image'] as String,
              onTap: action['onTap'] as Function(BuildContext),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required String image,
    required Function(BuildContext) onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ScreenUtils.spacing(context, multiplier: 2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            ScreenUtils.spacing(context, multiplier: 2),
          ),
          child: Stack(
            children: [
              ImageService.buildProductImage(
                imageUrl: image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: ScreenUtils.spacing(context, multiplier: 1.0),
                left: ScreenUtils.spacing(context, multiplier: 1.0),
                right: ScreenUtils.spacing(context, multiplier: 1.0),
                child: ResponsiveWidgets.responsiveText(
                  context,
                  title,
                  baseSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        final recentSearches = searchProvider.searchHistory.take(5).toList();

        if (recentSearches.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: ScreenUtils.getResponsiveTextStyle(
                    context,
                    baseSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    searchProvider.clearHistory();
                  },
                  child: Text(
                    'Clear All',
                    style: ScreenUtils.getResponsiveTextStyle(
                      context,
                      baseSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtils.spacing(context, multiplier: 2)),
            Container(
              height: ScreenUtils.getResponsiveHeight(context, percent: 0.06),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  final search = recentSearches[index];
                  return Container(
                    margin: EdgeInsets.only(
                      right: ScreenUtils.spacing(context, multiplier: 1.5),
                    ),
                    child: ActionChip(
                      label: Text(
                        search.query,
                        style: ScreenUtils.getResponsiveTextStyle(
                          context,
                          baseSize: 12,
                        ),
                      ),
                      onPressed: () {
                        searchProvider.setCurrentQuery(search.query);
                        // Navigate to search screen with the query
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeaturedProducts(BuildContext context) {
    // Reduced number of products to show
    final products = _getMockProducts().take(6).toList();
    return Builder(
      builder: (context) {
        // Calculate responsive card dimensions with adaptive sizing
        final cardWidth = ScreenUtils.getResponsiveWidth(
          context,
          percent: 0.44,
        ).clamp(150.0, 180.0);
        final imageHeight = (cardWidth * 0.6).clamp(70.0, 90.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtils.spacing(context),
                right: ScreenUtils.spacing(context),
                bottom: ScreenUtils.spacing(context, multiplier: 0.5),
              ),
              child: ResponsiveWidgets.responsiveText(
                context,
                'Featured Products',
                baseSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.spacing(context),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85, // Fixed aspect ratio
                crossAxisSpacing: ScreenUtils.spacing(
                  context,
                  multiplier: 0.75,
                ),
                mainAxisSpacing: ScreenUtils.spacing(context, multiplier: 0.75),
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(
                  context,
                  product,
                  cardWidth,
                  imageHeight,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    double cardWidth,
    double imageHeight,
  ) {
    final radius = ScreenUtils.spacing(context, multiplier: 0.8);
    final padding = ScreenUtils.spacing(context, multiplier: 0.8);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
              child: ImageService.buildProductCardImage(
                imageUrl: product.image,
                width: cardWidth,
                height: imageHeight,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ResponsiveWidgets.responsiveText(
                      context,
                      product.name,
                      baseSize: 11,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtils.spacing(context, multiplier: 0.25),
                  ),
                  ResponsiveWidgets.responsiveText(
                    context,
                    '\$${product.price.toStringAsFixed(2)}',
                    baseSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(
                    height: ScreenUtils.spacing(context, multiplier: 0.25),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ResponsiveWidgets.responsiveText(
                          context,
                          product.retailer,
                          baseSize: 9,
                          color: Colors.grey[600],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PriceComparisonScreen(
                                    productName: product.name,
                                    productImage: product.image,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.compare_arrows,
                              size: ScreenUtils.getIconSize(
                                context,
                                baseSize: 12,
                              ),
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          SizedBox(
                            width: ScreenUtils.spacing(
                              context,
                              multiplier: 0.25,
                            ),
                          ),
                          Consumer<WishlistProvider>(
                            builder: (context, wishlistProvider, child) {
                              final isInWishlist = wishlistProvider
                                  .isInWishlist(product.id);
                              return IconButton(
                                onPressed: () {
                                  if (isInWishlist) {
                                    wishlistProvider.removeItem(product.id);
                                  } else {
                                    wishlistProvider.addItem(product);
                                  }
                                },
                                icon: Icon(
                                  isInWishlist
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: ScreenUtils.getIconSize(
                                    context,
                                    baseSize: 12,
                                  ),
                                  color: isInWishlist ? Colors.red : null,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: '1',
        name: 'iPhone 15 Pro',
        description:
            'Latest iPhone with advanced camera system and A17 Pro chip',
        image:
            'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=300&fit=crop',
        price: 999.99,
        retailer: 'Apple Store',
        category: 'Electronics',
        tags: ['smartphone', 'apple', 'camera'],
        rating: 4.8,
        reviewCount: 1250,
        inStock: true,
        originalPrice: 1099.99,
        discountPercentage: 9.1,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S24',
        description: 'Premium Android smartphone with AI features',
        image:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=300&fit=crop',
        price: 899.99,
        retailer: 'Best Buy',
        category: 'Electronics',
        tags: ['smartphone', 'samsung', 'android'],
        rating: 4.6,
        reviewCount: 890,
        inStock: true,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '3',
        name: 'MacBook Air M2',
        description: 'Lightweight laptop with powerful M2 chip',
        image:
            'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400&h=300&fit=crop',
        price: 1199.99,
        retailer: 'Amazon',
        category: 'Electronics',
        tags: ['laptop', 'apple', 'macbook'],
        rating: 4.9,
        reviewCount: 2100,
        inStock: true,
        originalPrice: 1299.99,
        discountPercentage: 7.7,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '4',
        name: 'Nike Air Max 270',
        description: 'Comfortable running shoes with Air Max technology',
        image:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=300&fit=crop',
        price: 129.99,
        retailer: 'Nike',
        category: 'Fashion',
        tags: ['shoes', 'running', 'nike'],
        rating: 4.5,
        reviewCount: 3400,
        inStock: true,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '5',
        name: 'Sony WH-1000XM5',
        description: 'Premium noise-canceling headphones',
        image:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=300&fit=crop',
        price: 349.99,
        retailer: 'Target',
        category: 'Electronics',
        tags: ['headphones', 'sony', 'noise-canceling'],
        rating: 4.7,
        reviewCount: 1560,
        inStock: true,
        originalPrice: 399.99,
        discountPercentage: 12.5,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '6',
        name: 'Instant Pot Duo 7-in-1',
        description: 'Multi-functional electric pressure cooker',
        image:
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        price: 89.99,
        retailer: 'Walmart',
        category: 'Home & Kitchen',
        tags: ['kitchen', 'cooking', 'instant-pot'],
        rating: 4.4,
        reviewCount: 8900,
        inStock: true,
        originalPrice: 119.99,
        discountPercentage: 25.0,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '7',
        name: 'Adidas Ultraboost 22',
        description: 'Responsive running shoes with Boost midsole',
        image:
            'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400&h=300&fit=crop',
        price: 179.99,
        retailer: 'Adidas',
        category: 'Fashion',
        tags: ['shoes', 'running', 'adidas'],
        rating: 4.6,
        reviewCount: 2100,
        inStock: true,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '8',
        name: 'Dyson V15 Detect',
        description: 'Cordless vacuum with laser dust detection',
        image:
            'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400&h=300&fit=crop',
        price: 699.99,
        retailer: 'Dyson',
        category: 'Home & Kitchen',
        tags: ['vacuum', 'dyson', 'cordless'],
        rating: 4.8,
        reviewCount: 890,
        inStock: true,
        originalPrice: 799.99,
        discountPercentage: 12.5,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '9',
        name: 'Canon EOS R6',
        description: 'Full-frame mirrorless camera with 4K video',
        image:
            'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400&h=300&fit=crop',
        price: 2499.99,
        retailer: 'B&H Photo',
        category: 'Electronics',
        tags: ['camera', 'canon', 'mirrorless'],
        rating: 4.9,
        reviewCount: 450,
        inStock: true,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '10',
        name: 'Levi\'s 501 Original Jeans',
        description: 'Classic straight-fit denim jeans',
        image:
            'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&h=300&fit=crop',
        price: 69.99,
        retailer: 'Macy\'s',
        category: 'Fashion',
        tags: ['jeans', 'levis', 'denim'],
        rating: 4.3,
        reviewCount: 5600,
        inStock: true,
        originalPrice: 89.99,
        discountPercentage: 22.2,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '11',
        name: 'PlayStation 5',
        description: 'Next-gen gaming console with 4K graphics',
        image:
            'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=400&h=300&fit=crop',
        price: 499.99,
        retailer: 'GameStop',
        category: 'Electronics',
        tags: ['gaming', 'console', 'playstation'],
        rating: 4.7,
        reviewCount: 3200,
        inStock: true,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '12',
        name: 'KitchenAid Stand Mixer',
        description: 'Professional 5-quart stand mixer in various colors',
        image:
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        price: 379.99,
        retailer: 'Williams Sonoma',
        category: 'Home & Kitchen',
        tags: ['kitchen', 'mixer', 'kitchenaid'],
        rating: 4.8,
        reviewCount: 1200,
        inStock: true,
        originalPrice: 449.99,
        discountPercentage: 15.6,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '13',
        name: 'Ray-Ban Aviator Classic',
        description: 'Timeless aviator sunglasses with UV protection',
        image:
            'https://images.unsplash.com/photo-1572635196237-14b3f2812f0d?w=400&h=300&fit=crop',
        price: 154.99,
        retailer: 'Sunglass Hut',
        category: 'Fashion',
        tags: ['sunglasses', 'ray-ban', 'aviator'],
        rating: 4.6,
        reviewCount: 2800,
        inStock: true,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '14',
        name: 'Bose QuietComfort 45',
        description: 'Premium noise-canceling headphones with comfort',
        image:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=300&fit=crop',
        price: 329.99,
        retailer: 'Bose',
        category: 'Electronics',
        tags: ['headphones', 'bose', 'noise-canceling'],
        rating: 4.7,
        reviewCount: 1800,
        inStock: true,
        originalPrice: 379.99,
        discountPercentage: 13.2,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '15',
        name: 'Nintendo Switch OLED',
        description: 'Hybrid gaming console with 7-inch OLED screen',
        image:
            'https://images.unsplash.com/photo-1578303512597-81e6cc155b3e?w=400&h=300&fit=crop',
        price: 349.99,
        retailer: 'Nintendo',
        category: 'Electronics',
        tags: ['gaming', 'console', 'nintendo'],
        rating: 4.6,
        reviewCount: 4100,
        inStock: true,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '16',
        name: 'Lululemon Align Leggings',
        description: 'Buttery-soft yoga leggings with 4-way stretch',
        image:
            'https://images.unsplash.com/photo-1544966503-7cc5ac882d5f?w=400&h=300&fit=crop',
        price: 98.99,
        retailer: 'Lululemon',
        category: 'Fashion',
        tags: ['leggings', 'yoga', 'lululemon'],
        rating: 4.8,
        reviewCount: 8900,
        inStock: true,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '17',
        name: 'Apple Watch Series 9',
        description: 'Advanced smartwatch with health monitoring',
        image:
            'https://images.unsplash.com/photo-1544117519-31a4b719223d?w=400&h=300&fit=crop',
        price: 399.99,
        retailer: 'Apple Store',
        category: 'Electronics',
        tags: ['smartwatch', 'apple', 'health'],
        rating: 4.7,
        reviewCount: 2100,
        inStock: true,
        originalPrice: 449.99,
        discountPercentage: 11.1,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '18',
        name: 'Cuisinart Food Processor',
        description: '14-cup food processor with multiple attachments',
        image:
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        price: 199.99,
        retailer: 'Bed Bath & Beyond',
        category: 'Home & Kitchen',
        tags: ['kitchen', 'food-processor', 'cuisinart'],
        rating: 4.5,
        reviewCount: 3400,
        inStock: true,
        originalPrice: 249.99,
        discountPercentage: 20.0,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '19',
        name: 'Converse Chuck Taylor All Star',
        description: 'Classic canvas sneakers in various colors',
        image:
            'https://images.unsplash.com/photo-1607522370275-f14206abe5d3?w=400&h=300&fit=crop',
        price: 59.99,
        retailer: 'Converse',
        category: 'Fashion',
        tags: ['sneakers', 'converse', 'canvas'],
        rating: 4.4,
        reviewCount: 12000,
        inStock: true,
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '20',
        name: 'Samsung 65" QLED 4K TV',
        description: 'Quantum dot display with HDR and smart features',
        image:
            'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400&h=300&fit=crop',
        price: 1299.99,
        retailer: 'Samsung',
        category: 'Electronics',
        tags: ['tv', 'samsung', '4k'],
        rating: 4.6,
        reviewCount: 890,
        inStock: true,
        originalPrice: 1599.99,
        discountPercentage: 18.8,
        lastUpdated: DateTime.now(),
      ),
    ];
  }
}
