class SoldProduct {
  final String name;
  final String category;
  final String series;
  final int sold;
  final int revenue;

  SoldProduct({
    required this.name,
    required this.category,
    required this.series,
    required this.sold,
    required this.revenue,
  });

  factory SoldProduct.fromJson(Map<String, dynamic> json) {
    return SoldProduct(
      name: json['product_name'] ?? '',
      category: json['category'] ?? '',
      series: json['series'] ?? '',
      sold: int.parse(json['total_sold'].toString()),
      revenue: int.parse(json['total_revenue'].toString()),
    );
  }
}
