// lib/widgets/swipeable_cards.dart

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/content_model.dart';
import 'full_content_modal.dart';
import '../widgets/summary_section.dart';
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
      builder: (context) => FullContentModal(
        document: doc,
        title: doc.title, // Pass the dynamic title here
      ),
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
                size: 24, // Adjusted size
              ),
            ),
            SizedBox(width: 8),
            Text(
              'References',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20, // Adjusted font size
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        // Container instead of Card for swipeable content
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
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
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14, // Adjusted font size
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 6),
                          // Reference Summary
                          Text(
                            doc.summary.length > 80
                                ? doc.summary.substring(0, 80) + '...'
                                : doc.summary,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12, // Adjusted font size
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
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
      ],
    );
  }
}
