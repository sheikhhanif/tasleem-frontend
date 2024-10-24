import 'package:hive_flutter/adapters.dart';

class Article {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
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
