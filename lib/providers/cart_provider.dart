import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../models/cart_item.dart';
import '../services/storage_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  Future<void> loadCart() async {
    final cartData = await StorageService.getCart();
    _items = cartData.map((e) {
      return CartItem(
        book: Book(
          id: e['id'],
          title: e['title'],
          author: e['author'],
          price: (e['price'] as num).toDouble(),
          rating: (e['rating'] as num).toDouble(),
          coverImage: e['coverImage'],
          category: e['category'],
          description: e['description'],
          pages: e['pages'],
          publishYear: e['publishYear'],
          isbn: e['isbn'],
        ),
        quantity: e['quantity'] ?? 1,
      );
    }).toList();
    notifyListeners();
  }

  Future<void> addToCart(Book book) async {
    final index = _items.indexWhere((item) => item.book.id == book.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(book: book, quantity: 1));
    }
    await _persistCart();
    notifyListeners();
  }

  void updateQuantity(String bookId, int delta) {
    final index = _items.indexWhere((item) => item.book.id == bookId);
    if (index >= 0) {
      _items[index].quantity += delta;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      _persistCart();
      notifyListeners();
    }
  }

  void removeItem(String bookId) {
    _items.removeWhere((item) => item.book.id == bookId);
    _persistCart();
    notifyListeners();
  }

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.book.price * item.quantity);

  double get tax => totalPrice * 0.1;
  double get grandTotal => totalPrice + tax;

  void clearCart() {
    _items.clear();
    _persistCart();
    notifyListeners();
  }

  Future<void> _persistCart() async {
    final cartData = _items.map((item) => {
      'id': item.book.id,
      'title': item.book.title,
      'author': item.book.author,
      'price': item.book.price,
      'rating': item.book.rating,
      'coverImage': item.book.coverImage,
      'category': item.book.category,
      'description': item.book.description,
      'pages': item.book.pages,
      'publishYear': item.book.publishYear,
      'isbn': item.book.isbn,
      'quantity': item.quantity,
    }).toList();
    await StorageService.saveCart(cartData);
  }
}