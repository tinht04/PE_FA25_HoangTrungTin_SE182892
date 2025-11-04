import 'package:dio/dio.dart';
import '../../models/item_model.dart';

class ApiService {
  final Dio _dio;
  ApiService([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com'));

  Future<List<ItemModel>> fetchProducts() async {
    final res = await _dio.get('/products');
    final data = res.data as List;
    return data.map((e) => ItemModel.fromJson(e)).toList();
  }
}
