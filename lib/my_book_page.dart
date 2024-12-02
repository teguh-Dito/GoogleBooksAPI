import 'package:flutter/material.dart';
import 'book_details_page.dart'; // Import halaman BookDetailsPage

class MyBookPage extends StatefulWidget {
  final List<dynamic> bookmarkedBooks;

  const MyBookPage({super.key, required this.bookmarkedBooks});

  @override
  _MyBookPageState createState() => _MyBookPageState();
}

class _MyBookPageState extends State<MyBookPage> {
  late List<dynamic> _bookmarkedBooks;

  @override
  void initState() {
    super.initState();
    _bookmarkedBooks = List.from(widget.bookmarkedBooks);
  }

  void _removeBookmark(int index) {
    setState(() {
      _bookmarkedBooks.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book removed from bookmarks')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Books'),
      ),
      body: _bookmarkedBooks.isEmpty
          ? const Center(child: Text('No bookmarked books'))
          : ListView.builder(
              itemCount: _bookmarkedBooks.length,
              itemBuilder: (context, index) {
                final book = _bookmarkedBooks[index];
                final volumeInfo = book['volumeInfo'] ?? {};
                final imageLinks = volumeInfo['imageLinks'] ?? {};

                return ListTile(
                  leading: imageLinks.isNotEmpty
                      ? Image.network(
                          imageLinks['thumbnail'] ?? '',
                          width: 50,
                          height: 50,
                        )
                      : const Icon(Icons.book),
                  title: Text(volumeInfo['title'] ?? 'No title'),
                  subtitle: Text(volumeInfo['authors']?.join(', ') ?? 'Unknown author'),
                  onTap: () {
                    // Navigasi ke halaman BookDetailsPage ketika item ditekan
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsPage(book: book),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeBookmark(index),
                  ),
                );
              },
            ),
    );
  }
}
