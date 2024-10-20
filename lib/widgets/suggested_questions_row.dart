// lib/widgets/suggested_questions_row.dart

import 'package:flutter/material.dart';

class SuggestedQuestionsRow extends StatelessWidget {
  final Function(String) onQuestionTap;
  final List<String> questions;

  SuggestedQuestionsRow({required this.onQuestionTap, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          // 1 → 2 → 1 Card Pattern
          _buildCard(context, questions[0], 180),
          _buildCard(context, questions[1], 120),
          _buildCard(context, questions[2], 120),
          _buildCard(context, questions[3], 180),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String question, double width) {
    return GestureDetector(
      onTap: () {
        onQuestionTap(question);
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
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
                question,
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
    );
  }
}
