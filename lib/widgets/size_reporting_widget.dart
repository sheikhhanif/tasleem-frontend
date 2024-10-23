// size_reporting_widget.dart
import 'package:flutter/material.dart';

typedef OnWidgetSizeChange = void Function(Size size);

class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final OnWidgetSizeChange onSizeChange;

  const SizeReportingWidget({
    Key? key,
    required this.child,
    required this.onSizeChange,
  }) : super(key: key);

  @override
  _SizeReportingWidgetState createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = this.context;
      if (context != null) {
        final size = context.size;
        if (size != null) {
          widget.onSizeChange(size);
        }
      }
    });

    return widget.child;
  }
}
