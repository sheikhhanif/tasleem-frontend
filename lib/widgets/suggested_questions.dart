// lib/widgets/suggested_questions.dart

import 'package:flutter/material.dart';

class SuggestedQuestions extends StatelessWidget {
  final Function(String) onQuestionTap;

  SuggestedQuestions({required this.onQuestionTap});

  final List<String> questions = [
    'What is Riba?',
    'What is Islam?',
    'What is Zakat?',
    'What is Halal?',
    'What is Hajj?',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: questions.length,
        separatorBuilder: (context, index) => SizedBox(width: 8),
        itemBuilder: (context, index) {
          return GestureDetector(
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
                children: [
                  Icon(Icons.question_answer, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    questions[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
