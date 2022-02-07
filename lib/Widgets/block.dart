import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  Block? subA;
  Block? subB;
  Block? parentSubA;
  Block? parentSubB;

  int _depth = 0;

  Block(this.editor,
      {Key? key,
      this.isFromPallette = false,
      this.isDraggable = false,
      this.isInEditor = false,
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
      : super(key: key) {
    _blockSpec = BlockSpec(
      args: specs,
      block: this,
      onSizeChanged: (p0) {
        // widget.width = p0.width;
        // widget.topH = p0.height;
      },
    );
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

//

//___________SETTERS__________

//

  @override
  void setDepth(int depth) {
    _depth = depth;
  }

  @override
  void setParent(Widget? parent) {
    _parent = parent;
  }

  @override //places this next to 'next'
  void nextOf(Block block) {
    block._next = this;
    _previous = block;
    _depth = block.getDepth();
  }

  @override
  void previousOf(Block block) {
    block._previous = this;
    _next = block;
    _depth = block._depth;
  }

  @override
  void toSubstackAOf(Block block) {
    _previous = null;
    block.subA = this;
    parentSubA = block;
  }

  @override
  void toSubstackBOf(Block block) {
    _previous = null;
    block.subA = this;
    parentSubA = block;
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
        setDepth(0);
        (parent as EditorPane).addBlock(this);
        break;
      case "BlockArg":
        _parent = parent;
        setDepth((parent as BlockArg).parentBlock!.getDepth() +
            1); //increase the depth
        (parent as BlockArg).addBlock(this);

        break;
    }
  }

  void setPositioned(bool pos) {
    _state.setState(() {
      isInEditor = pos;
    });
  }

  @override
  void indicateNext(ArgIndicator indicator, Block draggable) {
    if (getNext() != null) {
      indicator.type = "i";
    } else {
      switch (draggable.type) {
        case "r":
          indicator.type = "r";
          indicator.height = 20;
          break;
        case "e":
          indicator.type = "e";
          indicator.height = 20;
          break;
        case "f":
          indicator.type = "f";
          indicator.height = 20;
          break;
        case "x":
          indicator.type = "x";
          indicator.height = 20;
          break;
        default:
          indicator.type = "r";
          indicator.height = 20;
          break;
      }
    }
    indicator.set(() {
      indicator.x = x!;
      indicator.y = y! + getTotalHeight();
      indicator.width = width;
      indicator.subAH = 10;
      indicator.height = indicator.height;
      indicator.isVisible = true;
      indicator.type = indicator.type;
    });
  }

  @override
  void indicatePrevious(ArgIndicator indicator, Block draggable) {
    if (getPrevious() == null) {
      switch (draggable.type) {
        case "r":
          indicator.type = "r";
          indicator.height = draggable.topH;
          indicator.y = y! - indicator.height;
          break;
        case "e":
          indicator.type = "e";
          indicator.height = 20;
          indicator.y = y! - indicator.getTotalHeight();
          break;
        case "f":
          indicator.type = "f";
          indicator.height = 20;
          indicator.y = y! - indicator.getTotalHeight();
          break;

        default:
          return;
      }
    }
    indicator.set(() {
      indicator.x = x!;
      indicator.y = indicator.y;
      indicator.width = width;
      indicator.height = indicator.height;
      indicator.subAH = 10;
      indicator.type = indicator.type;
      indicator.isVisible = true;
    });
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
  void indicateasParent(ArgIndicator indicator, Block draggable) {
    // if (getParent() == null && getPrevious() == null) {
    if (draggable.type == "e" || draggable.type == "f") {
      indicator.set(() {
        indicator.x = x! - DrawBlock.SUBSTACK_INSET;
        indicator.y = y! - draggable.topH;
        indicator.width = draggable.width;
        indicator.height = draggable.topH;
        indicator.subAH = getTotalHeight() - DrawBlock.EDGE_INSET;
        indicator.type = draggable.type;
        indicator.isVisible = true;
      });
    }
  }

  @override
  void recalculateBlock() {
    _state.setState(() {
      topH = topH;
      width = _blockSpec.width;
      _base.width = _blockSpec.width;
      subAH = subAH;
      subBH = subBH;
    });
  }

  @override
  void refreshBlocks() {
    if (_parent != null && !(_parent is EditorPane)) {
      recalculateBlock();
      (_parent as BlockArg).parentBlock?.recalculateBlock();
    }
  }

//

//__________GETTERS____________

//

  @override
  bool isBranchedBlock() {
    return type == "e" || type == "f";
  }

  @override
  int getDepth() {
    return _depth;
  }

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
          if (EditorPane.isHitting(arg , location)) {
            if ((arg).hasChildBlock()) {
              target =
                  ((arg).getChildBlock()!.getArgAtLocation(location) != null)
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
    widget.isInEditor = widget.isInEditor;
    super.initState();
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
                  child: BlockSize(
                    child: widget._blockSpec,
                    onChange: (size) {
                      setState(() {
                        widget.width = widget.width;
                        widget.topH = size.height;
                      });
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        widget.isInEditor = widget.isInEditor;
        widget._base.width = widget._blockSpec.width;
      });
    });
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
        return mBlock();
      } else {
        if (widget.isInEditor) {
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
              children: [
                widget._base,
                widget._blockSpec,
              ],
            ),
          ],
        ),
      );
    }
  }
}
