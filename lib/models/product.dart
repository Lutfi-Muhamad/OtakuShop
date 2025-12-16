class Product {
  final int id;
  final String name;
  final String description;
  final String category;
  final int? price;
  final int stock;
  final List<String> images;
  final String imageType;
  final String aspectRatio;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.stock,
    required this.images,
    required this.imageType,
    required this.aspectRatio,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      category: json['category'],
      stock: json['stock'],
      images: List<String>.from(json['images']),
      imageType: json['image_type'],
      aspectRatio: json['aspect_ratio'],
    );
  }
}
