// lib/utils/text_utils.dart

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

class TextUtils {
  /// Preprocesses content by formatting bold text and handling line breaks.
  static String preprocessContent(String content) {
    // Handle bold text wrapped with double asterisks (**)
    content = content.replaceAllMapped(
      RegExp(r'\*\*(.*?)\*\*'),
          (match) => '\u{001B}${match[1]}\u{001B}', // Using escape sequence for custom parsing
    );

    // Replace single newlines where the previous character is not a punctuation mark with a space
    content = content.replaceAllMapped(
      RegExp(r'([^.,;:!?"])\n+'),
          (match) => '${match[1]} ',
    );

    // Replace remaining single newlines (after punctuation) with actual line breaks
    content = content.replaceAll(
      RegExp(r'[\n]+'),
      '\n\n',
    );

    // Remove extra spaces within lines (multiple spaces between words)
    content = content.replaceAll(
      RegExp(r'[^\S\n]+'), // Matches whitespace except newlines
      ' ',
    );

    // Trim leading and trailing whitespaces
    content = content.trim();

    return content;
  }

  /// Detects if the text contains Arabic characters.
  static bool containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  /// Returns a TextStyle based on whether the text contains Arabic and if it should be bold.
  static TextStyle getTextStyle({
    required bool isBold,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required String text,
  }) {
    bool isArabic = containsArabic(text);
    return textTheme.bodyMedium?.copyWith(
      fontSize: 16,
      height: 1.6,
      color: colorScheme.onBackground,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontFamily: isArabic ? 'Scheherazade' : null,
    ) ??
        TextStyle();
  }

  /// Parses preprocessed content into TextSpan for rendering rich text.
  static List<TextSpan> parseContentToTextSpans(
      String content,
      TextTheme textTheme,
      ColorScheme colorScheme,
      ) {
    List<TextSpan> textSpans = [];

    // Split the content by '\n\n' for handling line breaks
    List<String> parts = content.split('\n\n');

    for (String part in parts) {
      // Check if part contains bold text (wrapped in escape sequences)
      if (part.contains('\u{001B}')) {
        bool isBold = false;
        part.split('\u{001B}').forEach((segment) {
          if (segment.isNotEmpty) {
            textSpans.add(
              TextSpan(
                text: segment,
                style: getTextStyle(
                  isBold: isBold,
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                  text: segment,
                ),
              ),
            );
          }
          isBold = !isBold; // Toggle bold
        });
      } else {
        // Regular paragraph segment
        textSpans.add(
          TextSpan(
            text: part,
            style: getTextStyle(
              isBold: false,
              textTheme: textTheme,
              colorScheme: colorScheme,
              text: part,
            ),
          ),
        );
      }

      // Add a line break between paragraphs
      textSpans.add(
        TextSpan(text: '\n\n'),
      );
    }

    return textSpans;
  }

  /// Preprocesses the title by removing extra spaces and newlines.
  static String preprocessTitle(String title) {
    // Replace newlines with spaces and trim extra spaces
    return title.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Truncates the given text to a specified length without breaking characters.
  static String truncateText(String text, int maxLength) {
    final Characters characters = text.characters;
    if (characters.length > maxLength) {
      return characters.take(maxLength).toString() + '...';
    }
    return text;
  }
}
