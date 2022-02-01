import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/editorpane.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor_data.dart';
import 'package:flutter_application_1/Widgets/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';
import 'package:flutter_application_1/Widgets/block_spec.dart';
import 'package:flutter_application_1/Widgets/block_base.dart';
import 'package:flutter_application_1/Widgets/block_methods.dart';
import 'package:flutter_application_1/Widgets/block_size.dart';

class Block extends StatefulWidget implements BlockMethods {
  _BlockState _state = _BlockState();
  final String type;
  final Color color;
  final bool isDraggable;
  final bool isFromPallette;
  Function(Block b, TapDownDetails)? onTap;
  Function(Block b, bool)? onDragStart;
  Function(Block b, Offset, bool)? onDragMove;
  Function(Block b, Offset, bool)? onDragEnd;

  bool isVisible = true;
  late BlockSpec _blockSpec;
  double topH;
  double width;
  double? x = 0;
  double? y = 0;
  double subAH;
  double subBH;
  String specs;

  Block? _parent;
  Block? _next;
  Block? _previous;
  Block? _substackA;

  LogicEditorData editor;

  Block(this.editor,
      {Key? key,
      this.isFromPallette = false,
      this.isDraggable = false,
      this.specs = "",
      this.x,
      this.y,
      this.type = "s",
      this.topH = 20,
      this.width = 80,
      this.color = Colors.amber,
      this.subAH = 20,
      this.subBH = 20,
      this.onTap,
      this.onDragStart,
      this.onDragMove,
      this.onDragEnd})
      : super(key: key);

  void update() {
    _state.setState(() {
      isVisible = isVisible;
      _blockSpec = _blockSpec;
      x = x;
      y = y;
      topH = topH;
      width = width;
      subAH = subAH;
      subBH = subBH;
    });
  }

  @override
  void setVisibility(bool visible) {
    _state.setState(() {
      isVisible = visible;
    });
  }

  @override
  State<Block> createState() => _state;

  @override
  Block? getNext() {
    return _next;
  }

  @override
  Block? getParent() {
    return _parent;
  }

  @override
  Block? getPrevious() {
    return _previous;
  }

  @override
  void next(Block next) {
    _next = next;
  }

  @override
  void previous(Block previus) {
    _previous = previus;
  }

  @override
  void parent(Block parent) {
    _parent = parent;
  }

  @override
  Block? getSubstackA() {
    // TODO: implement getSubstackA
    throw UnimplementedError();
  }

  @override
  Block? getSubstackB() {
    // TODO: implement getSubstackB
    throw UnimplementedError();
  }

  @override
  void substackA(Block subA) {
    // TODO: implement substackA
  }

  @override
  void substackB(Block subB) {
    // TODO: implement substackB
  }

  @override
  bool isArgBlock() {
    return type == "s" ||
        type == "b" ||
        type == "n" ||
        type == "m" ||
        type == "d";
  }

  @override
  BlockArg? getArgAtLocation(Offset location) {
    BlockArg? target;
    for (Widget arg in _blockSpec.params) {
      if (arg.runtimeType == BlockArg) {
        //print("this is a" + arg.runtimeType.toString());
        if ((arg as BlockArg).isHitting(location)) {
          if ((arg as BlockArg).hasChildBlock()) {
            // target = ((arg as BlockArg)
            //             .getChildBlock()!
            //             .getArgAtLocation(location) !=
            //         null)
            //     ? (arg as BlockArg).getChildBlock()!.getArgAtLocation(location)
            //     : arg;
            target = arg;
          } else {
            target = arg;
          }
          break;
        }
      } else {
        target = null;
      }
    }
    return target;
  }

  @override
  bool isHitting(Offset coordinate) {
    RenderBox box2 =
        (this.key as GlobalKey).currentContext?.findRenderObject() as RenderBox;

    final size2 = box2.size;
    final pos = box2.localToGlobal(Offset.zero);
    final collide = coordinate.dx > pos.dx &&
        coordinate.dx < (pos.dx + size2.width) &&
        coordinate.dy > pos.dy &&
        coordinate.dy < (pos.dy + size2.height);

    return collide;
  }
}

class _BlockState extends State<Block> {
  late Base _base;
  late double offsetX = 0;
  late double offsetY = 0;
  late Offset pointer = Offset(0, 0);
  bool isTriggered = false;
  var k = GlobalKey();
  @override
  void initState() {
    super.initState();

    widget._blockSpec = BlockSpec(
      key: k,
      args: widget.specs,
    );
  }

  Widget dragFeedback() {
    return Base(
      type: widget.type,
      topH: 30,
      width: 80,
      color: Colors.black26,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDraggable) {
      return Positioned(
        left: widget.x,
        top: widget.y,
        child: Visibility(
          visible: widget.isVisible,
          maintainState: true,
          child: Draggable(
            feedback: dragFeedback(),
            child: GestureDetector(
              onTapDown: (details) {
                offsetX = details.localPosition.dx;
                offsetY = details.localPosition.dy;
                isTriggered = true;
              },
              child: Wrap(
                children: [
                  Stack(
                    children: [
                      Base(
                        type: widget.type,
                        topH: widget.topH,
                        width: widget.width,
                        color: widget.color,
                        subAH: widget.subAH,
                        subBH: widget.subBH,
                      ),
                      BlockSize(
                          onChange: (size) {
                            setState(() {
                              widget.topH = size.height;
                              widget.width = size.width;
                            });
                          },
                          child: widget._blockSpec),
                    ],
                  ),
                ],
              ),
            ),
            onDragStarted: () {
              if (isTriggered) {
                widget.onDragStart!(widget, widget.isFromPallette);
              }
            },
            onDragUpdate: (details) {
              if (isTriggered) {
                pointer = EditorPane.toRelativeOffset(Offset(details.globalPosition.dx - offsetX, details.globalPosition.dy - offsetY));
                widget.x = pointer.dx;
                widget.y = pointer.dy;
                widget.editor.editorPane
                    .findBlockArgs(widget, Offset(details.globalPosition.dx - offsetX,
                        details.globalPosition.dy - offsetY));
                widget.onDragMove!(
                    widget, pointer , widget.isFromPallette);
              }
            },
            onDragEnd: (details) {
              isTriggered = false;
              widget.isVisible = true;

              widget.onDragEnd!(widget, pointer, widget.isFromPallette);
              widget.update();
              
            },
          ),
        ),
      );
    } else {
      return Positioned(
          left: widget.x,
          top: widget.y,
          child: Visibility(
            visible: widget.isVisible,
            maintainState: true,
            child: Wrap(
              children: [
                Stack(
                  children: [
                    Base(
                      type: widget.type,
                      topH: widget.topH,
                      width: widget.width,
                      color: widget.color,
                      subAH: widget.subAH,
                      subBH: widget.subBH,
                    ),
                    BlockSize(
                        onChange: (size) {
                          setState(() {
                            widget.topH = size.height;
                            widget.width = size.width;
                          });
                        },
                        child: widget._blockSpec),
                  ],
                ),
              ],
            ),
          ));
    }
  }
}
