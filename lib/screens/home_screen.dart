import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/books_data.dart';
import '../services/storage_service.dart';
import '../widgets/book_card.dart';
import '../widgets/bottom_nav.dart';
import '../models/book.dart';
import '../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';

  List<Book> get filteredBooks => books.where((b) {
    final matchesCat = selectedCategory == 'All' || b.category == selectedCategory;
    final matchesSearch = b.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        b.author.toLowerCase().contains(searchQuery.toLowerCase());
    return matchesCat && matchesSearch;
  }).toList();

  @override
  Widget build(BuildContext context) {
    final featuredBooks = books.take(3).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, Color(0xFF2A3A54)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'HistoriX',
                              style: TextStyle(color: AppTheme.accent, fontSize: 28, fontFamily: 'Playfair Display'),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await StorageService.clearAuth();
                                if (context.mounted) context.go('/login');
                              },
                              child: const Icon(Icons.account_circle, color: Colors.white, size: 30),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search books, authors...',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                            prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.6)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (v) => setState(() => searchQuery = v),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Featured Books
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Featured Books', style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 350,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: featuredBooks.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) => SizedBox(
                  width: 180,
                  child: BookCard(book: featuredBooks[i]),
                ),
              ),
            ),
          ),
          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Categories', style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = categories[i];
                  final isSelected = cat == selectedCategory;
                  return FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => selectedCategory = cat),
                    selectedColor: AppTheme.accent,
                    checkmarkColor: Colors.white,
                    backgroundColor: AppTheme.muted,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                  );
                },
              ),
            ),
          ),
          // All Books
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('All Books', style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                    (_, i) => BookCard(book: filteredBooks[i]),
                childCount: filteredBooks.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}