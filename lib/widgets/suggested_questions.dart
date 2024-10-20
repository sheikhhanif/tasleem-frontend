// lib/widgets/suggested_questions_row.dart

import 'package:flutter/material.dart';

class SuggestedQuestionsRow extends StatelessWidget {
  final Function(String) onQuestionTap;
  final List<String> questions;
  final double cardHeight;
  final double cardWidth;

  SuggestedQuestionsRow({
    required this.onQuestionTap,
    required this.questions,
    this.cardHeight = 50, // Default height
    this.cardWidth = 160, // Default width
  });

  @override
  Widget build(BuildContext context) {
    // Ensure there are exactly 4 questions for the 1 → 2 → 1 pattern
    assert(questions.length == 4, 'Each row must have exactly 4 questions.');

    return Container(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: cardWidth,
            margin: const EdgeInsets.symmetric(horizontal: 6.0),
            child: GestureDetector(
              onTap: () {
                onQuestionTap(questions[index]);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.question_answer, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        questions[index],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
