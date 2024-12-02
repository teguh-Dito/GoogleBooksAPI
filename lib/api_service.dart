import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = 'AIzaSyDNBcoht0SEwWi3IAtQzgawagBC6XE4Vco'; // API Google Books

  Future<List<dynamic>> fetchBooks(String query) async {
    final url = Uri.parse(
        // 'https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey'
        'https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey'

        );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'] ?? [];
    } else {
      throw Exception('Failed to fetch books');
    }
  }
}
