import 'package:flutter/material.dart';
import 'book_details_page.dart';
import 'app_colors.dart' as AppColors;

class SearchResultsPage extends StatelessWidget {
  final List<dynamic> books;

  const SearchResultsPage({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.menu1Color,
        title: const Text('Search Results'),
      ),
      body: books.isEmpty
          ? const Center(child: Text('No books found'))
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                final volumeInfo = book['volumeInfo'] ?? {};
                final imageLinks = volumeInfo['imageLinks'] ?? {};

                return GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman rincian buku
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsPage(book: book),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: imageLinks.isNotEmpty
                        ? Image.network(
                            imageLinks['thumbnail'] ?? '',
                            width: 50,
                            height: 50,
                          )
                        : const Icon(Icons.book),
                    title: Text(volumeInfo['title'] ?? 'No title'),
                    subtitle: Text(volumeInfo['authors']?.join(', ') ?? 'Unknown author'),
                  ),
                );
              },
            ),
    );
  }
}
