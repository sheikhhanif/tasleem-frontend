class Article {
  final String id;
  final String title;
  final String content;
  final String link;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.link,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      link: json['link'] ?? '',
    );
  }
}
