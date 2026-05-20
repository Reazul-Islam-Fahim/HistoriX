import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/storage_service.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/cart');
        break;
      case 2:
        context.go('/library');
        break;
      case 3:
        final role = StorageService.userRole;
        if (role == 'admin') {
          context.go('/admin');
        } else {
          _showProfileDialog(context);
        }
        break;
    }
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String?>(
              future: StorageService.getUserEmail(),
              builder: (_, snapshot) {
                final email = snapshot.data ?? 'Unknown';
                return Text('Email: $email');
              },
            ),
            const SizedBox(height: 8),
            Text('Role: ${StorageService.userRole ?? 'guest'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await StorageService.clearAuth();
              if (context.mounted) {
                Navigator.pop(ctx);
                context.go('/login');
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}