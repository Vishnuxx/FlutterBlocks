import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';
import 'package:flutter_application_1/Widgets/bounds.dart';

class ArgIndicator extends StatefulWidget {
  _ArgIndicatorState _state = _ArgIndicatorState();
  bool isVisible;
  String type;
  double width;
  double height;
  double x = 0;
  double y = 0;

  ArgIndicator(
      {Key? key,
      this.isVisible = true,
      this.type = "s",
      this.height = 20,
      this.width = 30})
      : super(key: key);

  void updateIndicator() {
    _state.setState(() {
      type = type;
      width = width;
      height = height;
      x = x;
      y = x;
      isVisible;
    });
  }

  void indicateArg(BlockArg? arg) {
    RenderBox? box2 =
        (arg?.key as GlobalKey).currentContext?.findRenderObject() as RenderBox;

    if (arg != null) {
      final size2 = box2.size;
      final pos = box2.localToGlobal(Offset.zero);
      print(pos);
      _state.setState(() {
        x = pos.dy;
        y = pos.dx;

        width = size2.width;
        height = size2.height;

        isVisible = true;
      });
    } else {
      _state.setState(() {
        width = 0;
        height = 0;
        x = 0;
        y = 0;
      });
    }
    return;
  }

  @override
  State<ArgIndicator> createState() => _state;
}

class _ArgIndicatorState extends State<ArgIndicator> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.x,
      top: widget.y,
      child: Visibility(
        visible: widget.isVisible,
        child: Container(
            width: widget.width, height: widget.height, color: Colors.black),
      ),
    );
  }
}
