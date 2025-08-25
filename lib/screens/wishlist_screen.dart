import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../models/product.dart';
import '../services/image_service.dart';
import '../utils/screen_utils.dart';
import '../utils/responsive_widgets.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveWidgets.responsiveAppBar(
        context,
        title: 'Wishlist',
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
          if (wishlistProvider.items.isEmpty) {
            return Center(
              child: ScreenUtils.responsiveContainer(
                context,
                padding: EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 4)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: ScreenUtils.getIconSize(context, baseSize: 80),
                      color: Colors.grey,
                    ),
                    SizedBox(height: ScreenUtils.spacing(context, multiplier: 2)),
                    ResponsiveWidgets.responsiveText(
                      context,
                      'Your wishlist is empty',
                      baseSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    SizedBox(height: ScreenUtils.spacing(context, multiplier: 1)),
                    ResponsiveWidgets.responsiveText(
                      context,
                      'Add some products to your wishlist',
                      baseSize: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          }

          return ResponsiveWidgets.responsiveListView(
            context,
            children: wishlistProvider.items.map((wishlistItem) {
              return _buildWishlistItem(context, wishlistItem.product, wishlistProvider);
            }).toList(),
            itemSpacing: 1.5,
          );
        },
      ),
    );
  }

  Widget _buildWishlistItem(
    BuildContext context,
    Product product,
    WishlistProvider wishlistProvider,
  ) {
    return ResponsiveWidgets.responsiveCard(
      context,
      margin: EdgeInsets.only(bottom: ScreenUtils.spacing(context, multiplier: 1.5)),
      child: Row(
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
              borderRadius: BorderRadius.circular(ScreenUtils.spacing(context, multiplier: 1)),
              child: ImageService.buildListTileImage(
                imageUrl: product.image,
                width: ScreenUtils.getResponsiveSize(context, percent: 0.15),
                height: ScreenUtils.getResponsiveSize(context, percent: 0.15),
              ),
            ),
          ),
          SizedBox(width: ScreenUtils.spacing(context, multiplier: 2)),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveWidgets.responsiveText(
                    context,
                    product.name,
                    baseSize: 16,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                  ),
                  SizedBox(height: ScreenUtils.spacing(context, multiplier: 0.5)),
                  ResponsiveWidgets.responsiveText(
                    context,
                    product.retailer,
                    baseSize: 14,
                    color: Colors.grey[600],
                  ),
                  SizedBox(height: ScreenUtils.spacing(context, multiplier: 1)),
                  ResponsiveWidgets.responsiveText(
                    context,
                    '\$${product.price.toStringAsFixed(2)}',
                    baseSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  wishlistProvider.removeItem(product.id);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: ScreenUtils.getIconSize(context, baseSize: 20),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(height: ScreenUtils.spacing(context, multiplier: 1)),
              IconButton(
                onPressed: () {
                  // TODO: Add to cart functionality
                  ResponsiveWidgets.showResponsiveSnackBar(
                    context,
                    message: 'Added to cart!',
                  );
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: ScreenUtils.getIconSize(context, baseSize: 20),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
