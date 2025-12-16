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
      name: json['product_name'],
      category: json['category'],
      series: json['series'],
      sold: json['total_sold'],
      revenue: json['total_revenue'],
    );
  }
}
