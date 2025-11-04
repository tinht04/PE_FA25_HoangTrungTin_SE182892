import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/list_viewmodel.dart';
import '../widgets/item_tile.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(listViewModelProvider.notifier).loadInitial());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(listViewModelProvider);
    final vm = ref.read(listViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Products',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, size: 28),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen())),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                hintText: 'Search products...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: vm.search,
            ),
          ),

          // Category Filters
          if (state.categories.isNotEmpty)
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
                        selected: state.selectedCategory == null,
                        onSelected: (_) => vm.selectCategory(null),
                        selectedColor: Colors.blue,
                        labelStyle: TextStyle(
                          color: state.selectedCategory == null
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ...state.categories.map((c) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(c),
                            selected: state.selectedCategory == c,
                            onSelected: (_) => vm.selectCategory(c),
                            selectedColor: Colors.blue,
                            labelStyle: TextStyle(
                              color: state.selectedCategory == c
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

          // Products List
          Expanded(child: Builder(builder: (_) {
            if (state.loading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 3),
                    SizedBox(height: 16),
                    Text('Loading products...',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(state.error!, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              );
            }

            final list = vm.filtered;
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text('No products found',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final it = list[i];
                return ItemTile(
                    item: it,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailScreen(itemId: it.id))));
              },
            );
          }))
        ],
      ),
    );
  }
}
