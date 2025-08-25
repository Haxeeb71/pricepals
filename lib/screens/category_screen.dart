import 'package:flutter/material.dart';
import '../services/image_service.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Electronics',
        'image': 'https://images.unsplash.com/photo-1498049794561-7780c7234c5b?w=400&h=300&fit=crop',
        'icon': Icons.devices,
        'color': Colors.blue,
      },
      {
        'name': 'Fashion',
        'image': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=300&fit=crop',
        'icon': Icons.checkroom,
        'color': Colors.pink,
      },
      {
        'name': 'Home & Kitchen',
        'image': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'icon': Icons.home,
        'color': Colors.green,
      },
      {
        'name': 'Sports & Outdoors',
        'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
        'icon': Icons.sports_soccer,
        'color': Colors.orange,
      },
      {
        'name': 'Books & Media',
        'image': 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
        'icon': Icons.book,
        'color': Colors.purple,
      },
      {
        'name': 'Beauty & Health',
        'image': 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=400&h=300&fit=crop',
        'icon': Icons.face,
        'color': Colors.red,
      },
      {
        'name': 'Toys & Games',
        'image': 'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=400&h=300&fit=crop',
        'icon': Icons.toys,
        'color': Colors.yellow,
      },
      {
        'name': 'Automotive',
        'image': 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=400&h=300&fit=crop',
        'icon': Icons.directions_car,
        'color': Colors.grey,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(
            name: category['name'] as String,
            image: category['image'] as String,
            icon: category['icon'] as IconData,
            color: category['color'] as Color,
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard({
    required String name,
    required String image,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
