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
import 'package:flutter_application_1/Widgets/Renderer/block_renderer.dart';
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
    this.getPrevious()?.setNext(null);
    if (block.getNext() != null) {
      Block? lastBlock = getLastBlock();
      lastBlock.setNext(block.getNext()!);
      block.getNext()?.setPrevious(lastBlock);
      block.setNext(this);
      this.setPrevious(block);
      return;
    }
    block.setNext(this);
    this.setPrevious(block);
    _depth = getPrevious()!.getDepth();
  }

  @override
  void previousOf(Block block) {
    this.getPrevious()?.setNext(null);
    if (block.getPrevious() == null) {
      Block? lastBlock = getLastBlock();
      lastBlock.setNext(block);
      block.setPrevious(lastBlock);
      // _depth = 0;
    }
  }

  @override
  void toSubstackAOf(Block block) {
    if (_previous != null) {
      if (_previous!.isBranchedBlock()) {
        if (_previous!.subA == this) {
          this.getPrevious()?.setSubstackA(null);
        } else if (_previous!.subB == this) {
          this.getPrevious()?.setSubstackB(null);
        }
      }
      if (_previous!.getNext() == this) {
        this.getPrevious()?.setNext(null);
      }
    }

    if (block.subA != null) {
      Block? lastBlock = getLastBlock();
      lastBlock.setNext(block.subA);
      block.subA?.setPrevious(lastBlock);
      block.setSubstackA(this);
      this.setPrevious(block);
      return;
    }
    block.subA = this;
    this.setPrevious(block);
    _depth = block.getDepth() + 1;
  }

  @override
  void toSubstackBOf(Block block) {
    if (_previous != null) {
      if (_previous!.isBranchedBlock()) {
        if (_previous!.subA == this) {
          this.getPrevious()?.setSubstackA(null);
        } else if (_previous!.subB == this) {
          this.getPrevious()?.setSubstackB(null);
        }
      }
      if (_previous!.getNext() == this) {
        this.getPrevious()?.setNext(null);
      }
    }
    if (block.subB != null) {
      Block? lastBlock = getLastBlock();
      lastBlock.setNext(block.subB);
      block.subB?.setPrevious(lastBlock);
      block.setSubstackB(this);

      this.setPrevious(block);
      return;
    }
    block.subB = this;
    this.getPrevious()?.setNext(null);
    this.setPrevious(block);
    _depth = block.getDepth() + 1;
  }

  @override
  void wrapBy(Block block) {}

  @override
  void setNext(Block? block) {
    _next = block;
  }

  @override
  void setPrevious(Block? block) {
    _previous = block;
  }

  @override
  void setSubstackA(Block? block) {
    subA = block;
    if (block == null) {
      subAH = 20;
    }
  }

  @override
  void setSubstackB(Block? block) {
    subB = block;
    if (block == null) {
      subBH = 20;
    }
  }

  @override
  void setSubstackAHeight(double height) {
    _state.setState(() {
      subAH = height;
    });
  }

  @override
  void setSubstackBHeight(double height) {
    // ignore: invalid_use_of_protected_member
    _state.setState(() {
      subBH = height;
    });
  }

  void _removeFromBlock(Block? parent) {
    if (parent == null) return;
    String from = "";
    if (parent.getNext() == this) from = "next";
    if (parent.subA == this) from = "subA";
    if (parent.subB == this) from = "subB";

    switch (from) {
      case "subA":
        parent.setSubstackA(null);
        setPrevious(null);
        break;
      case "subB":
        parent.setSubstackB(null);
        setPrevious(null);
        break;
      case "next":
        parent.setNext(null);
        parent.setPrevious(null);
        break;
    }
  }

  @override
  void remove() {
    if (_parent != null) {
      switch (_parent.runtimeType.toString()) {
        case "EditorPane":
          if (!isFromPallette) {
            final pane = (_parent as EditorPane);
            pane.removeBlock(this);
            _removeFromBlock(_previous);
          }
          break;

        case "BlockArg":
          (_parent as BlockArg).removeBlock(this);

          break;
      }
    }
    _depth = 0;
  }

  void dropOverBlockInType(Block dropArea, String? type) {
    switch (type) {
      case "NEXT":
        nextOf(dropArea);
        break;
      case "PREVIOUS":
        previousOf(dropArea);

        break;
      case "SUBA":
        toSubstackAOf(dropArea);

        break;
      case "SUBB":
        toSubstackBOf(dropArea);

        break;
      case "PARENT":
        wrapBy(dropArea);
        break;
    }
  }

  @override
  void dropTo(Widget? target, String? droptype) {
    remove();
    switch (target.runtimeType.toString()) {
      case "EditorPane":
        _previous?.setNext(null);
        _previous = null;
        (target as EditorPane).addBlock(this);
        break;

      case "Block":
        dropOverBlockInType(target as Block, droptype);
        editor.editorPane.addBlock(this);
        break;

      case "BlockArg":
        (target as BlockArg).addBlock(this);

        break;
    }
  }

  @override
  void dropToArg(BlockArg arg) {
    isInEditor = false;
    x = 0;
    y = 0;
    setParent(arg);
    arg.parentBlock?.recalculateBlock();
  }

  @override
  void recalculateBlock() {
    // ignore: invalid_use_of_protected_member
    _state.setState(() {
      x = x;
      y = y;
      topH = _blockSpec.height;
      width = _blockSpec.width;
      subAH = subAH;
      subBH = subBH;
    });
  }

  @override
  void refreshBlocks() {
    if (_parent != null && _parent is! EditorPane) {
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
      currentblock = currentblock.getNext();
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
        print("traversed Arg");
        if (currentBlock.getParent() is EditorPane) {
          break;
        }
        currentBlock = (currentBlock.getParent() as BlockArg).parentBlock!;
        // currentBlock.recalculateBlock();
      }
    }
    int depth = currentBlock.getDepth();
    while (currentBlock != null) {
      if (currentBlock.getPrevious() != null) {
        final prevSubA = currentBlock.getPrevious()?.subA;
        final prevSubB = currentBlock.getPrevious()?.subB;

        if (currentBlock == prevSubA || currentBlock == prevSubB) {
          depth--;
          if (depth < 0) {
            //break;
          }
          
            print("traversed");
          
        }
        currentBlock = currentBlock._previous!;
      } else {
        break;
      }
    }
    // currentBlock.recalculateBlock();
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
                  child: widget._blockSpec),
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
        widget.topH = widget._blockSpec.height;
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
