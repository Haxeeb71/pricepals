import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/image_service.dart';
import 'price_comparison_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductHeader(),
                  const SizedBox(height: 16),
                  _buildPriceSection(),
                  const SizedBox(height: 16),
                  _buildRatingSection(),
                  const SizedBox(height: 16),
                  _buildActionButtons(),
                  const SizedBox(height: 16),
                  _buildTabBar(),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildDescriptionTab(),
                        _buildSpecificationsTab(),
                        _buildReviewsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              itemCount: 1, // For now, just one image
              itemBuilder: (context, index) {
                return ImageService.buildProductImage(
                  imageUrl: widget.product.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.retailer,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        Text(
          '\$${widget.product.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        if (widget.product.hasDiscount) ...[
          const SizedBox(width: 12),
          Text(
            '\$${widget.product.originalPrice!.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '-${widget.product.discountPercentage!.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            if (index < widget.product.rating.floor()) {
              return Icon(Icons.star, color: Colors.amber[600], size: 20);
            } else if (index == widget.product.rating.floor() &&
                widget.product.rating % 1 > 0) {
              return Icon(Icons.star_half, color: Colors.amber[600], size: 20);
            } else {
              return Icon(
                Icons.star_border,
                color: Colors.amber[600],
                size: 20,
              );
            }
          }),
        ),
        const SizedBox(width: 8),
        Text(
          '${widget.product.rating} (${widget.product.reviewCount} reviews)',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final isInCart = cartProvider.isInCart(widget.product.id);
              return ElevatedButton.icon(
                onPressed: () {
                  if (isInCart) {
                    cartProvider.removeItem(widget.product.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Removed from cart')),
                    );
                  } else {
                    cartProvider.addItem(widget.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart')),
                    );
                  }
                },
                icon: Icon(
                  isInCart
                      ? Icons.remove_shopping_cart
                      : Icons.add_shopping_cart,
                ),
                label: Text(isInCart ? 'Remove from Cart' : 'Add to Cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInCart ? Colors.red : null,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Consumer<WishlistProvider>(
          builder: (context, wishlistProvider, child) {
            final isInWishlist = wishlistProvider.isInWishlist(
              widget.product.id,
            );
            return IconButton(
              onPressed: () {
                if (isInWishlist) {
                  wishlistProvider.removeItem(widget.product.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Removed from wishlist')),
                  );
                } else {
                  wishlistProvider.addItem(widget.product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to wishlist')),
                  );
                }
              },
              icon: Icon(
                isInWishlist ? Icons.favorite : Icons.favorite_border,
                color: isInWishlist ? Colors.red : null,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[200],
                padding: const EdgeInsets.all(16),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        tabs: [
          Tab(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text('Description'),
            ),
          ),
          Tab(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text('Specifications'),
            ),
          ),
          Tab(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text('Reviews'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.product.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Key Features',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.product.tags
              .map(
                (tag) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tag
                            .split('-')
                            .map(
                              (word) =>
                                  word[0].toUpperCase() + word.substring(1),
                            )
                            .join(' '),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PriceComparisonScreen(
                    productName: widget.product.name,
                    productImage: widget.product.image,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.compare_arrows),
            label: const Text('Compare Prices Across Retailers'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Specifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                _buildSpecItemWithIcon(
                  Icons.category,
                  'Category',
                  widget.product.category,
                ),
                const Divider(height: 1),
                _buildSpecItemWithIcon(
                  Icons.store,
                  'Retailer',
                  widget.product.retailer,
                ),
                const Divider(height: 1),
                _buildSpecItemWithIcon(
                  Icons.local_offer,
                  'Original Price',
                  widget.product.originalPrice != null
                      ? '\$${widget.product.originalPrice!.toStringAsFixed(2)}'
                      : 'N/A',
                ),
                const Divider(height: 1),
                _buildSpecItemWithIcon(
                  Icons.discount,
                  'Discount',
                  widget.product.discountPercentage != null
                      ? '${widget.product.discountPercentage!.toStringAsFixed(1)}%'
                      : 'No discount',
                ),
                const Divider(height: 1),
                _buildSpecItemWithIcon(
                  widget.product.inStock
                      ? Icons.check_circle
                      : Icons.remove_circle,
                  'Stock Status',
                  widget.product.inStock ? 'In Stock' : 'Out of Stock',
                  iconColor: widget.product.inStock ? Colors.green : Colors.red,
                ),
                const Divider(height: 1),
                _buildSpecItemWithIcon(
                  Icons.update,
                  'Last Updated',
                  '${widget.product.lastUpdated.day}/${widget.product.lastUpdated.month}/${widget.product.lastUpdated.year}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Product Tags',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.product.tags
                .map(
                  (tag) => Chip(
                    label: Text(
                      tag
                          .split('-')
                          .map(
                            (word) => word[0].toUpperCase() + word.substring(1),
                          )
                          .join(' '),
                    ),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItemWithIcon(
    IconData icon,
    String label,
    String value, {
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: iconColor ?? Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.product.reviewCount} reviews',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        widget.product.rating.toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.product.rating.floor()
                                ? Icons.star
                                : index < widget.product.rating
                                ? Icons.star_half
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Based on ${widget.product.reviewCount} reviews',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        _buildRatingBar(5, 0.6),
                        _buildRatingBar(4, 0.25),
                        _buildRatingBar(3, 0.1),
                        _buildRatingBar(2, 0.03),
                        _buildRatingBar(1, 0.02),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement review writing functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Review feature coming soon!')),
                );
              },
              icon: const Icon(Icons.rate_review),
              label: const Text('Write a Review'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int rating, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$rating',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 12, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
