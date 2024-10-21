// lib/widgets/swipeable_cards.dart

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async'; // For Timer
import '../models/content_model.dart';
import 'full_content_modal.dart';
import 'package:flutter/services.dart'; // For HapticFeedback

class SwipeableCards extends StatefulWidget {
  final List<ContentModel> documents;

  SwipeableCards({required this.documents});

  @override
  _SwipeableCardsState createState() => _SwipeableCardsState();
}

class _SwipeableCardsState extends State<SwipeableCards> {
  PageController _pageController = PageController();
  int currentIndex = 0;
  Timer? _autoSwipeTimer;

  @override
  void initState() {
    super.initState();
    _startAutoSwipe();
  }

  @override
  void dispose() {
    _autoSwipeTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSwipe() {
    _autoSwipeTimer = Timer.periodic(Duration(seconds: 6), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (currentIndex + 1) % widget.documents.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 2000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _showFullContentModal(BuildContext context, ContentModel doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FullContentModal(
        document: doc,
        title: doc.title, // Pass the dynamic title here
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Icon and Title
        Row(
          children: [
            Semantics(
              label: 'References Icon',
              child: Icon(
                Icons.bookmark,
                color: colorScheme.secondary,
                size: 24,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'References',
              style: textTheme.titleMedium?.copyWith(
                fontSize: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        // Container for swipeable content
        Container(
          height: 150, // Adjusted height for the swipeable card
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: colorScheme.onSurface.withOpacity(0.01),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              // Swipeable PageView with vertical scrolling enabled
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: BouncingScrollPhysics(),
                  itemCount: widget.documents.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final doc = widget.documents[index];
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact(); // Haptic feedback on tap
                        _showFullContentModal(context, doc);
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Reference Title (max 2 lines)
                            Text(
                              doc.title,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4), // Adjusted spacing
                            // Reference Summary (max 3 lines)
                            Text(
                              doc.summary.replaceAll('\n', ' '), // Strip new lines
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 14,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 8), // Adjusted spacing
              // Page Indicator
              SmoothPageIndicator(
                controller: _pageController,
                count: widget.documents.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
