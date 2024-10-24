// lib/models/article_adapter.dart

import 'package:hive/hive.dart';
import 'article.dart'; // Ensure this path is correct based on your project structure

class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 0; // Ensure this typeId is unique across all your adapters

  @override
  Article read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Article(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      link: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    writer
      ..writeByte(4) // Number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ArticleAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
