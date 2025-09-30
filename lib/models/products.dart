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

  // From API JSON
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

  // From DB Map 
  factory Product.fromDbMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      price: map['price'],
      discount: map['discount'],
      description: map['description'],
      category: map['category'],
      status: map['status'],
      images: [
        ProductImage(
          id: 0,
          productId: map['id'],
          content: map['main_image'] ?? '',
        ),
      ],
    );
  }

  // To DB Map 
  Map<String, dynamic> toDbMap() {
    String mainImage = images.isNotEmpty ? images.first.content : '';
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'price': price,
      'discount': discount,
      'description': description,
      'category': category,
      'status': status,
      'main_image': mainImage,
    };
  }
}
