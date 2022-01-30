import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/block_base.dart';
import 'package:flutter_application_1/Widgets/block_methods.dart';

class Block extends StatefulWidget implements BlockMethods {
  _BlockState _state = _BlockState();
  final String type;
  final Color color;
  final bool isDraggable;
  double topH;
  double width;
  double? x = 0;
  double? y = 0;
  double subAH;
  double subBH;

  Block? _parent;
  Block? _next;
  Block? _previous;
  Block? _substackA;

  Block(
      {Key? key,
      this.isDraggable = false,
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
  late double offsetX;
  late double offsetY;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isDraggable);
    if (widget.isDraggable) {
      return Positioned(
        left: widget.x,
        top: widget.y,
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
            child: Base(
              type: widget.type,
              topH: widget.topH,
              width: widget.width,
              color: widget.color,
              subAH: widget.subAH,
              subBH: widget.subBH,
            ),
          ),
          onDragUpdate: (details) {
            widget.x = details.globalPosition.dx - offsetX;
            widget.y = details.globalPosition.dy - offsetY;
          },
          onDragEnd: (details) {
            setState(() {
              widget.x;
              widget.y;
            });
          },
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
