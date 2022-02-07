import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';

abstract class BlockMethods {
  void setVisibility(bool visible);
  //parent
  void dropTo(Widget parent);

  void setParent(Widget? parent);
  Widget? getParent();

  //next
  void nextOf(Block block);
  Block? getNext();

  //previous
  void previousOf(Block block);
  Block? getPrevious();

  void toSubstackAOf(Block block);
  void toSubstackBOf(Block block);

  bool isBranchedBlock();//returns true if it has substacks

  BlockArg? getArgAtLocation(Offset location);

  // bool isHitting(Offset location);

  bool isArgBlock();

  double getTotalHeight();
  double substackX();
  double subAY();
  double subBY();

  void indicateNext(ArgIndicator indicator, Block draggable);
  void indicateSubA(ArgIndicator indicator);
  void indicateSubB(ArgIndicator indicator);
  void indicatePrevious(ArgIndicator indicator, Block draggable);
  void indicateasParent(ArgIndicator indicator, Block draggable);

  void setDepth(int depth);
  int getDepth();

  void recalculateBlock();
  void refreshBlocks();
}
