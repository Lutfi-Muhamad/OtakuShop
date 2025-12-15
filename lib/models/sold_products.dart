class SoldProduct {
  final int id;
  final String name;
  final String category;
  final String image;
  final int sold;

  SoldProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.sold,
  });

  factory SoldProduct.fromJson(Map<String, dynamic> json) {
    return SoldProduct(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      image: json['image'],
      sold: json['sold'],
    );
  }
}