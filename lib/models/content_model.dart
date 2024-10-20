// lib/models/content_model.dart

class ContentModel {
  final String id;
  final String title;
  final String summary;
  final Map<String, dynamic> metadata;

  ContentModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.metadata,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    final metadata = Map<String, dynamic>.from(json['metadata'] ?? {});
    return ContentModel(
      id: metadata['id'] ?? '',
      title: metadata['title'] ?? 'Document',
      summary: json['page_content'] ?? '',
      metadata: metadata,
    );
  }
}
