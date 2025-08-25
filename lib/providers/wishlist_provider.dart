import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistItem {
  final Product product;
  final DateTime addedAt;

  WishlistItem({required this.product, required this.addedAt});
}

class WishlistProvider extends ChangeNotifier {
  final List<WishlistItem> _items = [];

  List<WishlistItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  void addItem(Product product) {
    if (!isInWishlist(product.id)) {
      _items.add(WishlistItem(
        product: product,
        addedAt: DateTime.now(),
      ));
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearWishlist() {
    _items.clear();
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _items.any((item) => item.product.id == productId);
  }
}
