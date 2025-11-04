import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/detail_viewmodel.dart';
import '../../viewmodels/favorites_viewmodel.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final int itemId;
  const DetailScreen({Key? key, required this.itemId}) : super(key: key);

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  bool? _isFavorite; // Change to nullable to track if loaded

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(detailViewModelProvider(widget.itemId));

    return FutureBuilder(
      future: vm.getItem(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              appBar: AppBar(title: const Text('Loading...')),
              body: const Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('Product not found')));
        }

        final item = snapshot.data!;

        // Initialize _isFavorite from item data if not set yet
        if (_isFavorite == null) {
          _isFavorite = item.isFavorite;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Product Details',
                style: TextStyle(fontWeight: FontWeight.bold)),
            elevation: 0,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Section
                Container(
                  width: double.infinity,
                  height: 350,
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Image.network(
                      item.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 300,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image,
                            size: 80, color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                // Product Info Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Product Title
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.shade200,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.attach_money,
                              color: Colors.green.shade700,
                              size: 28,
                            ),
                            Text(
                              item.price.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description Section
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Favorite Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await vm.toggleFavorite();
                            ref.invalidate(favoritesProvider);
                            setState(() {
                              _isFavorite = !(_isFavorite ?? false);
                            });
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        (_isFavorite ?? false)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 12),
                                      Text((_isFavorite ?? false)
                                          ? 'Added to favorites ❤️'
                                          : 'Removed from favorites'),
                                    ],
                                  ),
                                  backgroundColor: (_isFavorite ?? false)
                                      ? Colors.red.shade400
                                      : Colors.grey.shade700,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            (_isFavorite ?? false)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 24,
                          ),
                          label: Text(
                            (_isFavorite ?? false)
                                ? 'Remove from Favorites'
                                : 'Add to Favorites',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (_isFavorite ?? false)
                                ? Colors.red.shade400
                                : Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
