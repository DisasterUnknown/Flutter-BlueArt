import 'package:blue_art_mad2/models/products.dart';
import 'package:collection/collection.dart';

class ProductStore {
  static final ProductStore _instance = ProductStore._internal();
  factory ProductStore() => _instance;
  ProductStore._internal();

  List<Product> _artProducts = [];
  List<Product> _collectiblesProducts = [];

  List<Product> get artProducts => _artProducts;
  List<Product> get collectiblesProducts => _collectiblesProducts;

  void setArtProducts(List<Product> products) {
    _artProducts = products;
  }

  void setCollectiblesProducts(List<Product> products) {
    _collectiblesProducts = products;
  }

  Product? getProductById(int id) {
    return [
      ..._artProducts,
      ..._collectiblesProducts,
    ].firstWhereOrNull((p) => p.id == id);
  }
}
