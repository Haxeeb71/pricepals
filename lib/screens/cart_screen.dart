import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/image_service.dart';
import '../utils/screen_utils.dart';
import 'product_detail_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: ScreenUtils.getResponsiveTextStyle(
            context,
            baseSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: ScreenUtils.getAppBarHeight(context),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return Center(
              child: ScreenUtils.responsiveContainer(
                context,
                padding: EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 4)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: ScreenUtils.getIconSize(context, baseSize: 80),
                      color: Colors.grey,
                    ),
                    SizedBox(height: ScreenUtils.spacing(context, multiplier: 2)),
                    Text(
                      'Your cart is empty',
                      style: ScreenUtils.getResponsiveTextStyle(
                        context,
                        baseSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: ScreenUtils.spacing(context, multiplier: 1)),
                    Text(
                      'Add some products to get started',
                      style: ScreenUtils.getResponsiveTextStyle(
                        context,
                        baseSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 2)),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.items[index];
                    return _buildCartItem(context, cartItem, cartProvider);
                  },
                ),
              ),
              _buildCartSummary(context, cartProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem cartItem, CartProvider cartProvider) {
    return ScreenUtils.responsiveCard(
      context,
      margin: EdgeInsets.only(bottom: ScreenUtils.spacing(context, multiplier: 1.5)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    product: cartItem.product,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ScreenUtils.spacing(context, multiplier: 1)),
              child: ImageService.buildListTileImage(
                imageUrl: cartItem.product.image,
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
                    builder: (context) => ProductDetailScreen(
                      product: cartItem.product,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: ScreenUtils.getResponsiveTextStyle(
                      context,
                      baseSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ScreenUtils.spacing(context, multiplier: 0.5)),
                  Text(
                    cartItem.product.retailer,
                    style: ScreenUtils.getResponsiveTextStyle(
                      context,
                      baseSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: ScreenUtils.spacing(context, multiplier: 1)),
                  Text(
                    '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                    style: ScreenUtils.getResponsiveTextStyle(
                      context,
                      baseSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      cartProvider.updateQuantity(
                        cartItem.product.id,
                        cartItem.quantity - 1,
                      );
                    },
                    icon: Icon(
                      Icons.remove_circle_outline,
                      size: ScreenUtils.getIconSize(context, baseSize: 20),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtils.spacing(context, multiplier: 1.5),
                      vertical: ScreenUtils.spacing(context, multiplier: 0.5),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(ScreenUtils.spacing(context, multiplier: 0.5)),
                    ),
                    child: Text(
                      '${cartItem.quantity}',
                      style: ScreenUtils.getResponsiveTextStyle(
                        context,
                        baseSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      cartProvider.updateQuantity(
                        cartItem.product.id,
                        cartItem.quantity + 1,
                      );
                    },
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: ScreenUtils.getIconSize(context, baseSize: 20),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtils.spacing(context, multiplier: 1)),
              IconButton(
                onPressed: () {
                  cartProvider.removeItem(cartItem.product.id);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
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

  Widget _buildCartSummary(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 2)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: ScreenUtils.getResponsiveTextStyle(
                  context,
                  baseSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                style: ScreenUtils.getResponsiveTextStyle(
                  context,
                  baseSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenUtils.spacing(context, multiplier: 2)),
          ScreenUtils.responsiveButton(
            context,
            text: 'Proceed to Checkout',
            onPressed: () {
              // TODO: Implement checkout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Checkout functionality coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
