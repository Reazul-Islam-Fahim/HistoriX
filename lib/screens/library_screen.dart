import 'package:flutter/material.dart';
import '../data/books_data.dart';
import '../widgets/book_card.dart';
import '../widgets/bottom_nav.dart';
import '../models/book.dart';
import '../theme.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String? _selectedBookId;
  final List<Book> myBooks = books.take(4).toList();

  void _readBook(Book book) {
    setState(() => _selectedBookId = book.id);
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedBookId != null) {
      final book = myBooks.firstWhere((b) => b.id == _selectedBookId);
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _selectedBookId = null),
          ),
          title: Text(book.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Chapter 1: The Beginning\n\nIn the annals of history, few civilizations...\n\n(Digital reader preview)',
                style: TextStyle(height: 1.6, color: Colors.grey[800]),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Library')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Currently Reading', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _readBook(myBooks[0]),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(myBooks[0].coverImage, width: 60, height: 90, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(myBooks[0].title, style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(myBooks[0].author, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text('Progress: 68%', style: TextStyle(color: AppTheme.accent, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(value: 0.68, color: AppTheme.accent, backgroundColor: AppTheme.muted),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('My Books', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: myBooks.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => _readBook(myBooks[i]),
                  child: BookCard(book: myBooks[i]),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}