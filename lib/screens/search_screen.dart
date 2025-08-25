import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../models/product.dart';
import '../services/image_service.dart';
import '../theme/app_theme.dart';
import 'product_detail_screen.dart';
import 'price_comparison_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    } else {
      _performSearch();
    }
  }

  void _performSearch() {
    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final query = _searchController.text.toLowerCase();
        final results = _getMockProducts().where((product) {
          return product.name.toLowerCase().contains(query) ||
                 product.description.toLowerCase().contains(query) ||
                 product.category.toLowerCase().contains(query) ||
                 product.tags.any((tag) => tag.toLowerCase().contains(query));
        }).toList();

        setState(() {
          _searchResults = results;
          _isSearching = false;
        });

        // Add to search history
        final searchProvider = Provider.of<SearchProvider>(context, listen: false);
        searchProvider.addToHistory(_searchController.text, results.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchController.text.isEmpty
                ? _buildSearchHistory()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        final history = searchProvider.searchHistory;
        
        if (history.isEmpty) {
          return const Center(
            child: Text(
              'No search history yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Searches',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      searchProvider.clearHistory();
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(item.query),
                    subtitle: Text('${item.resultCount} results'),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        searchProvider.removeFromHistory(item.query);
                      },
                    ),
                    onTap: () {
                      _searchController.text = item.query;
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No products found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return _buildSearchResultItem(product);
      },
    );
  }

  Widget _buildSearchResultItem(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ImageService.buildListTileImage(
            imageUrl: product.image,
            width: 60,
            height: 60,
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.retailer),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.amber[600],
                ),
                const SizedBox(width: 4),
                Text('${product.rating} (${product.reviewCount})'),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(0, 0),
              ),
              child: const Text('Compare', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
      ),
    );
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: '1',
        name: 'iPhone 15 Pro',
        description: 'Latest iPhone with advanced camera system and A17 Pro chip',
        image: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=300&fit=crop',
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
        image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=300&fit=crop',
        price: 899.99,
        retailer: 'Best Buy',
        category: 'Electronics',
        tags: ['smartphone', 'samsung', 'android'],
        rating: 4.6,
        reviewCount: 890,
        inStock: true,
        lastUpdated: DateTime.now(),
      ),
      // Add more mock products as needed
    ];
  }
}
