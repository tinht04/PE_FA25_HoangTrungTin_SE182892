import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repository/item_repository.dart';
import '../models/item_model.dart';
import '../main.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesVM, List<ItemModel>>((ref) {
  final repo = ref.watch(itemRepoProvider);
  return FavoritesVM(repo);
});

class FavoritesVM extends StateNotifier<List<ItemModel>> {
  final ItemRepository repo;
  FavoritesVM(this.repo) : super([]) {
    load();
  }

  Future<void> load() async {
    final r = await repo.getFavorites();
    state = r;
  }

  Future<void> refresh() async => load();
}
