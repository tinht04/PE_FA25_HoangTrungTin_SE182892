import '../../models/item_model.dart';
import '../remote/api_service.dart';
import '../local/app_db.dart' as db;

class ItemRepository {
  final ApiService api;
  final db.AppDatabase database;

  ItemRepository({required this.api, required this.database});

  Future<List<ItemModel>> fetchAndCache() async {
    final remote = await api.fetchProducts();

    // Get existing items to preserve favorite status
    final existing = await database.getAllItems();
    final existingMap = {for (var item in existing) item.id: item.isFavorite};

    // Convert ItemModel to db.Item, preserving isFavorite if exists
    final items = remote
        .map((m) => db.Item(
              id: m.id,
              title: m.title,
              price: m.price,
              description: m.description,
              category: m.category,
              image: m.image,
              isFavorite: existingMap[m.id] ??
                  false, // Preserve existing favorite status
            ))
        .toList();

    await database.insertOrReplaceItems(items);

    // Return with favorite status
    return remote
        .map((m) => ItemModel(
              id: m.id,
              title: m.title,
              price: m.price,
              description: m.description,
              category: m.category,
              image: m.image,
              isFavorite: existingMap[m.id] ?? false,
            ))
        .toList();
  }

  Future<List<ItemModel>> loadFromDb() async {
    final items = await database.getAllItems();
    return items
        .map((e) => ItemModel(
              id: e.id,
              title: e.title,
              price: e.price,
              description: e.description,
              category: e.category,
              image: e.image,
              isFavorite: e.isFavorite,
            ))
        .toList();
  }

  Future<void> toggleFavorite(int id) async {
    final item = await database.getItemById(id);
    if (item != null) {
      await database.updateFavorite(id, !item.isFavorite);
    }
  }

  Future<List<ItemModel>> getFavorites() async {
    final items = await database.getFavorites();
    return items
        .map((e) => ItemModel(
              id: e.id,
              title: e.title,
              price: e.price,
              description: e.description,
              category: e.category,
              image: e.image,
              isFavorite: e.isFavorite,
            ))
        .toList();
  }
}
