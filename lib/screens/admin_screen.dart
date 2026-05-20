import 'package:flutter/material.dart';
import '../data/books_data.dart';
import '../theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/image_with_fallback.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String selectedTab = 'overview';

  final Map<String, dynamic> stats = {
    'totalBooks': books.length,
    'totalSales': 1247,
    'activeUsers': 523,
    'revenue': 45678.90,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: ['overview', 'books', 'users'].map((tab) {
                final isSelected = selectedTab == tab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTab = tab),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.accent : AppTheme.muted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tab[0].toUpperCase() + tab.substring(1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildTabContent(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 'overview':
        return _overviewTab();
      case 'books':
        return _booksTab();
      case 'users':
        return _usersTab();
      default:
        return const SizedBox();
    }
  }

  Widget _overviewTab() {
    return GridView.count(
      key: const ValueKey('overview'),
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _statCard('Total Books', '${stats['totalBooks']}'),
        _statCard('Total Sales', '${stats['totalSales']}'),
        _statCard('Active Users', '${stats['activeUsers']}'),
        _statCard('Revenue', '\$${(stats['revenue'] / 1000).toStringAsFixed(1)}k'),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.accent)),
          ],
        ),
      ),
    );
  }

  Widget _booksTab() {
    return ListView.separated(
      key: const ValueKey('books'),
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final book = books[i];
        return Card(
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: ImageWithFallback(imageUrl: book.coverImage, width: 50, height: 70),
            ),
            title: Text(book.title, maxLines: 1),
            subtitle: Text(book.author),
            trailing: Text('\$${book.price.toStringAsFixed(2)}',
                style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _usersTab() {
    final users = <Map<String, dynamic>>[
      {'name': 'John Doe', 'email': 'john@example.com', 'purchases': 12},
      {'name': 'Jane Smith', 'email': 'jane@example.com', 'purchases': 8},
      {'name': 'Bob Johnson', 'email': 'bob@example.com', 'purchases': 15},
      {'name': 'Alice Williams', 'email': 'alice@example.com', 'purchases': 5},
    ];
    return ListView.separated(
      key: const ValueKey('users'),
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final user = users[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.accent,
              child: Text(user['name'][0], style: const TextStyle(color: Colors.white)),
            ),
            title: Text(user['name']),
            subtitle: Text(user['email']),
            trailing: Text('${user['purchases']} purchases',
                style: TextStyle(color: Colors.grey[600])),
          ),
        );
      },
    );
  }
}