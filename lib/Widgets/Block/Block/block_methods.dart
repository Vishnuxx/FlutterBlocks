import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/Indicator/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/Block/Block/block.dart';
import 'package:flutter_application_1/Widgets/Block/block_args.dart';

abstract class BlockMethods {
  void setVisibility(bool visible);
  //parent
  void dropTo(Widget parent, String dropType);

  void remove();
  void showChildren(bool show, double _x, double _y);

  //Block getAncestorBlock();

  void setParent(Widget? parent);
  void nextOf(Block block);
  void previousOf(Block block);
  void toSubstackAOf(Block block);
  void toSubstackBOf(Block block);
  void wrapBy(Block block);

  void setNext(Block block);
  void setPrevious(Block block);
  void setSubstackA(Block block);
  void setSubstackB(Block block);

  Block? getNext();
  Block? getPrevious();
  Widget? getParent();
  Block getLastBlock();
  Block getAncestorBlock();

  bool isArgBlock();
  bool isBranchedBlock(); //returns true if it has substacks
  bool hasChildInSubstackA();
  bool hasChildInSubstackB();
  bool hasPrevious();
  bool hasNext();

  BlockArg? getArgAtLocation(Offset location);

  // bool isHitting(Offset location);

  double getTotalHeight();
  double nextBlockY();
  double substackX();
  double subAY();
  double subBY();

  void setDepth(int depth); //depth increase with increase in branching
  int getDepth();

  void recalculateBlock();
  void refreshBlocks();
}
