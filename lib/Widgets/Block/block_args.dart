import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/Editor/editorpane.dart';
import 'package:flutter_application_1/Widgets/Block/Block/block.dart';
import 'package:flutter_application_1/Widgets/BlockUtils/block_size.dart';
import 'package:flutter_application_1/Widgets/Block/draw_block.dart';
import 'package:flutter_application_1/Widgets/BlockUtils/droppable_regions.dart';
import 'package:flutter_application_1/Widgets/drag_utils.dart';

// ignore: must_be_immutable
class BlockArg extends StatefulWidget implements DroppableRegion {
  final _BlockArgState _state = _BlockArgState();
  Color? color = Colors.black26;
  Block? _child;
  final bool _trigger = false;

  String? type;
  double? width;
  double? height;
  Block? parentBlock;

  BlockArg(
      {Key? key,
      this.type = "s",
      this.width = 30,
      this.height = 20,
      this.parentBlock})
      : super(key: key);

  bool isHitting(Offset coordinate) {
    RenderBox box2 =
        (key as GlobalKey).currentContext?.findRenderObject() as RenderBox;
    Rect draggingPos = Rect.fromLTWH(coordinate.dx, coordinate.dy, 30, 20);
    final pos = DragUtils.toRelativeOffset(box2.localToGlobal(Offset.zero));
    Rect droppingPos = Rect.fromLTWH(pos.dx, pos.dy, 30, 20);

    return droppingPos.overlaps(draggingPos);
  }

  @override //add
  void addBlock(Block block) {
      block.dropToArg(this);
      _child = block;
      _state.setState(() {
        width = block.width;
        height = block.topH;
      });
      //parentBlock?.refreshBlocks();
  }

  @override //remove
  void removeBlock(Block block) {
    // ignore: invalid_use_of_protected_member
    _state.setState(() {
      _child = null;
      width = 30;
      height = 20;
    });
  }

  // returns true if it has block inside it
  bool hasChildBlock() {
    return _child != null;
  }

  Block? getChildBlock() {
    return _child;
  }

  // returns true if the draggable and the arg hooder are of same type
  bool canAcceptBlockOfType(String _type) {
    return type == _type;
  }

  @override
  // ignore: no_logic_in_create_state
  State<BlockArg> createState() => _state;
}

class _BlockArgState extends State<BlockArg> {
  String _argType(String type) {
    String t = "s";
    switch (type) {
      case "b":
        t = "b";
        break;
      case "n":
        t = "n";
        break;
    }
    return t;
  }

  Widget getBlock() {
    if (widget._child != null) {
      return widget._child!;
    } else {
      return SizedBox(
          width:30,
          height: (widget.height! < 20) ? 20 : widget.height,
          child: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(direction: Axis.horizontal, children: [
      CustomPaint(
          painter: DrawBlock(
              blockColor: (widget._trigger) ? Colors.red : widget.color!,
              type: _argType(widget.type!),
              width: 30,
              topH: 20)),
      Stack(children: [
        const SizedBox(width: 30, height: 20, child: null),
        getBlock()
      ])
    ]);
  }
}
