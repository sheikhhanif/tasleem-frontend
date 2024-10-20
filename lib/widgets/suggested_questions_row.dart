// lib/widgets/suggested_questions_row.dart

import 'package:flutter/material.dart';

class SuggestedQuestionsRow extends StatefulWidget {
  final Function(String) onQuestionTap;
  final List<String> questions;

  SuggestedQuestionsRow({
    required this.onQuestionTap,
    required this.questions,
  });

  @override
  _SuggestedQuestionsRowState createState() => _SuggestedQuestionsRowState();
}

class _SuggestedQuestionsRowState extends State<SuggestedQuestionsRow>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late double _maxScrollExtent;
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Initialize the animation controller for scrolling
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60), // Adjust for scrolling speed
    )..addListener(() {
      if (_scrollController.hasClients && !_isUserScrolling) {
        double newOffset = _animationController.value * _maxScrollExtent;
        _scrollController.jumpTo(newOffset);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _maxScrollExtent = _scrollController.position.maxScrollExtent;
        _animationController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Duplicate the questions to allow seamless scrolling
  List<String> get _extendedQuestions => [...widget.questions, ...widget.questions];

  @override
  Widget build(BuildContext context) {
    // Access the current theme's color scheme and text theme
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 35, // Maintain consistent height
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is UserScrollNotification ||
              scrollNotification is ScrollStartNotification) {
            setState(() {
              _isUserScrolling = true;
              _animationController.stop();
            });
          } else if (scrollNotification is ScrollEndNotification ||
              scrollNotification is OverscrollNotification) {
            setState(() {
              _isUserScrolling = false;
              _animationController.repeat();
            });
          }
          return false;
        },
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: _extendedQuestions.length,
          itemBuilder: (context, index) {
            final question = _extendedQuestions[index];
            return GestureDetector(
              onTap: () {
                widget.onQuestionTap(question);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced internal padding
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant, // Theme-based background color
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.onSurface.withOpacity(0.1), // Subtle shadow for depth
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.question_answer,
                      color: colorScheme.onSurface, // Theme-based icon color
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      question,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface, // Theme-based text color
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
