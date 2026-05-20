class Book {
  final String id;
  final String title;
  final String author;
  final double price;
  final double rating;
  final String coverImage;
  final String category;
  final String description;
  final int pages;
  final int publishYear;
  final String isbn;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.coverImage,
    required this.category,
    required this.description,
    required this.pages,
    required this.publishYear,
    required this.isbn,
  });
}