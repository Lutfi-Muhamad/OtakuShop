class Product {
  final int id, stock, storeId;
  final String name,
      description,
      category,
      imageType,
      aspectRatio,
      storeName,
      storeAddress,
      series; // 🔥 Tambah field series
  final int? price;
  final List<String> images;

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
    this.storeId = 0,
    this.storeName = '',
    this.storeAddress = '',
    this.series = '', // Default empty
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? 'No Name',
      description: json['description']?.toString() ?? '',
      // Handle price jika string atau int
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price']?.toString() ?? '0'),
      category: json['category']?.toString() ?? 'General',
      // Handle stock jika string atau int
      stock: json['stock'] is int
          ? json['stock']
          : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      storeId: json['toko_id'] ?? json['store_id'] ?? 0,

      // Ambil info toko jika ada (nested object 'store' atau flat field)
      // 🔥 FIX: Cek apakah json['store'] adalah Map agar tidak crash jika backend kirim []
      storeName:
          (json['store'] is Map ? json['store']['name']?.toString() : null) ??
          json['store_name']?.toString() ??
          ((json['toko_id'] ?? json['store_id']) == null
              ? 'OtakuShop Official'
              : 'Unknown Store'),
      storeAddress:
          (json['store'] is Map
              ? json['store']['address']?.toString()
              : null) ??
          json['store_address']?.toString() ??
          '',

      // 🔥 Ambil series dari folder
      series: json['folder']?.toString() ?? 'general',

      // Cek null sebelum parsing List
      // 🔥 FIX: Pastikan elemen list dikonversi ke String dan filter null
      images: json['images'] != null
          ? (json['images'] as List).map((e) => e?.toString() ?? '').toList()
          : [],

      imageType: json['image_type']?.toString() ?? 'square',
      aspectRatio: json['aspect_ratio']?.toString() ?? '1:1',
    );
  }

  // Helper: Mengubah String "16:9" menjadi double 1.77 untuk dipakai di UI
  double get ratioDouble {
    if (aspectRatio.contains(':')) {
      final parts = aspectRatio.split(':');
      if (parts.length == 2) {
        try {
          return double.parse(parts[0]) / double.parse(parts[1]);
        } catch (_) {}
      }
    }
    return 1.0;
  }
}
