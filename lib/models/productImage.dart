// ignore_for_file: file_names

class ProductImage {
  final int id;
  final int productId;
  final String content;

  ProductImage({
    required this.id,
    required this.productId,
    required this.content,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      productId: json['product_id'],
      content: json['content'],
    );
  }
}