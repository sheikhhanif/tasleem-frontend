// lib/services/api_service.dart

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://tasleem.ai'; // Replace with your backend URL

  static Stream<Map<String, dynamic>> askQuestion(String question) async* {
    final uri = Uri.parse('$_baseUrl/ask');
    final request = http.Request('POST', uri);

    request.headers['Content-Type'] = 'application/json';
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

  static Future<String> getContent(String id) async {
    final uri = Uri.parse('$_baseUrl/content?id=$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
