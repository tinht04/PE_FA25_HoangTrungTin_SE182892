import 'package:hive_flutter/hive_flutter.dart';

class Item {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final bool isFavorite;

  Item({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.isFavorite,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'isFavorite': isFavorite,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      category: map['category'] as String,
      image: map['image'] as String,
      isFavorite: map['isFavorite'] as bool,
    );
  }
}

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  Box<Map>? _itemsBox;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<void> init() async {
    await Hive.initFlutter();
    _itemsBox = await Hive.openBox<Map>('items');
  }

  Box<Map> get _box {
    if (_itemsBox == null || !_itemsBox!.isOpen) {
      throw Exception('Database not initialized. Call init() first.');
    }
    return _itemsBox!;
  }

  Future<void> insertOrReplaceItems(List<Item> items) async {
    final box = _box;
    final Map<dynamic, Map> itemsMap = {};

    for (var item in items) {
      itemsMap[item.id] = item.toMap();
    }

    await box.putAll(itemsMap);
  }

  Future<List<Item>> getAllItems() async {
    final box = _box;
    return box.values
        .map((map) => Item.fromMap(Map<String, dynamic>.from(map)))
        .toList();
  }

  Future<Item?> getItemById(int id) async {
    final box = _box;
    final map = box.get(id);
    if (map == null) return null;
    return Item.fromMap(Map<String, dynamic>.from(map));
  }

  Future<List<Item>> getFavorites() async {
    final box = _box;
    return box.values
        .where((map) => map['isFavorite'] == true)
        .map((map) => Item.fromMap(Map<String, dynamic>.from(map)))
        .toList();
  }

  Future<void> updateFavorite(int id, bool isFavorite) async {
    final box = _box;
    final map = box.get(id);
    if (map != null) {
      map['isFavorite'] = isFavorite;
      await box.put(id, map);
    }
  }

  Future<void> close() async {
    await _itemsBox?.close();
  }
}
