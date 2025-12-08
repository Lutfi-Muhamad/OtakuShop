// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   // Base URL di service ini
//   static const String _baseUrl =
//       'https://hubbly-salma-unmaterialistically.ngrok-free.dev/';

//   // Contoh method untuk get products
//   Future<List<dynamic>> getProducts() async {
//     final Uri url = Uri.parse('${_baseUrl}api/products');

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception('Failed to load products: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching products: $e');
//     }
//   }
// }
