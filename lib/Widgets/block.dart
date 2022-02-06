import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/editorpane.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor.dart';
import 'package:flutter_application_1/Widgets/arg_indicatior.dart';

import 'package:flutter_application_1/Widgets/block_args.dart';
import 'package:flutter_application_1/Widgets/block_spec.dart';
import 'package:flutter_application_1/Widgets/block_base.dart';
import 'package:flutter_application_1/Widgets/block_methods.dart';
import 'package:flutter_application_1/Widgets/block_size.dart';
import 'package:flutter_application_1/Widgets/draw_block.dart';
import 'package:flutter_application_1/Widgets/droppable_regions.dart';

// ignore: must_be_immutable
class Block extends StatefulWidget implements BlockMethods {
  final _BlockState _state = _BlockState();
  late Base _base;
  final String type;
  Color color;
  final bool isDraggable;
  final bool isFromPallette;
  Function(Block b, TapDownDetails offset)? onTap;
  void Function(Block b)? onDragStart;
  void Function(Block b, Offset pointer)? onDragMove;
  void Function(Block b, Offset pointer)? onDragEnd;

  final String specs;
  double topH;
  double width;
  double? x = 0;
  double? y = 0;
  double subAH;
  double subBH;

  double offsetX = 0; //local touch offset X
  double offsetY = 0; //local touch offset Y

  Widget? _parent;
  Block? _next;
  Block? _previous;
  bool isVisible = true;
  bool isInEditor = true;

  late BlockSpec _blockSpec; // specs hold iside here

  LogicEditor editor;

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
      this.subAH = 10,
      this.subBH = 10,
      this.onTap,
      this.onDragStart,
      this.onDragMove,
      this.onDragEnd})
      : super(key: key);

  void update() {
    // ignore: invalid_use_of_protected_member
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

  setColor(Color _color) {
    _state.setState(() {
      color = _color;
    });
  }

  @override
  void setVisibility(bool visible) {
    // ignore: invalid_use_of_protected_member
    _state.setState(() {
      isVisible = visible;
    });
  }

  @override
  // ignore: no_logic_in_create_state
  State<Block> createState() => _state;

  @override
  Block? getNext() {
    return _next;
  }

  @override
  Widget? getParent() {
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
  void dropTo(Widget parent) {
    if (_parent != null) {
      switch (_parent.runtimeType.toString()) {
        case "EditorPane":
          (_parent as EditorPane).removeBlock(this);
          break;
        case "BlockArg":
          (_parent as BlockArg).removeBlock(this);
          break;
      }
    }

    switch (parent.runtimeType.toString()) {
      case "EditorPane":
        _parent = parent;
        (parent as EditorPane).addBlock(this);

        break;
      case "BlockArg":
        _parent = parent;
        (parent as BlockArg).addBlock(this);

        break;
    }
    print("dropped");
  }

  @override
  Block? getSubstackA() => throw UnimplementedError();

  @override
  Block? getSubstackB() => throw UnimplementedError();

  @override
  void substackA(Block subA) {
    // ignore: todo
    // TODO: implement substackA
  }

  @override
  void substackB(Block subB) {
    // ignore: todo
    // TODO: implement substackB
  }

  @override
  double getTotalHeight() {
    return _base.getTotalHeight();
  }

  @override
  double subAY() {
    return y! + _base.subAY();
  }

  @override
  double subBY() {
    return y! + _base.subBY();
  }

  @override
  double substackX() {
    return x! + _base.substackX();
  }

  @override
  bool isArgBlock() {
    return type == "s" ||
        type == "b" ||
        type == "n" ||
        type == "m" ||
        type == "d";
  }

  @override //returns the blockarg of at a pointer location
  BlockArg? getArgAtLocation(Offset location) {
    BlockArg? target;
    for (Widget arg in _blockSpec.params) {
      if (arg is BlockArg) {
        if (EditorPane.isHitting((arg as BlockArg), location)) {
          if ((arg).hasChildBlock()) {
            target = ((arg).getChildBlock()!.getArgAtLocation(location) != null)
                ? (arg).getChildBlock()!.getArgAtLocation(location)
                : arg;
            //target = arg;
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

  void setPositioned(bool pos) {
    _state.setState(() {
      isInEditor = pos;
    });
  }

  @override
  void indicateNext(ArgIndicator indicator) {
    if (getNext() != null) {
      indicator.set(() {
        indicator.x = x!;
        indicator.y = y! + getTotalHeight();
        indicator.width = width;
        indicator.height = 5;
        indicator.isVisible = true;
        indicator.type = "i";
      });
    } else {
      indicator.set(() {
        indicator.x = x!;
        indicator.y = y! + getTotalHeight();
        indicator.width = width;
        indicator.height = 20;
        indicator.isVisible = true;
        indicator.type = "r";
      });
    }
  }

  @override
  void indicateSubA(ArgIndicator indicator) {
    if (type == "e" || type == "f") {
      indicator.set(() {
        print("object");
        indicator.x = substackX();
        indicator.y = subAY();
        indicator.width = width - DrawBlock.SUBSTACK_INSET;
        indicator.height = 5;
        indicator.isVisible = true;
        indicator.type = "i";
      });
    }
  }

  @override
  void indicateSubB(ArgIndicator indicator) {
    if (type == "e") {
      indicator.set(() {
        indicator.x = substackX();
        indicator.y = subBY();
        indicator.width = width - DrawBlock.SUBSTACK_INSET;
        indicator.height = 5;
        indicator.isVisible = true;
        indicator.type = "i";
      });
    }
  }

  @override
  void indicatePrevious(ArgIndicator indicator) {
    indicator.set(() {
      indicator.x = substackX();
      indicator.y = subBY();
      indicator.width = width - DrawBlock.SUBSTACK_INSET;
      indicator.height = 5;
      indicator.isVisible = true;
      indicator.type = "i";
    });
  }

  @override
  void indicateasParent(ArgIndicator indicator) {
    // TODO: implement indicateasParent
  }
}

///
///
///
///
///
///
////STATE____________________
///
///
///
///
///

class _BlockState extends State<Block> {
  late Offset pointer = const Offset(0, 0);
  bool isTriggered = false;

  @override
  void initState() {
    super.initState();

    widget._blockSpec = BlockSpec(
      args: widget.specs,
      onSizeChanged: (p0) {
        widget.width = p0.width;
        widget.topH = p0.height;
      },
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

  Widget mBlock() {
    return Visibility(
      visible: widget.isVisible,
      maintainState: true,
      child: Draggable(
        feedback: (isTriggered && widget.isDraggable)
            ? dragFeedback()
            : const SizedBox(width: 0, height: 0),
        onDragStarted: () {
          if (isTriggered) {
            setState(() {
              widget.isVisible = (widget.isFromPallette) ? true : false;
              widget.onDragStart!(widget);
            });
          }
        },
        onDragUpdate: (details) {
          setState(() {
            if (isTriggered) {
              pointer = EditorPane.toRelativeOffset(Offset(
                  details.globalPosition.dx - widget.offsetX,
                  details.globalPosition.dy - widget.offsetY));
              widget.x = pointer.dx;
              widget.y = pointer.dy;
              widget.onDragMove!(widget, pointer);
            }
          });
        },
        onDragEnd: (details) {
          if (isTriggered) {
            setState(() {
              widget.isVisible = true;
              widget.onDragEnd!(widget, pointer);
            });
          }
          isTriggered = false;
        },
        child: GestureDetector(
          onTapDown: (details) {
            setState(() {
              widget.offsetX = details.localPosition.dx;
              widget.offsetY = details.localPosition.dy;
              isTriggered = true;
            });
          },
          child: Stack(
            children: [
              widget._base,
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget._base = Base(
      type: widget.type,
      topH: widget.topH,
      width: widget.width,
      color: widget.color,
      subAH: widget.subAH,
      subBH: widget.subBH,
    );
    if (widget.isDraggable) {
      if (widget.isFromPallette) {
        // ____________IS FROM PALLETTE____________
        return mBlock();
      } else {
        if (widget.isInEditor) {
          //_______IS NOT FROM PALLETTE___________
          return Positioned(left: widget.x, top: widget.y, child: mBlock());
        } else {
          return mBlock();
        }
      }
    } else {
      // _____________IS NOT DRAGGABLE_____________
      return Visibility(
        visible: widget.isVisible,
        maintainState: true,
        child: Wrap(
          children: [
            Stack(
              fit: StackFit.passthrough,
              children: [
                widget._base,
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
      );
    }
  }
}
