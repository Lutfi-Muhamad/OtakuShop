class Product {
  final int id;
  final String name;
  final String description;
  final int? price; //null untuk wide dan promo
  final int stock;
  final String image;
  final String imageType;
  final String aspectRatio;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
    required this.imageType,
    required this.aspectRatio,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      image: json['image'],
      imageType: json['image_type'],
      aspectRatio: json['aspect_ratio'],
    );
  }
}
