import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'ui/screens/list_screen.dart';
import 'data/remote/api_service.dart';
import 'data/local/app_db.dart';
import 'data/repository/item_repository.dart';
import 'utils/network_info.dart';

// Global providers
final apiServiceProvider = Provider((ref) => ApiService());
final appDbProvider = Provider((ref) => AppDatabase());
final itemRepoProvider = Provider((ref) => ItemRepository(
    api: ref.read(apiServiceProvider), database: ref.read(appDbProvider)));
final networkInfoProvider = Provider((ref) => NetworkInfo(Connectivity()));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  final db = AppDatabase();
  await db.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hoang Trung Tin - SE182892',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
