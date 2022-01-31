// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/draw_block.dart';

class Base extends StatelessWidget {
  String type;
  Color color = Colors.amber;
  double topH;
  double width;
  double subAH;
  double subBH;
  late DrawBlock _block;

  Base(
      {Key? key,
      this.type = "b",
      this.topH = 20,
      this.width = 80,
      this.color = Colors.amber,
      this.subAH = 20,
      this.subBH = 20})
      : super(key: key) {
    this._block = DrawBlock(
      showEmboss: true,
        blockColor: color,
        type: type,
        width: (width >= 80) ? width : 80,
        topH: (topH >= 20) ? topH : 20,
        substack1Height: (subAH >= 10) ? subAH : 10,
        substack2Height: (subBH >= 10) ? subBH : 10);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: _block.getTotalHeight(),
      child: CustomPaint(painter: _block));
  }
}

/*



// CUSTOM PAINTER CLASS



*/

