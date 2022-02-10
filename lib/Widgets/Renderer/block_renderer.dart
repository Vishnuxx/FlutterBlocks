import 'package:flutter_application_1/Widgets/Block/block.dart';
import 'package:flutter_application_1/Widgets/Block/draw_block.dart';

class BlockRenderer {
  //Main method for block refreshing
  void refreshBlocks(Block root) {
    Block? currentBlock = root;
    while (currentBlock != null) {
      currentBlock = currentBlock.getNext();
    }
  }

//  should optimize
  double renderBlock(Block node, double _x, double _y) {
    Block? currenblock = node;//.getAncestorBlock();
    double x = _x;
    double y = _y;
    double totalHeight = 0;

    while (currenblock != null) {
      currenblock.x = x;
      currenblock.y = y;
      switch (currenblock.type) {
        case "e":
          //totalHeight += currenblock.topH;
          if (currenblock.hasChildInSubstackA()) {
            double subAHeight = renderBlock(
                currenblock.subA!,
                currenblock.x! + DrawBlock.SUBSTACK_INSET,
                currenblock.y! + currenblock.topH);
            //totalHeight += subAHeight;
            currenblock.subAH = subAHeight - DrawBlock.EDGE_INSET;
          }
          if (currenblock.hasChildInSubstackB()) {
            double subBHeight = renderBlock(
                currenblock.subB!,
                currenblock.x! + (DrawBlock.SUBSTACK_INSET),
                currenblock.y! + currenblock.topH + currenblock.subAH + 19);
            //totalHeight += subBHeight;
            currenblock.subBH = subBHeight - DrawBlock.EDGE_INSET;
          }
          currenblock.recalculateBlock();
          break;

        case "f":
          //totalHeight += currenblock.topH;
          if (currenblock.hasChildInSubstackA()) {
            double subAHeight = renderBlock(
                currenblock.subA!,
                currenblock.x! + DrawBlock.SUBSTACK_INSET,
                currenblock.y! + currenblock.topH);
            //totalHeight += subAHeight;
            currenblock.subAH = subAHeight - DrawBlock.EDGE_INSET;
            currenblock.recalculateBlock();
          }
      }
      currenblock.isVisible = true;
      currenblock.getPrevious()?.recalculateBlock();
      totalHeight += currenblock.getTotalHeight();
      currenblock.recalculateBlock();
      y = currenblock.nextBlockY();
      currenblock = currenblock.getNext();
    }
    node.recalculateBlock();
    return totalHeight;
  }


  void updateChildren() {

  }
}
