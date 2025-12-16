class SoldProduct {
  final String name;
  final String category;
  final int sold;

  SoldProduct({required this.name, required this.category, required this.sold});

  factory SoldProduct.fromJson(Map<String, dynamic> json) {
    return SoldProduct(
      name: json['product_name'],
      category: json['series'],
      sold: json['total_sold'],
    );
  }
}
