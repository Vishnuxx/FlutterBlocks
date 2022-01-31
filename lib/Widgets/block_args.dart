import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_size.dart';
import 'package:flutter_application_1/Widgets/draw_block.dart';

class BlockArg extends StatelessWidget {
  String? type = "r";
  double? width = 30;
  double? height = 20;
  Color? color = Colors.black26;
  Block? _child;

  BlockArg({Key? key, this.type, this.width = 30, this.height = 20,})
      : super(key: key);

  void addChild(Block child) {
    _child = child;
  }

  Block? getChild() {
    return _child;
  }



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
    Widget widget = BlockSize(
        onChange: (size) {
          width = size.width;
        },
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              CustomPaint(
                  painter: DrawBlock(
                      blockColor: color!,
                      type: _argType(type!),
                      width: width!,
                      topH: height!)),
              Container(
                child: _child,
              )
            ],
          ),
        ));

    return widget;
  }
}
