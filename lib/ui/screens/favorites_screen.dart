import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/favorites_viewmodel.dart';
import '../widgets/item_tile.dart';
import 'detail_screen.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final favs = ref.watch(favoritesProvider);

    // Get unique categories from favorites
    final categories = favs.map((e) => e.category).toSet().toList();

    // Filter favorites based on search and category
    final filtered = favs.where((item) {
      final matchSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCat = _selectedCategory == null ||
          _selectedCategory == '' ||
          item.category == _selectedCategory;
      return matchSearch && matchCat;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Favorites',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 28),
            onPressed: () {
              ref.read(favoritesProvider.notifier).refresh();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.red.shade400,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search, color: Colors.red.shade400),
                hintText: 'Search in favorites...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (q) {
                setState(() {
                  _searchQuery = q;
                });
              },
            ),
          ),

          // Category Filters
          if (categories.isNotEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: const Text('All'),
                        selected: _selectedCategory == null,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = null;
                          });
                        },
                        selectedColor: Colors.red.shade400,
                        labelStyle: TextStyle(
                          color: _selectedCategory == null
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ...categories.map((c) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(c),
                            selected: _selectedCategory == c,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = c;
                              });
                            },
                            selectedColor: Colors.red.shade400,
                            labelStyle: TextStyle(
                              color: _selectedCategory == c
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),

          // Favorites Count
          if (filtered.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Text(
                '${filtered.length} favorite ${filtered.length == 1 ? 'item' : 'items'}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),

          // Favorites List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border,
                            size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          favs.isEmpty
                              ? 'No favorites yet'
                              : 'No matching favorites',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          favs.isEmpty
                              ? 'Start adding products to your favorites!'
                              : 'Try adjusting your filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => ItemTile(
                        item: filtered[i],
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      DetailScreen(itemId: filtered[i].id)));
                          ref.read(favoritesProvider.notifier).refresh();
                        }),
                  ),
          ),
        ],
      ),
    );
  }
}
