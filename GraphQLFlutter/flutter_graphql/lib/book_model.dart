class BookModel{
  final String? id;
  final String title;
  final String author;
  final int year;

  BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.year
  });

  static BookModel fromMap({required Map map}) => BookModel(
      id: map['_id'],
      title: map['title'],
      author: map['author'],
      year: map['year']
    );

}