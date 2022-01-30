// ignore_for_file: avoid_print


import 'package:flutter/material.dart';


class Base extends StatelessWidget {
  String type;
  Color color = Colors.amber;
  double topH;
  double width;
  double subAH ;
  double subBH ;
  late DrawBlock _block;

  Base(
      {Key? key,
      this.type = "b",
      this.topH = 20,
      this.width = 80,
      this.color = Colors.amber,
      this.subAH = 20,
      this.subBH = 20
}): super(key: key) {

  this._block = DrawBlock(
                blockColor: color,
                type: type,
                width: (width >= 80) ? width : 80,
                topH: (topH >= 20) ? topH : 20,
                substack1Height: (subAH >= 10) ? subAH : 10,
                substack2Height: (subBH >= 10) ? subBH : 10);
}

  @override
  Widget build(BuildContext context) {
    return Container(
      height : _block.getTotalHeight(),
      width: _block.getWidth(),
      child: CustomPaint(
          painter: _block ),
    );
  }
}

/*



// CUSTOM PAINTER CLASS



*/

class DrawBlock extends CustomPainter {
  // ignore: non_constant_identifier_names
  static double EDGE_INSET = 3; //corner cutting
  // ignore: non_constant_identifier_names
  static double TOP_OUTSET_LENGTH = 15;
  // ignore: non_constant_identifier_names
  static double SUBSTACK_INSET = 15;
  // ignore: non_constant_identifier_names
  static double NOTCH_LENGTH = 15;

  // ignore: non_constant_identifier_names
  double MIN_WIDTH = 10;
  // ignore: non_constant_identifier_names
  double MIN_HEIGHT = 16;

  Color blockColor ;
  String? type = "s";

  Paint mPaint = Paint();

  Paint embossL = Paint();
  Paint embossD = Paint();

  double embossIntensity = 0.5;

  double width;
  double topH ;

  //substack
  double substack1Height;
  double substack2Height = 20;

  DrawBlock(
      { 
        
    this.blockColor = Colors.amber,
    this.type ,
    this.width  = 10 ,
    this.topH = 10,
    this.substack1Height  = 20,
    this.substack2Height = 20,
      
      }) {

    MIN_WIDTH = (4 * EDGE_INSET) + TOP_OUTSET_LENGTH + NOTCH_LENGTH;
    MIN_HEIGHT = 2 * EDGE_INSET + 10;

    mPaint.color = blockColor;
    mPaint.style = PaintingStyle.fill;
    mPaint.isAntiAlias = true;

    embossL.color = Colors.white.withOpacity(0.5);
    embossL.strokeWidth = 2 * embossIntensity;
    embossL.style = PaintingStyle.stroke;
    embossL.isAntiAlias = true;
    embossL.strokeCap = StrokeCap.round;

    embossD.color = Colors.black.withOpacity(0.3);
    embossD.strokeWidth = 2 * embossIntensity;
    embossD.style = PaintingStyle.stroke;
    embossD.isAntiAlias = true;
    embossL.strokeCap = StrokeCap.round;
  }

  set setSubStack1Height(double value) => substack1Height = value;
  set setSubStack2Height(double value) => substack2Height = value;

  double getSub1H() => substack1Height;
  double getSub2H() => substack2Height;

  double getTopH() => topH;
  double getWidth() => width;

  double getTotalHeight() {
    if (type == "e") {
      return 7 * EDGE_INSET + 20 + topH + substack1Height + substack2Height;
    } else if (type == "f") {
      return 5 * EDGE_INSET + 10 + topH + substack1Height;
    } else if (type == "r") {
      return 3 * EDGE_INSET + topH;
    } else if (type == "b" || type == "s" || type == "n") {
      return topH;
    } else if (type == "x") {
      return 4 * EDGE_INSET + topH;
    } else {
      return topH;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case "s": //string
        drawString(canvas);
        drawStringEmboss(canvas);
        break;
      case "b": //boolean
        drawBoolean(canvas);
        drawBooleanEmboss(canvas);
        break;
      case "n": //number
        drawNumber(canvas);
        drawNumberEmboss(canvas);
        break;
      case "e": //if-else
        drawTop(canvas);
        drawRightAndBottom(canvas);
        drawSubstackA(canvas);
        drawSubstackB(canvas);
        drawTopEmboss(canvas);

        drawTopEmboss(canvas);
        drawRightAndBottomEmboss(canvas);
        drawSubstackAEmboss(canvas);
        drawSubstackBEmboss(canvas);

        break;
      case "f": //if
        drawTop(canvas);
        drawRightAndBottom(canvas);
        drawSubstackA(canvas);
        drawTopEmboss(canvas);
        drawRightAndBottomEmboss(canvas);
        drawSubstackAEmboss(canvas);
        break;
      case "r": //regular
        drawTop(canvas);
        drawRightAndBottom(canvas);
        drawTopEmboss(canvas);
        drawRightAndBottomEmboss(canvas);
        break;
      case "x": //ending
        drawTop(canvas);
        drawRightAndBottom(canvas);
        break;
      default: //regular
        drawString(canvas);
        drawStringEmboss(canvas);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  Offset p(double x, double y) {
    return Offset(x, y);
  }

  // draw Blocks

  void drawString(Canvas canvas) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(width, 0);
    path.lineTo(width, topH);
    path.lineTo(0, topH);
    canvas.drawPath(path, mPaint);
  }

  void drawBoolean(Canvas canvas) {
    Path path = Path();
    double halfHeight = topH / 2;
    path.moveTo(0, halfHeight);
    path.lineTo(halfHeight, 0);
    path.lineTo(width - halfHeight, 0);
    path.lineTo(width, halfHeight);
    path.lineTo(width - halfHeight, topH);
    path.lineTo(halfHeight, topH);
    canvas.drawPath(path, mPaint);
  }

  void drawNumber(Canvas canvas) {
    Path path = Path();
    double halfHeight = topH / 2;
    path.moveTo(halfHeight, halfHeight);
    path.arcTo(
        Rect.fromCenter(
            center: p(halfHeight, halfHeight), width: topH, height: topH),
        1.56,
        3.15,
        true);
    path.lineTo(width - halfHeight, 0);
    path.arcTo(
        Rect.fromCenter(
            center: p(width - halfHeight, halfHeight),
            width: topH,
            height: topH),
        -1.56,
        3.15,
        true);
    path.lineTo(halfHeight, topH);
    canvas.drawPath(path, mPaint);
  }

  void drawTop(Canvas canvas) {
    Path path = Path();
    path.moveTo(0, EDGE_INSET);
    path.lineTo(EDGE_INSET, 0);
    path.lineTo(EDGE_INSET + TOP_OUTSET_LENGTH, 0);
    double leftX = EDGE_INSET + TOP_OUTSET_LENGTH + EDGE_INSET;
    path.lineTo(leftX, EDGE_INSET);
    path.lineTo(leftX + NOTCH_LENGTH, EDGE_INSET);
    path.lineTo(leftX + NOTCH_LENGTH + EDGE_INSET, 0);
    path.lineTo(width - EDGE_INSET, 0);
    path.lineTo(width, EDGE_INSET);
    canvas.drawPath(path, mPaint);
  }

  void drawRightAndBottom(Canvas canvas) {
    Path path = Path();
    path.moveTo(width, EDGE_INSET);
    path.lineTo(width, topH - EDGE_INSET);
    path.lineTo(width - EDGE_INSET, topH);
    if (type == "r") {
      double leftX =
          EDGE_INSET + TOP_OUTSET_LENGTH + (2 * EDGE_INSET) + NOTCH_LENGTH;
      path.lineTo(leftX, topH);
      //Notch dimensions
      path.lineTo(leftX - EDGE_INSET, topH + EDGE_INSET);
      path.lineTo(leftX - EDGE_INSET - NOTCH_LENGTH, topH + EDGE_INSET);
      path.lineTo(EDGE_INSET + TOP_OUTSET_LENGTH, topH);
      //outsetlength
      path.lineTo(EDGE_INSET, topH);
      path.lineTo(0, topH - EDGE_INSET);
      path.lineTo(0, EDGE_INSET);
    } else if (type == "e" || type == "f") {
      double leftX = SUBSTACK_INSET + TOP_OUTSET_LENGTH + EDGE_INSET;
      path.lineTo(leftX + (2 * EDGE_INSET) + NOTCH_LENGTH, topH);
      path.lineTo(leftX + (EDGE_INSET) + NOTCH_LENGTH, topH + EDGE_INSET);
      path.lineTo(leftX + (EDGE_INSET), topH + EDGE_INSET);
      path.lineTo(leftX, topH);
      path.lineTo(leftX - TOP_OUTSET_LENGTH, topH);
      path.lineTo(SUBSTACK_INSET, topH + EDGE_INSET);
      path.lineTo(0, topH + EDGE_INSET);
      path.lineTo(0, EDGE_INSET);
    } else if (type == "x") {
      path.lineTo(EDGE_INSET, topH);
      path.lineTo(0, topH - EDGE_INSET);
      path.lineTo(0, EDGE_INSET);
    }
    canvas.drawPath(path, mPaint);
  }

  void drawSubstackA(Canvas canvas) {
    Path path = Path();
    double leftX = SUBSTACK_INSET + TOP_OUTSET_LENGTH;
    path.moveTo(SUBSTACK_INSET, topH + EDGE_INSET);
    path.lineTo(SUBSTACK_INSET, topH + substack1Height); //substack hei
    path.lineTo(
        SUBSTACK_INSET + EDGE_INSET, topH + substack1Height + EDGE_INSET);
    path.lineTo(leftX + EDGE_INSET, topH + substack1Height + EDGE_INSET);
    path.lineTo(
        leftX + 2 * EDGE_INSET, topH + substack1Height + (2 * EDGE_INSET));

    leftX = leftX + 2 * EDGE_INSET;

    path.lineTo(
        leftX + NOTCH_LENGTH, topH + substack1Height + (2 * EDGE_INSET));
    path.lineTo(
        leftX + NOTCH_LENGTH + EDGE_INSET, topH + substack1Height + EDGE_INSET);
    path.lineTo(width - EDGE_INSET, topH + substack1Height + EDGE_INSET);
    path.lineTo(width, topH + substack1Height + (2 * EDGE_INSET));
    path.lineTo(width, topH + substack1Height + (2 * EDGE_INSET) + 10);
    path.lineTo(
        width - EDGE_INSET, topH + substack1Height + (3 * EDGE_INSET) + 10);

    if (type == "e") {
      leftX = SUBSTACK_INSET + TOP_OUTSET_LENGTH;
      path.lineTo(leftX + 3 * EDGE_INSET + NOTCH_LENGTH,
          topH + substack1Height + (3 * EDGE_INSET) + 10);
      path.lineTo(leftX + 2 * EDGE_INSET + NOTCH_LENGTH,
          topH + substack1Height + (4 * EDGE_INSET) + 10);
      path.lineTo(leftX + 2 * EDGE_INSET,
          topH + substack1Height + (4 * EDGE_INSET) + 10);
      path.lineTo(
          leftX + EDGE_INSET, topH + substack1Height + (3 * EDGE_INSET) + 10);

      path.lineTo(SUBSTACK_INSET + EDGE_INSET,
          topH + substack1Height + (3 * EDGE_INSET) + 10);
      path.lineTo(
          SUBSTACK_INSET, topH + substack1Height + (4 * EDGE_INSET) + 10);
      path.lineTo(0, topH + substack1Height + (4 * EDGE_INSET) + 10);
      path.lineTo(0, topH);
    } else if (type == "f") {
      leftX = EDGE_INSET + TOP_OUTSET_LENGTH + (2 * EDGE_INSET) + NOTCH_LENGTH;
      path.lineTo(leftX, topH + substack1Height + (3 * EDGE_INSET) + 10);
      path.lineTo(
          leftX - EDGE_INSET, topH + substack1Height + (4 * EDGE_INSET) + 10);
      path.lineTo(leftX - EDGE_INSET - NOTCH_LENGTH,
          topH + substack1Height + (4 * EDGE_INSET) + 10);
      path.lineTo(leftX - (2 * EDGE_INSET) - NOTCH_LENGTH,
          topH + substack1Height + (3 * EDGE_INSET) + 10);
      path.lineTo(EDGE_INSET, topH + substack1Height + (3 * EDGE_INSET) + 10);
      path.lineTo(0, topH + substack1Height + (2 * EDGE_INSET) + 10);
      path.lineTo(0, topH);
    }

    canvas.drawPath(path, mPaint);
  }

  void drawSubstackB(Canvas canvas) {
    Path path = Path();
    double leftX = TOP_OUTSET_LENGTH + SUBSTACK_INSET;
    double subBH = topH + substack2Height + (3 * EDGE_INSET) + 10;
    path.moveTo(SUBSTACK_INSET, subBH);
    path.lineTo(SUBSTACK_INSET, subBH + substack2Height);
    path.lineTo(
        SUBSTACK_INSET + EDGE_INSET, subBH + substack2Height + EDGE_INSET);
    path.lineTo(leftX + EDGE_INSET, subBH + substack2Height + EDGE_INSET);
    path.lineTo(
        leftX + 2 * EDGE_INSET, subBH + substack2Height + (2 * EDGE_INSET));
    path.lineTo(leftX + 2 * EDGE_INSET + NOTCH_LENGTH,
        subBH + substack2Height + (2 * EDGE_INSET));
    path.lineTo(leftX + (3 * EDGE_INSET) + NOTCH_LENGTH,
        subBH + substack2Height + EDGE_INSET);
    path.lineTo(width - EDGE_INSET, subBH + substack2Height + EDGE_INSET);
    path.lineTo(width, subBH + substack2Height + 2 * EDGE_INSET);

    //Bottom
    path.lineTo(width, subBH + substack2Height + (2 * EDGE_INSET) + 10);
    path.lineTo(
        width - EDGE_INSET, subBH + substack2Height + (3 * EDGE_INSET) + 10);
    path.lineTo(leftX + 2 * EDGE_INSET,
        subBH + substack2Height + (3 * EDGE_INSET) + 10);
    path.lineTo(
        leftX + EDGE_INSET, subBH + substack2Height + (4 * EDGE_INSET) + 10);
    path.lineTo(SUBSTACK_INSET + EDGE_INSET,
        subBH + substack2Height + (4 * EDGE_INSET) + 10);
    path.lineTo(
        SUBSTACK_INSET, subBH + substack2Height + (3 * EDGE_INSET) + 10);
    path.lineTo(EDGE_INSET, subBH + substack2Height + (3 * EDGE_INSET) + 10);
    path.lineTo(0, subBH + substack2Height + (2 * EDGE_INSET) + 10);
    path.lineTo(0, subBH);

    canvas.drawPath(path, mPaint);
  }

  //Draw Emboss effect
  void drawStringEmboss(Canvas canvas) {
    Path path1 = Path();
    path1.moveTo(0 + embossIntensity, topH);
    path1.lineTo(0 + embossIntensity, 0 + embossIntensity);
    path1.lineTo(width, 0 + embossIntensity);
    canvas.drawPath(path1, embossL);
    Path path2 = Path();
    path2.moveTo(width - embossIntensity, 0);
    path2.lineTo(width - embossIntensity, topH - embossIntensity);
    path2.lineTo(0, topH - embossIntensity);
    canvas.drawPath(path2, embossD);
  }

  void drawBooleanEmboss(Canvas canvas) {
    Path path1 = Path();
    double halfHeight = topH / 2;
    path1.moveTo(0 + embossIntensity, halfHeight + embossIntensity);
    path1.lineTo(halfHeight + embossIntensity, embossIntensity);
    path1.lineTo(width - halfHeight, embossIntensity);
    canvas.drawPath(path1, embossL);
    Path path2 = Path();
    path2.moveTo(width - embossIntensity, halfHeight);
    path2.lineTo(
        (width - halfHeight) - embossIntensity, topH - embossIntensity);
    path2.lineTo(halfHeight + embossIntensity, topH - embossIntensity);
    canvas.drawPath(path2, embossD);
  }

  void drawNumberEmboss(Canvas canvas) {
    Path path1 = Path();
    double halfHeight = topH / 2;
    path1.moveTo(halfHeight + embossIntensity, halfHeight + embossIntensity);
    path1.arcTo(
        Rect.fromCenter(
            center:
                p(halfHeight + embossIntensity, halfHeight + embossIntensity),
            width: topH + embossIntensity,
            height: topH + embossIntensity),
        2.6, //1.56,
        2, //3.15,
        true);
    path1.lineTo(width - halfHeight + embossIntensity, 0 + embossIntensity);
    canvas.drawPath(path1, embossL);

    Path path2 = Path();
    path2.arcTo(
        Rect.fromCenter(
            center: p((width - halfHeight) - embossIntensity,
                halfHeight - embossIntensity),
            width: topH,
            height: topH),
        0.4, //-1.56,
        1, // 3.15,
        true);
    path2.lineTo(halfHeight - embossIntensity, topH - embossIntensity);
    canvas.drawPath(path2, embossD);
  }

  void drawTopEmboss(Canvas canvas) {
    Path path1 = Path();
    path1.moveTo(0, EDGE_INSET + embossIntensity);
    path1.lineTo(EDGE_INSET, 0 + embossIntensity);
    path1.lineTo(
        EDGE_INSET + TOP_OUTSET_LENGTH + embossIntensity, 0 + embossIntensity);
    double leftX = EDGE_INSET + TOP_OUTSET_LENGTH + EDGE_INSET;
    path1.lineTo(leftX + embossIntensity, EDGE_INSET + embossIntensity);

    path1.lineTo(
        leftX + NOTCH_LENGTH + embossIntensity, EDGE_INSET + embossIntensity);
    path1.lineTo(leftX + NOTCH_LENGTH + EDGE_INSET, 0 + embossIntensity);
    path1.lineTo(width - EDGE_INSET - embossIntensity, 0 + embossIntensity);
    path1.lineTo(width - embossIntensity, EDGE_INSET + embossIntensity);
    canvas.drawPath(path1, embossL);
  }

  void drawRightAndBottomEmboss(Canvas canvas) {
    Path path = Path();
    path.moveTo(width - embossIntensity, EDGE_INSET - embossIntensity);
    path.lineTo(width - embossIntensity, topH - EDGE_INSET - embossIntensity);
    path.lineTo(width - EDGE_INSET - embossIntensity, topH - embossIntensity);
    if (type == "r") {
      double leftX =
          EDGE_INSET + TOP_OUTSET_LENGTH + (2 * EDGE_INSET) + NOTCH_LENGTH;
      path.lineTo(leftX - embossIntensity, topH - embossIntensity);
      //Notch dimensions
      path.lineTo(leftX - EDGE_INSET - embossIntensity,
          topH + EDGE_INSET - embossIntensity);
      path.lineTo(leftX - EDGE_INSET - NOTCH_LENGTH - embossIntensity,
          topH + EDGE_INSET - embossIntensity);
      path.lineTo(EDGE_INSET + TOP_OUTSET_LENGTH - embossIntensity,
          topH - embossIntensity);
      //outsetlength
      path.lineTo(EDGE_INSET + embossIntensity, topH - embossIntensity);
      path.lineTo(0 + embossIntensity, topH - EDGE_INSET - embossIntensity);
      path.lineTo(0 + embossIntensity, EDGE_INSET - embossIntensity);
    } else if (type == "e" || type == "f") {
      double leftX = SUBSTACK_INSET + TOP_OUTSET_LENGTH + EDGE_INSET;
      path.lineTo(leftX + (2 * EDGE_INSET) + NOTCH_LENGTH - embossIntensity,
          topH - embossIntensity);
      path.lineTo(leftX + (EDGE_INSET) + NOTCH_LENGTH - embossIntensity,
          topH + EDGE_INSET - embossIntensity);
      path.lineTo(leftX + (EDGE_INSET) - embossIntensity,
          topH + EDGE_INSET - embossIntensity);
      path.lineTo(leftX - embossIntensity, topH - embossIntensity);
      path.lineTo(
          leftX - TOP_OUTSET_LENGTH - embossIntensity, topH - embossIntensity);
      path.lineTo(SUBSTACK_INSET - embossIntensity,
          topH + EDGE_INSET - embossIntensity);
      // path.lineTo(0 - embossIntensity, topH + EDGE_INSET - embossIntensity);
      // path.lineTo(0 - embossIntensity, EDGE_INSET - embossIntensity);
    } else if (type == "x") {
      path.lineTo(EDGE_INSET - embossIntensity, topH - embossIntensity);
      path.lineTo(0 - embossIntensity, topH - EDGE_INSET - embossIntensity);
      path.lineTo(0 - embossIntensity, EDGE_INSET - embossIntensity);
    }
    canvas.drawPath(path, embossD);
  }

  void drawSubstackAEmboss(Canvas canvas) {
    Path path1 = Path();

    double leftX = SUBSTACK_INSET + TOP_OUTSET_LENGTH;
    path1.moveTo(SUBSTACK_INSET - embossIntensity, topH + EDGE_INSET);
    path1.lineTo(SUBSTACK_INSET - embossIntensity,
        topH + substack1Height); //substack hei
    path1.lineTo(SUBSTACK_INSET + EDGE_INSET - embossIntensity,
        topH + substack1Height + EDGE_INSET);
    canvas.drawPath(path1, embossD);

    Path path2 = Path();
    path2.moveTo(leftX + EDGE_INSET,
        topH + substack1Height + EDGE_INSET + embossIntensity);

    path2.lineTo(leftX + 2 * EDGE_INSET,
        topH + substack1Height + (2 * EDGE_INSET) + embossIntensity);

    leftX = leftX + 2 * EDGE_INSET;

    path2.lineTo(leftX + NOTCH_LENGTH,
        topH + substack1Height + (2 * EDGE_INSET) + embossIntensity);
    path2.lineTo(leftX + NOTCH_LENGTH + EDGE_INSET,
        topH + substack1Height + EDGE_INSET + embossIntensity);
    path2.lineTo(width - EDGE_INSET,
        topH + substack1Height + EDGE_INSET + embossIntensity);
    path2.lineTo(
        width, topH + substack1Height + (2 * EDGE_INSET) + embossIntensity);
    canvas.drawPath(path2, embossL);

    path1.moveTo(
        width - embossIntensity, topH + substack1Height + (2 * EDGE_INSET));
    path1.lineTo(width - embossIntensity,
        topH + substack1Height + (2 * EDGE_INSET) + 10);
    path1.lineTo(width - EDGE_INSET - embossIntensity,
        topH + substack1Height + (3 * EDGE_INSET) - embossIntensity + 10);
    canvas.drawPath(path1, embossD);

    if (type == "e") {
      leftX = SUBSTACK_INSET + TOP_OUTSET_LENGTH;
      path1.lineTo(leftX + 3 * EDGE_INSET + NOTCH_LENGTH - embossIntensity,
          topH + substack1Height + (3 * EDGE_INSET) - embossIntensity + 10);
      path1.lineTo(leftX + 2 * EDGE_INSET + NOTCH_LENGTH - embossIntensity,
          topH + substack1Height + (4 * EDGE_INSET) - embossIntensity + 10);
      path1.lineTo(leftX + 2 * EDGE_INSET - embossIntensity,
          topH + substack1Height + (4 * EDGE_INSET) - embossIntensity + 10);
      path1.lineTo(leftX + EDGE_INSET - embossIntensity,
          topH + substack1Height + (3 * EDGE_INSET) - embossIntensity + 10);

      path1.lineTo(SUBSTACK_INSET + EDGE_INSET - embossIntensity,
          topH + substack1Height + (3 * EDGE_INSET) - embossIntensity + 10);
      path1.lineTo(SUBSTACK_INSET - embossIntensity,
          topH + substack1Height + (4 * EDGE_INSET) - embossIntensity + 10);
    } else if (type == "f") {
      leftX = EDGE_INSET + TOP_OUTSET_LENGTH + (2 * EDGE_INSET) + NOTCH_LENGTH;
      path1.lineTo(leftX - embossIntensity,
          topH + substack1Height + (3 * EDGE_INSET) - embossIntensity + 10);
      path1.lineTo(leftX - EDGE_INSET - embossIntensity,
          topH + substack1Height + (4 * EDGE_INSET) - embossIntensity + 10);
      path1.lineTo(leftX - EDGE_INSET - NOTCH_LENGTH - embossIntensity,
          topH + substack1Height + (4 * EDGE_INSET) - embossIntensity + 10);
      path1.lineTo(leftX - (2 * EDGE_INSET) - NOTCH_LENGTH - embossIntensity,
          topH + substack1Height + (3 * EDGE_INSET) - embossIntensity + 10);
      path1.lineTo(EDGE_INSET + embossIntensity,
          topH + substack1Height + (3 * EDGE_INSET) - embossIntensity + 10);
      path1.lineTo(0 + embossIntensity,
          topH + substack1Height + (2 * EDGE_INSET) - embossIntensity + 10);
      path1.lineTo(0 + embossIntensity, EDGE_INSET + embossIntensity);
    }

    canvas.drawPath(path1, embossD);
  }

  void drawSubstackBEmboss(Canvas canvas) {
    Path path = Path();
    Path path1 = Path();
    double leftX = TOP_OUTSET_LENGTH + SUBSTACK_INSET;
    double subBH = topH + substack2Height + (3 * EDGE_INSET) + 10;
    path1.moveTo(
        SUBSTACK_INSET + embossIntensity, EDGE_INSET + subBH + embossIntensity);
    path1.lineTo(SUBSTACK_INSET + embossIntensity,
        subBH + substack2Height + embossIntensity);

    path1.lineTo(SUBSTACK_INSET + EDGE_INSET + embossIntensity,
        subBH + substack2Height + EDGE_INSET + embossIntensity);
    canvas.drawPath(path1, embossD);

    path.moveTo(SUBSTACK_INSET + EDGE_INSET + embossIntensity,
        subBH + substack2Height + EDGE_INSET + embossIntensity);
    path.lineTo(leftX + EDGE_INSET + embossIntensity,
        subBH + substack2Height + EDGE_INSET + embossIntensity);
    path.lineTo(leftX + 2 * EDGE_INSET + embossIntensity,
        subBH + substack2Height + (2 * EDGE_INSET) + embossIntensity);
    path.lineTo(leftX + 2 * EDGE_INSET + NOTCH_LENGTH + embossIntensity,
        subBH + substack2Height + (2 * EDGE_INSET) + embossIntensity);
    path.lineTo(leftX + (3 * EDGE_INSET) + NOTCH_LENGTH + embossIntensity,
        subBH + substack2Height + EDGE_INSET + embossIntensity);
    path.lineTo(width - EDGE_INSET,
        subBH + substack2Height + EDGE_INSET + embossIntensity);
    path.lineTo(
        width, subBH + substack2Height + 2 * EDGE_INSET + embossIntensity);

    canvas.drawPath(path, embossL);

    Path path2 = Path();
    //Bottom
    path2.moveTo(width - embossIntensity,
        subBH + substack2Height + 2 * EDGE_INSET - embossIntensity);

    path2.lineTo(width - embossIntensity,
        subBH + substack2Height + (2 * EDGE_INSET) - embossIntensity + 10);
    path2.lineTo(width - EDGE_INSET - embossIntensity,
        subBH + substack2Height + (3 * EDGE_INSET) - embossIntensity + 10);
    path2.lineTo(leftX + 2 * EDGE_INSET - embossIntensity,
        subBH + substack2Height + (3 * EDGE_INSET) - embossIntensity + 10);
    path2.lineTo(leftX + EDGE_INSET - embossIntensity,
        subBH + substack2Height + (4 * EDGE_INSET) - embossIntensity + 10);
    path2.lineTo(SUBSTACK_INSET + EDGE_INSET - embossIntensity,
        subBH + substack2Height + (4 * EDGE_INSET) - embossIntensity + 10);
    path2.lineTo(SUBSTACK_INSET - embossIntensity,
        subBH + substack2Height + (3 * EDGE_INSET) - embossIntensity + 10);
    path2.lineTo(EDGE_INSET + embossIntensity,
        subBH + substack2Height + (3 * EDGE_INSET) - embossIntensity + 10);
    path2.lineTo(0 + embossIntensity,
        subBH + substack2Height + (2 * EDGE_INSET) - embossIntensity + 10);

    canvas.drawPath(path2, embossD);

    path.moveTo(0 + embossIntensity,
        subBH + substack2Height + (2 * EDGE_INSET) - embossIntensity + 10);
    path.lineTo(0 + embossIntensity, EDGE_INSET + embossIntensity);
    canvas.drawPath(path, embossL);
  }
}
