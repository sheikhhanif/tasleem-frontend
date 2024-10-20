// lib/widgets/swipeable_cards.dart

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showFullContentModal(BuildContext context, ContentModel doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FullContentModal(document: doc),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                color: Theme.of(context).colorScheme.primary,
                size: 24, // Reduced size
              ),
            ),
            SizedBox(width: 8),
            Text(
              'References',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 20, // Reduced font size
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        // Single Card containing the swipeable content
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3, // Reduced elevation for a flatter look
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Swipeable PageView
                SizedBox(
                  height: 80, // Constrained height for the swipeable area
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Reference Title
                            Text(
                              doc.title,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14, // Reduced font size
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            // Reference Summary
                            Text(
                              doc.summary.length > 80
                                  ? doc.summary.substring(0, 80) + '...'
                                  : doc.summary,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 12, // Reduced font size
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                // Page Indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.documents.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
