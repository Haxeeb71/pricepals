import 'package:flutter/material.dart';
import '../services/image_service.dart';
import '../utils/screen_utils.dart';

class RetailerPrice {
  final String retailer;
  final double price;
  final double? shipping;
  final double? tax;
  final bool inStock;
  final String? notes;
  final DateTime lastUpdated;

  RetailerPrice({
    required this.retailer,
    required this.price,
    this.shipping,
    this.tax,
    required this.inStock,
    this.notes,
    required this.lastUpdated,
  });

  double get totalPrice => price + (shipping ?? 0) + (tax ?? 0);
}

class PriceComparisonScreen extends StatefulWidget {
  final String productName;
  final String productImage;

  const PriceComparisonScreen({
    super.key,
    required this.productName,
    required this.productImage,
  });

  @override
  State<PriceComparisonScreen> createState() => _PriceComparisonScreenState();
}

class _PriceComparisonScreenState extends State<PriceComparisonScreen> {
  List<RetailerPrice> _retailerPrices = [];
  bool _isLoading = true;
  String _sortBy = 'price';
  String _filterBy = 'all';

  @override
  void initState() {
    super.initState();
    _loadPriceComparison();
  }

  void _loadPriceComparison() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _retailerPrices = [
        RetailerPrice(
          retailer: 'Amazon',
          price: 999.99,
          shipping: 0.0,
          tax: 89.99,
          inStock: true,
          notes: 'Free Prime shipping',
          lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        RetailerPrice(
          retailer: 'Best Buy',
          price: 999.99,
          shipping: 0.0,
          tax: 89.99,
          inStock: true,
          notes: 'Free shipping',
          lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        RetailerPrice(
          retailer: 'Walmart',
          price: 949.99,
          shipping: 5.99,
          tax: 85.49,
          inStock: true,
          notes: 'Rollback price',
          lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        RetailerPrice(
          retailer: 'Target',
          price: 1049.99,
          shipping: 0.0,
          tax: 94.49,
          inStock: false,
          notes: 'Out of stock',
          lastUpdated: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        RetailerPrice(
          retailer: 'Newegg',
          price: 979.99,
          shipping: 9.99,
          tax: 88.49,
          inStock: true,
          notes: 'Limited time deal',
          lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        RetailerPrice(
          retailer: 'B&H Photo',
          price: 989.99,
          shipping: 0.0,
          tax: 89.09,
          inStock: true,
          notes: 'No tax outside NY',
          lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ];
      _isLoading = false;
    });

    _sortPrices();
  }

  void _sortPrices() {
    switch (_sortBy) {
      case 'price':
        _retailerPrices.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
        break;
      case 'retailer':
        _retailerPrices.sort((a, b) => a.retailer.compareTo(b.retailer));
        break;
      case 'availability':
        _retailerPrices.sort(
            (a, b) => b.inStock.toString().compareTo(a.inStock.toString()));
        break;
    }
    setState(() {});
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort By'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Price (Low to High)'),
              leading: Icon(
                _sortBy == 'price'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: _sortBy == 'price'
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _sortBy = 'price';
                });
                Navigator.pop(context);
                _sortPrices();
              },
            ),
            ListTile(
              title: const Text('Retailer Name'),
              leading: Icon(
                _sortBy == 'retailer'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: _sortBy == 'retailer'
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _sortBy = 'retailer';
                });
                Navigator.pop(context);
                _sortPrices();
              },
            ),
            ListTile(
              title: const Text('Availability'),
              leading: Icon(
                _sortBy == 'availability'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: _sortBy == 'availability'
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _sortBy = 'availability';
                });
                Navigator.pop(context);
                _sortPrices();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter By'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Retailers'),
              leading: Icon(
                _filterBy == 'all' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: _filterBy == 'all' ? Theme.of(context).colorScheme.primary : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _filterBy = 'all';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('In Stock Only'),
              leading: Icon(
                _filterBy == 'inStock' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: _filterBy == 'inStock' ? Theme.of(context).colorScheme.primary : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _filterBy = 'inStock';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Free Shipping'),
              leading: Icon(
                _filterBy == 'freeShipping' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: _filterBy == 'freeShipping' ? Theme.of(context).colorScheme.primary : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _filterBy = 'freeShipping';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<RetailerPrice> get _filteredPrices {
    switch (_filterBy) {
      case 'inStock':
        return _retailerPrices.where((price) => price.inStock).toList();
      case 'freeShipping':
        return _retailerPrices
            .where((price) => (price.shipping ?? 0) == 0)
            .toList();
      default:
        return _retailerPrices;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Price Comparison',
          style: ScreenUtils.getResponsiveTextStyle(
            context,
            baseSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: ScreenUtils.getAppBarHeight(context),
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: Icon(
              Icons.filter_list,
              size: ScreenUtils.getIconSize(context, baseSize: 24),
            ),
          ),
          IconButton(
            onPressed: _showSortDialog,
            icon: Icon(
              Icons.sort,
              size: ScreenUtils.getIconSize(context, baseSize: 24),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildProductHeader(),
                const Divider(),
                Expanded(
                  child: _filteredPrices.isEmpty
                      ? Center(
                          child: Text(
                            'No retailers found with current filters',
                            style: ScreenUtils.getResponsiveTextStyle(
                              context,
                              baseSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 2)),
                          itemCount: _filteredPrices.length,
                          itemBuilder: (context, index) {
                            final retailerPrice = _filteredPrices[index];
                            final isBestDeal = index == 0 && _sortBy == 'price';
                            return _buildRetailerPriceCard(
                                retailerPrice, isBestDeal);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildProductHeader() {
    return ScreenUtils.responsiveContainer(
      context,
      padding: EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 2)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(ScreenUtils.spacing(context, multiplier: 1)),
            child: ImageService.buildProductImage(
              imageUrl: widget.productImage,
              width: ScreenUtils.getResponsiveSize(context, percent: 0.12),
              height: ScreenUtils.getResponsiveSize(context, percent: 0.12),
            ),
          ),
          SizedBox(width: ScreenUtils.spacing(context, multiplier: 2)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productName,
                  style: ScreenUtils.getResponsiveTextStyle(
                    context,
                    baseSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ScreenUtils.spacing(context, multiplier: 0.5)),
                Text(
                  '${_filteredPrices.length} retailers found',
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

  Widget _buildRetailerPriceCard(RetailerPrice retailerPrice, bool isBestDeal) {
    return ScreenUtils.responsiveCard(
      context,
      margin: EdgeInsets.only(bottom: ScreenUtils.spacing(context, multiplier: 1.5)),
      child: Container(
        decoration: BoxDecoration(
          border: isBestDeal
              ? Border.all(
                  color: Colors.green,
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(ScreenUtils.spacing(context, multiplier: 1.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    retailerPrice.retailer,
                    style: ScreenUtils.getResponsiveTextStyle(
                      context,
                      baseSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isBestDeal)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtils.spacing(context, multiplier: 1),
                      vertical: ScreenUtils.spacing(context, multiplier: 0.5),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(ScreenUtils.spacing(context, multiplier: 1.5)),
                    ),
                    child: Text(
                      'BEST DEAL',
                      style: ScreenUtils.getResponsiveTextStyle(
                        context,
                        baseSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: ScreenUtils.spacing(context, multiplier: 1.5)),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '\$${retailerPrice.price.toStringAsFixed(2)}',
                            style: ScreenUtils.getResponsiveTextStyle(
                              context,
                              baseSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          if (retailerPrice.shipping != null &&
                              retailerPrice.shipping! > 0) ...[
                            SizedBox(width: ScreenUtils.spacing(context, multiplier: 1)),
                            Flexible(
                              child: Text(
                                '+ \$${retailerPrice.shipping!.toStringAsFixed(2)} shipping',
                                style: ScreenUtils.getResponsiveTextStyle(
                                  context,
                                  baseSize: 14,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (retailerPrice.tax != null && retailerPrice.tax! > 0)
                        Text(
                          '+ \$${retailerPrice.tax!.toStringAsFixed(2)} tax',
                          style: ScreenUtils.getResponsiveTextStyle(
                            context,
                            baseSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      SizedBox(height: ScreenUtils.spacing(context, multiplier: 1)),
                      Text(
                        'Total: \$${retailerPrice.totalPrice.toStringAsFixed(2)}',
                        style: ScreenUtils.getResponsiveTextStyle(
                          context,
                          baseSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtils.spacing(context, multiplier: 1),
                        vertical: ScreenUtils.spacing(context, multiplier: 0.5),
                      ),
                      decoration: BoxDecoration(
                        color: retailerPrice.inStock ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(ScreenUtils.spacing(context, multiplier: 1.5)),
                      ),
                      child: Text(
                        retailerPrice.inStock ? 'In Stock' : 'Out of Stock',
                        style: ScreenUtils.getResponsiveTextStyle(
                          context,
                          baseSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtils.spacing(context, multiplier: 1)),
                    Text(
                      'Updated ${_getTimeAgo(retailerPrice.lastUpdated)}',
                      style: ScreenUtils.getResponsiveTextStyle(
                        context,
                        baseSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (retailerPrice.notes != null) ...[
              SizedBox(height: ScreenUtils.spacing(context, multiplier: 1.5)),
              Container(
                padding: EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 1)),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(ScreenUtils.spacing(context, multiplier: 1)),
                ),
                child: Text(
                  retailerPrice.notes!,
                  style: ScreenUtils.getResponsiveTextStyle(
                    context,
                    baseSize: 14,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
