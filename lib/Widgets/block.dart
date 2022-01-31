
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor_state.dart';
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
  Function? onTap;
  Function? onDragStart;
  Function? onDragMove;
  Function? onDragEnd;

  bool _isVisible = true;
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

  LogicEditorState editor;

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
      this.subBH = 20})
      : super(key: key);

  void update() {
    _state.setState(() {
      x = x;
      y = y;
      topH = topH;
      width = width;
      subAH = subAH;
      subBH = subBH;
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
}

class _BlockState extends State<Block> {
  late Base _base;
  late double offsetX = 0;
  late double offsetY = 0;
  late Widget blockSpecs;
  var k = GlobalKey();
  @override
  void initState() {
    super.initState();
   
    blockSpecs = BlockSize(
      onChange: (size) {
        setState(() {
           widget.topH = size.height;
           widget.width = size.width;
        });
      },
      child: BlockSpec(
        key: k,
        args: widget.specs,
      ),
    );
  }

 
  @override
  Widget build(BuildContext context) {
   
    if (widget.isDraggable) {
      return Positioned(
        left: widget.x,
        top: widget.y,
        child: Visibility(
          visible: widget._isVisible,
          maintainState: true,
          child: Draggable(
            feedback: Base(
              type: widget.type,
              topH: widget.topH,
              width: widget.width,
              color: widget.color,
              subAH: widget.subAH,
              subBH: widget.subBH,
            ),
            child: GestureDetector(
              onTapDown: (details) {
                offsetX = details.localPosition.dx;
                offsetY = details.localPosition.dy;
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
                      blockSpecs,
                    ],
                  ),
                  
                ],
              ),
            ),
            onDragStarted: () {
              if (!widget.isFromPallette) {
                widget.editor.blocks.remove(widget);
                setState(() {
                  widget.editor.editorPane.addBlockToStage(widget);
                  widget._isVisible = false;
                  widget.width;
                  if(this.mounted) {
                     
                  }
                });
              }
            },
            onDragUpdate: (details) {
              widget.x = details.globalPosition.dx - offsetX;
              widget.y = details.globalPosition.dy - offsetY;
            },
            onDragEnd: (details) {
              setState(() {
                widget._isVisible = true;
                widget.x;
                widget.y;
              });
            },
          ),
        ),
      );
    } else {
      return Base(
        type: widget.type,
        topH: widget.topH,
        width: widget.width,
        color: widget.color,
        subAH: widget.subAH,
        subBH: widget.subBH,
      );
    }
  }
}
