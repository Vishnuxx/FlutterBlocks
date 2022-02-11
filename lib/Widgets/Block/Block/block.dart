import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/Widgets/Editor/editorpane.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor.dart';
import 'package:flutter_application_1/Widgets/Indicator/arg_indicatior.dart';

import 'package:flutter_application_1/Widgets/Block/block_args.dart';
import 'package:flutter_application_1/Widgets/Block/block_spec.dart';
import 'package:flutter_application_1/Widgets/Block/block_base.dart';
import 'package:flutter_application_1/Widgets/Block/Block/block_methods.dart';
import 'package:flutter_application_1/Widgets/BlockUtils/block_size.dart';
import 'package:flutter_application_1/Widgets/Block/draw_block.dart';
import 'package:flutter_application_1/Widgets/drag_utils.dart';

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
  double subAH = 0;
  double subBH = 0;

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

  @override //places this next to 'block'
  void nextOf(Block block) {
    block.setNext(this);
  }

  @override
  void previousOf(Block block) {}

  @override
  void toSubstackAOf(Block block) {
    block.subA = this;
    _previous = block;
  }

  @override
  void toSubstackBOf(Block block) {
    block.subB = this;
    _previous = block;
  }

  @override
  void wrapBy(Block block) {}

  @override
  void setNext(Block block) {
    _next = block;
  }

  @override
  void setPrevious(Block block) {
    _previous = block;
  }

  @override
  void setSubstackA(Block block) {
    subA = block;
  }

  @override
  void setSubstackB(Block block) {
    subB = block;
  }

  void dropOverBlockInType(Block dropArea, String? type) {
    switch (type) {
      case "NEXT":
        nextOf(dropArea);
        print("next");
        break;
      case "PREVIOUS":
        previousOf(dropArea);
        print("prev");
        break;
      case "SUBA":
        toSubstackAOf(dropArea);
        print("suba");
        break;
      case "SUBB":
        toSubstackBOf(dropArea);
        print("subb");
        break;
      case "PARENT":
        wrapBy(dropArea);
        print("parent");
        break;
    }
  }

  @override
  void remove() {
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
    _depth = 0;
  }

  @override
  void dropTo(Widget? parent, String? droptype) {
    remove();

    switch (parent.runtimeType.toString()) {
      case "Block":
        if (this.isFromPallette) {
          editor.editorPane.addBlock(this);
        }

        dropOverBlockInType(parent as Block, droptype!);
        print("sjfksf");

        break;
      case "EditorPane":
        _parent = parent;
        setDepth(0);

        (parent as EditorPane).addBlock(this);

        break;
      case "BlockArg":
        _parent = parent;
        setDepth((parent as BlockArg).parentBlock!.getDepth() +
            1); //increase the depth
        (parent).addBlock(this);
        break;
    }
  }

  void setPositioned(bool pos) {
    _state.setState(() {
      isInEditor = pos;
    });
  }

  @override
  void recalculateBlock() {
    _state.setState(() {
      x = x;
      y = y;
      topH = topH;
      width = _blockSpec.width;
      // _base.width = _blockSpec.width;
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

  @override
  void showChildren(bool show, double _x, double _y) {
    Block? currentblock = this;
    double x = _x;
    double y = _y;
    while (currentblock != null) {
      currentblock.isVisible = show;
      currentblock.x = x;
      currentblock.y = y;
      switch (currentblock.type) {
        case "e":
          if (currentblock.hasChildInSubstackA()) {
            currentblock.subA?.showChildren(
                show,
                currentblock.x! + DrawBlock.SUBSTACK_INSET,
                currentblock.y! + currentblock.topH);
          }

          if (currentblock.hasChildInSubstackB()) {
            currentblock.subB?.showChildren(
                show,
                currentblock.x! + (DrawBlock.SUBSTACK_INSET),
                currentblock.y! + currentblock.topH + currentblock.subAH + 19);
          }
          break;
        case "f":
          if (currentblock.hasChildInSubstackA()) {
            currentblock.subA?.showChildren(
                show,
                currentblock.x! + DrawBlock.SUBSTACK_INSET,
                currentblock.y! + currentblock.topH);
          }
          break;
      }
      currentblock.recalculateBlock();
      x = currentblock.x!;
      y += currentblock.getTotalHeight();
      currentblock = currentblock._next;
    }
  }

  // @override
  // Block getAncestorBlock() {}
//

//__________GETTERS____________

//

  @override
  bool isBranchedBlock() {
    return type == "e" || type == "f";
  }

  @override
  bool isArgBlock() {
    return type == "s" || type == "b" || type == "n" || type == "d";
  }

  @override
  bool hasChildInSubstackA() {
    return subA != null;
  }

  @override
  bool hasChildInSubstackB() {
    return subB != null;
  }

  @override
  bool hasNext() {
    return _next != null;
  }

  @override
  bool hasPrevious() {
    return _previous != null;
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
  Block getLastBlock() {
    Block? currentBlock = this;
    while (true) {
      print("jfk");
      if (currentBlock?._next == null) {
        break;
      }
      currentBlock = currentBlock?._next;
    }
    return currentBlock!;
  }

  @override
  Block getAncestorBlock() {
    Block currentBlock = this;
    if (isArgBlock()) {
      while (true) {
        if (currentBlock._parent == EditorPane) {
          break;
        }
        currentBlock.recalculateBlock();
        currentBlock = (currentBlock._parent as BlockArg).parentBlock!;
      }
    }
    int depth = _depth;
    while (currentBlock._previous != null) {
      if (currentBlock == currentBlock._previous?.subA ||
          currentBlock == currentBlock._previous?.subB) {
        if (depth > 0) {
          depth--;
        } else {
          break;
        }
      }
      currentBlock = currentBlock._previous!;
    }
    return currentBlock;
  }

  @override
  double getTotalHeight() {
    switch (type) {
      case "e": //if-else
        return 6 * DrawBlock.EDGE_INSET + 20 + topH + subAH + subBH;
      case "f": //if
        return 3 * DrawBlock.EDGE_INSET + 10 + topH + subAH;
      case "r": //regular
        return topH;
      case "x": //ending
        return topH;
      case "b": //boolean
        return topH;
      case "s": //string
        return topH;
      case "n": //number
        return topH;
      default:
        return topH;
    }
  }

  @override
  double nextBlockY() {
    return y! + getTotalHeight();
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

  @override //returns the blockarg of at a pointer location
  BlockArg? getArgAtLocation(Offset location) {
    BlockArg? target;
    for (Widget arg in _blockSpec.params) {
      if (arg is BlockArg) {
        if (DragUtils.isHitting(arg, location)) {
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
              if (!widget.isFromPallette) {
                widget.showChildren(false, widget.x!, widget.y!);
              }
            });
          }
        },
        onDragUpdate: (details) {
          setState(() {
            if (isTriggered) {
              pointer = DragUtils.toRelativeOffset(Offset(
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
              if (!widget.isFromPallette) {
                widget.showChildren(true, widget.x!, widget.y!);
              }
            });
          }
          isTriggered = false;
        },
        child: GestureDetector(
          onTapDown: (details) {
            // setState(() {
            widget.offsetX = details.localPosition.dx;
            widget.offsetY = details.localPosition.dy;
            isTriggered = true;
            // });
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
