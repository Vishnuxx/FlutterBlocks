import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_size.dart';
import 'package:flutter_application_1/Widgets/draw_block.dart';

class BlockArg extends StatefulWidget {
  _BlockArgState _state = _BlockArgState();
   Color? color = Colors.black26;
  Block? _child;
  bool _trigger = false;

  String? type ;
  double? width ;
  double? height;

  BlockArg({
    Key? key,
    this.type = "s",
    this.width = 30,
    this.height = 20,
  }) : super(key: key);

  

  void addChildBlock(Block child) {
    _child = child;
  }

  Block? getChildBlock() {
    return _child;
  }

  bool hasChildBlock() {
    return _child != null;
  }

  //returns true when hit happens
  bool isHitting(Offset coordinate) {
    RenderBox box2 = (key as GlobalKey)
        .currentContext
        ?.findRenderObject() as RenderBox;

    final size2 = Size(30 , 20);
    final pos = box2.localToGlobal(Offset.zero);
    final collide = coordinate.dx > pos.dx &&
        coordinate.dx < (pos.dx + size2.width) &&
        coordinate.dy > pos.dy &&
        coordinate.dy < (pos.dy + size2.height);

    return collide;
  }

  // returns true if the draggable and the arg hooder are of same type
  bool canAcceptBlockOfType(String _type) {
    return type == _type;
  }


// DRBUG
  void trigger() {
    _state.setState(() {
       _trigger = true;
    });
   
  }
//Debug
  void untrigger() {
    _state.setState(() {
      _trigger = false;
    });
  }


  @override
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
        onChange: (size) {
          widget.width = size.width;
        },
        child: Container(
          
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              CustomPaint(
                  painter: DrawBlock(
                      blockColor: (widget._trigger)? Colors.red : widget.color! ,
                      type: _argType(widget.type!),
                      width: widget.width!,
                      topH: widget.height!)),
              Container(
                child: widget._child,
              )
            ],
          ),
        ));

    return wid;
  }
}
