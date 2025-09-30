// ignore_for_file: file_names

import 'package:blue_art_mad2/models/products.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductDBHelper {
  static Database? _db;

  static Future<Database> initDB() async {
    if (_db != null) return _db!;

    String path = join(await getDatabasesPath(), 'products.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE art_products(
            id INTEGER PRIMARY KEY,
            user_id INTEGER,
            name TEXT,
            price TEXT,
            discount TEXT,
            description TEXT,
            category TEXT,
            status TEXT,
            main_image TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE collectibles_products(
            id INTEGER PRIMARY KEY,
            user_id INTEGER,
            name TEXT,
            price TEXT,
            discount TEXT,
            description TEXT,
            category TEXT,
            status TEXT,
            main_image TEXT
          )
        ''');
      },
    );

    return _db!;
  }

  // Insert multiple products into a table
  static Future<void> insertProducts(List<Map<String, dynamic>> products, String tableName) async {
    final db = await initDB();
    Batch batch = db.batch();

    for (var product in products) {
      String mainImage = '';
      if (product['images'] != null) {
        for (var img in product['images']) {
          if (img['level'] == 'main') {
            mainImage = img['content'] ?? '';
            break;
          }
        }
      }

      batch.insert(
        tableName,
        {
          'id': product['id'],
          'user_id': product['user_id'],
          'name': product['name'],
          'price': product['price'],
          'discount': product['discount'],
          'description': product['description'],
          'category': product['category'],
          'status': product['status'],
          'main_image': mainImage,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  // Get all products from a table
  static Future<List<Product>> getProducts(String tableName) async {
    final db = await initDB();
    final maps = await db.query(tableName);
    return maps.map((map) => Product.fromDbMap(map)).toList(); 
  }

  // Update all products
  static Future<void> updateAllProducts(List<Product> products, String tableName) async {
    final db = await initDB();
    Batch batch = db.batch();

    batch.delete(tableName); // clear table

    for (var product in products) {
      batch.insert(
        tableName,
        product.toDbMap(), 
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
