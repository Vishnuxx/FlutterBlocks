// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/editorpane.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';
import 'package:flutter_application_1/Widgets/draw_block.dart';

// ignore: must_be_immutable
class ArgIndicator extends StatefulWidget {
  final _ArgIndicatorState _state = _ArgIndicatorState();
  bool isVisible;
  String type;
  double width;
  double height;
  double x = 0;
  double y = 0;

  ArgIndicator(
      {Key? key,
      this.isVisible = false,
      this.type = "s",
      this.height = 20,
      this.width = 30})
      : super(key: key);

  // ignore: duplicate_ignore
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
    if (arg != null) {
      RenderBox box2;
      box2 = (arg.key as GlobalKey).currentContext?.findRenderObject()
          as RenderBox;
      final size2 = box2.size;
      final pos = EditorPane.toRelativeOffset(box2.localToGlobal(Offset.zero));
      //print(pos);
      _state.setState(() {
        x = pos.dx;
        y = pos.dy;
        width = size2.width;
        height = size2.height;
        type = arg.type!;
        isVisible = true;
      });
    } else {
      _state.setState(() {
        width = 0;
        height = 0;
        x = 0;
        y = 0;
        isVisible = false;
      });
    }
  }

  void indicateNextBlock(Block? _block) {
    if (_block != null) {
      RenderBox box2;
      box2 = (_block.key as GlobalKey).currentContext?.findRenderObject()
          as RenderBox;
      final size2 = box2.size;
      final pos = EditorPane.toRelativeOffset(box2.localToGlobal(Offset.zero));
      _state.setState(() {
        x = pos.dx;
        y = pos.dy + _block.topH;
        type = "b";
        height = 5;
        width = _block.width;
        isVisible = true;
      });
      
    } else {
      _state.setState(() {
        width = 0;
        height = 0;
        x = 0;
        y = 0;
        isVisible = false;
      });
    }
  }

  @override
  // ignore: no_logic_in_create_state
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
        child: CustomPaint(
          painter: DrawBlock(
              blockColor: Colors.black,
              width: widget.width,
              topH: widget.height,
              type: widget.type),
        ),
      ),
    );
  }
}
