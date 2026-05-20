import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/books_data.dart';
import '../models/book.dart';          // optional if only using Book
import '../providers/cart_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/rating_widget.dart';
import '../widgets/image_with_fallback.dart';
import '../theme.dart';

class BookDetailsScreen extends StatefulWidget {
  final String bookId;
  const BookDetailsScreen({super.key, required this.bookId});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool showCartAnimation = false;

  Book? get book => books.firstWhere((b) => b.id == widget.bookId, orElse: () => null as Book);

  void _addToCart() {
    if (book == null) return;
    Provider.of<CartProvider>(context, listen: false).addToCart(book!);
    setState(() => showCartAnimation = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => showCartAnimation = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final b = book;
    if (b == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Book not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Book Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 200,
                  height: 300,
                  child: ImageWithFallback(imageUrl: b.coverImage, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(b.category, style: const TextStyle(color: AppTheme.accent)),
            ),
            const SizedBox(height: 8),
            Text(b.title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('by ${b.author}', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            RatingWidget(rating: b.rating, showNumber: true),
            const SizedBox(height: 12),
            Text('\$${b.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.accent)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.muted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoColumn('Pages', '${b.pages}'),
                  _infoColumn('Year', '${b.publishYear}'),
                  _infoColumn('ISBN', b.isbn.substring(b.isbn.length - 4)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Description', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(b.description, style: TextStyle(color: Colors.grey[700], height: 1.5)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: CustomButton(label: 'Preview', variant: ButtonVariant.outline, onPressed: () {})),
                const SizedBox(width: 12),
                Expanded(
                  child: Stack(
                    children: [
                      CustomButton(label: 'Add to Cart', variant: ButtonVariant.secondary, onPressed: _addToCart),
                      if (showCartAnimation)
                        Positioned(
                          right: 10,
                          top: 0,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 600),
                            builder: (_, val, child) => Transform.translate(
                              offset: Offset(0, -50 * val),
                              child: Opacity(opacity: 1 - val, child: child),
                            ),
                            child: const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}