import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BlockSize extends StatefulWidget {
  final Widget child;
  final Function(Size size) onChange;

   const BlockSize({
    Key? key,
    required this.onChange,
    required this.child,
  }) : super(key: key);

  @override
  _BlockSizeState createState() => _BlockSizeState();
}

class _BlockSizeState extends State<BlockSize> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  // ignore: prefer_typing_uninitialized_variables
  var oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize!);
  }
}
