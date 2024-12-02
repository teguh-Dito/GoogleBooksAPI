import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  final dynamic book;
  final Function(dynamic)? onBookmark;

  const BookDetailsPage({super.key, required this.book, this.onBookmark});

  @override
  Widget build(BuildContext context) {
    final volumeInfo = book['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(volumeInfo['title'] ?? 'Book Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              if (onBookmark != null) {
                onBookmark!(book);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Book bookmarked!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: imageLinks.isNotEmpty
                  ? Image.network(
                      imageLinks['thumbnail'] ?? '',
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.book, size: 100),
            ),
            const SizedBox(height: 16),
            Text(
              volumeInfo['title'] ?? 'No Title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              volumeInfo['authors']?.join(', ') ?? 'Unknown author',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              volumeInfo['description'] ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}