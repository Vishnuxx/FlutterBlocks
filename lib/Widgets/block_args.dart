import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/editorpane.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_size.dart';
import 'package:flutter_application_1/Widgets/draw_block.dart';
import 'package:flutter_application_1/Widgets/droppable_regions.dart';

// ignore: must_be_immutable
class BlockArg extends StatefulWidget implements DroppableRegion {
  final _BlockArgState _state = _BlockArgState();
  Color? color = Colors.black26;
  Block? _child;
  final bool _trigger = false;

  String? type;
  double? width;
  double? height;

  BlockArg({
    Key? key,
    this.type = "s",
    this.width = 30,
    this.height = 20,
  }) : super(key: key);

  @override //add
  void addBlock(Block block) {
    if (canAcceptBlockOfType(block.type)) {
      // ignore: invalid_use_of_protected_member
      _state.setState(() {
        block.x = 0;
        block.y = 0;
        _child = block;
         width = block.width;
        height = block.topH;
      });
    } else {
      print("already has child block");
    }
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

  @override
  Widget build(BuildContext context) {
    Widget wid = BlockSize(
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          CustomPaint(
              painter: DrawBlock(
                  blockColor: (widget._trigger) ? Colors.red : widget.color!,
                  type: _argType(widget.type!),
                  width: widget.width!,
                  topH: widget.height!)),
          SizedBox(
              width: widget.width, height: widget.height, child: widget._child),
        ],
      ),
      onChange: (size) {
        if (widget._child != null) {
          setState(() {
            widget.width = size.width;
            widget.height = size.height;
          });
        } else {
          widget.height = 20;
          widget.width = 30;
        }
      },
    );

    return wid;
  }
}
