import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repository/item_repository.dart';
import '../models/item_model.dart';
import '../main.dart';

final detailViewModelProvider =
    Provider.family<DetailViewModel, int>((ref, id) {
  final repo = ref.watch(itemRepoProvider);
  return DetailViewModel(repo: repo, id: id);
});

class DetailViewModel {
  final ItemRepository repo;
  final int id;

  DetailViewModel({required this.repo, required this.id});

  Future<ItemModel?> getItem() async {
    final list = await repo.loadFromDb();
    try {
      return list.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> toggleFavorite() async {
    await repo.toggleFavorite(id);
  }
}
