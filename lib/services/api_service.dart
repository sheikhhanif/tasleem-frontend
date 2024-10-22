import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  static const String _baseUrl = 'https://tasleem.ai'; // Replace with your backend URL

  /// Fetch explore items (articles, hadiths) from the backend.
  static Future<List<Article>> fetchExploreItems() async {
    final Uri uri = Uri.parse('$_baseUrl/explore');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Decode using utf8 to handle Unicode characters
      final String responseBody = utf8.decode(response.bodyBytes);

      List<dynamic> data = json.decode(responseBody);
      return data.map((item) => Article.fromJson(item)).toList();
    } else {
      throw Exception(
          'Failed to fetch explore items. Status Code: ${response.statusCode}');
    }
  }

  /// Sends a question to the backend and receives a stream of responses.
  static Stream<Map<String, dynamic>> askQuestion(String question) async* {
    final uri = Uri.parse('$_baseUrl/ask');
    final request = http.Request('POST', uri);

    request.headers['Content-Type'] = 'application/json; charset=utf-8';
    request.body = json.encode({'question': question});

    final client = http.Client();
    final streamedResponse = await client.send(request);

    if (streamedResponse.statusCode != 200) {
      throw Exception('Failed to connect to the server');
    }

    final stream = streamedResponse.stream
        .transform(utf8.decoder)
        .transform(LineSplitter());

    await for (final line in stream) {
      if (line.trim().isNotEmpty) {
        try {
          final data = json.decode(line);
          yield data; // Yield each chunk incrementally
        } catch (e) {
          continue; // Skip malformed lines
        }
      }
    }
  }

  /// Retrieves the full content of a document based on its ID.
  static Future<String> getContent(String id) async {
    final uri = Uri.parse('$_baseUrl/content?id=$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Decode using utf8 to handle Unicode characters
      final String responseBody = utf8.decode(response.bodyBytes);
      final data = json.decode(responseBody);
      if (data.containsKey('content')) {
        return data['content'];
      } else {
        throw Exception('Content not found');
      }
    } else {
      throw Exception('Failed to fetch content');
    }
  }
}
