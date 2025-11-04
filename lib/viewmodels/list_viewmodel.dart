import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repository/item_repository.dart';
import '../models/item_model.dart';
import '../utils/network_info.dart';
import '../main.dart';

final listViewModelProvider =
    StateNotifierProvider<ListViewModel, ListState>((ref) {
  final repo = ref.watch(itemRepoProvider);
  final net = ref.watch(networkInfoProvider);
  return ListViewModel(repo: repo, netInfo: net);
});

class ListState {
  final bool loading;
  final String? error;
  final List<ItemModel> items;
  final List<String> categories;
  final String search;
  final String? selectedCategory;

  ListState({
    this.loading = false,
    this.error,
    this.items = const [],
    this.categories = const [],
    this.search = '',
    this.selectedCategory,
  });

  ListState copyWith({
    bool? loading,
    String? error,
    List<ItemModel>? items,
    List<String>? categories,
    String? search,
    String? selectedCategory,
  }) =>
      ListState(
        loading: loading ?? this.loading,
        error: error,
        items: items ?? this.items,
        categories: categories ?? this.categories,
        search: search ?? this.search,
        selectedCategory: selectedCategory ?? this.selectedCategory,
      );
}

class ListViewModel extends StateNotifier<ListState> {
  final ItemRepository repo;
  final NetworkInfo netInfo;

  ListViewModel({required this.repo, required this.netInfo})
      : super(ListState());

  Future<void> loadInitial() async {
    state = state.copyWith(loading: true, error: null);
    final connected = await netInfo.isConnected;
    try {
      if (connected) {
        final list = await repo.fetchAndCache();
        final cats = list.map((e) => e.category).toSet().toList();
        state = state.copyWith(loading: false, items: list, categories: cats);
      } else {
        final list = await repo.loadFromDb();
        if (list.isEmpty) {
          state = state.copyWith(
              loading: false,
              error: 'Could not load data. Please check your connection.');
        } else {
          final cats = list.map((e) => e.category).toSet().toList();
          state = state.copyWith(loading: false, items: list, categories: cats);
        }
      }
    } catch (e) {
      final cached = await repo.loadFromDb();
      if (cached.isEmpty) {
        state = state.copyWith(
            loading: false,
            error: 'Could not load data. Please check your connection.');
      } else {
        final cats = cached.map((e) => e.category).toSet().toList();
        state = state.copyWith(loading: false, items: cached, categories: cats);
      }
    }
  }

  void search(String q) {
    state = state.copyWith(search: q);
  }

  void selectCategory(String? cat) {
    state = state.copyWith(selectedCategory: cat);
  }

  List<ItemModel> get filtered {
    final q = state.search.toLowerCase();
    return state.items.where((it) {
      final matchSearch = q.isEmpty || it.title.toLowerCase().contains(q);
      final matchCat = state.selectedCategory == null ||
          state.selectedCategory == '' ||
          it.category == state.selectedCategory;
      return matchSearch && matchCat;
    }).toList();
  }
}
