import 'package:blue_art_mad2/models/productImage.dart';

class Product {
  final int id;
  final int userId;
  final String name;
  final String price;
  final String discount;
  final String description;
  final String category;
  final String status;
  final List<ProductImage> images;

  Product({
    required this.id,
    required this.userId,
    required this.name,
    required this.price,
    required this.discount,
    required this.description,
    required this.category,
    required this.status,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var imagesJson = json['images'] as List<dynamic>? ?? [];
    return Product(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      price: json['price'],
      discount: json['discount'],
      description: json['description'],
      category: json['category'],
      status: json['status'],
      images: imagesJson.map((img) => ProductImage.fromJson(img)).toList(),
    );
  }
}