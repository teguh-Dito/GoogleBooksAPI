import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'app_colors.dart' as AppColors;
import 'book_details_page.dart';
import 'my_book_page.dart'; // Import halaman My Book
import 'account_page.dart'; // Import halaman Account
import 'search_results_page.dart'; // Import halaman SearchResultsPage
import 'login_page.dart'; // Import halaman Login

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> recommendedBooks = [];
  List<dynamic> favoriteBooks = [];
  List<dynamic> bookmarkedBooks = []; // Tambahkan variabel bookmark
  bool isLoading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchRecommendedBooks();
    fetchFavoriteBooks();
  }

  void fetchRecommendedBooks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final books = await ApiService().fetchBooks("popular");
      setState(() {
        recommendedBooks = books;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchFavoriteBooks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final books = await ApiService().fetchBooks("favorite");
      setState(() {
        favoriteBooks = books;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addBookmark(dynamic book) {
    setState(() {
      if (!bookmarkedBooks.contains(book)) {
        bookmarkedBooks.add(book);
      }
    });
  }

  void searchBooks(String query) async {
    if (query.isEmpty) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      isLoading = true;
      searchQuery = query;
    });

    try {
      final books = await ApiService().fetchBooks(query);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(books: books),
        ),
      );
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi logout
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Menghapus status login
    await prefs.remove('username'); // Menghapus username
    await prefs.remove('password'); // Menghapus password

    // Arahkan ke halaman login setelah logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Widget _buildHorizontalBookList(List<dynamic> books) {
    return SizedBox(
      height: 200,
      child: books.isEmpty
          ? const Center(child: Text('No books available'))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                final volumeInfo = book['volumeInfo'] ?? {};
                final imageLinks = volumeInfo['imageLinks'] ?? {};
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsPage(
                          book: book,
                          onBookmark: addBookmark,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imageLinks.isNotEmpty
                            ? Image.network(
                                imageLinks['thumbnail'] ?? '',
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 100),
                              )
                            : const Icon(Icons.book, size: 100),
                        const SizedBox(height: 8),
                        Text(
                          volumeInfo['title'] ?? 'No title',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildVerticalBookList(List<dynamic> books) {
    return books.isEmpty
        ? const Center(child: Text('No books available'))
        : ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final volumeInfo = book['volumeInfo'] ?? {};
              final imageLinks = volumeInfo['imageLinks'] ?? {};
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailsPage(
                        book: book,
                        onBookmark: addBookmark,
                      ),
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
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.menu1Color,
        title: const Text('Book Search'),
        actions: [
          // Tombol logout di AppBar
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onSubmitted: (query) {
                    searchBooks(query);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search for books...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Recommended Books',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildHorizontalBookList(recommendedBooks),
                const SizedBox(height: 16),
                const Text(
                  'Want To Read',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(child: _buildVerticalBookList(favoriteBooks)),
              ],
            ),
          ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.book),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyBookPage(bookmarkedBooks: bookmarkedBooks)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
