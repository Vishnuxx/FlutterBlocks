// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/draw_block.dart';

// ignore: must_be_immutable
class Base extends StatelessWidget {
  String type;
  Color color = Colors.amber;
  double topH;
  double width;
  double subAH;
  double subBH;
  bool emboss;
  late DrawBlock _block;

  static const double _substackInset = 15;

  Base(
      {Key? key,
      this.type = "b",
      this.topH = 20,
      this.width = 80,
      this.color = Colors.amber,
      this.subAH = 10,
      this.subBH = 10,
      this.emboss = true})
      : super(key: key) {
    _block = DrawBlock(
        showEmboss: true,
        blockColor: color,
        embossIntensity: 0.5,
        type: type,
        width: (width >= 80) ? width : 80,
        topH: (topH >= 20) ? topH : 20,
        substack1Height: (subAH >= 10) ? subAH : 10,
        substack2Height: (subBH >= 10) ? subBH : 10);
  }

  double getTotalHeight() {
    return _block.getTotalHeight() ;
  }

  double substackX() {
    return Base._substackInset;
  }

  double subAY() {
    return _block.topH - DrawBlock.EDGE_INSET;
  }

  double subBY() {
    return topH + subAH + (3 * DrawBlock.EDGE_INSET) + 10;
  }

 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: getTotalHeight(),
        child: CustomPaint(painter: _block));
  }
}

/*



// CUSTOM PAINTER CLASS



*/

