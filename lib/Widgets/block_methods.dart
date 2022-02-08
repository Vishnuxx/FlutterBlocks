import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';

abstract class BlockMethods {
  void setVisibility(bool visible);
  //parent
  void dropTo(Widget parent);

 


  void setParent(Widget? parent);
  void nextOf(Block block);
  void previousOf(Block block);
  void toSubstackAOf(Block block);
  void toSubstackBOf(Block block);
  void wrapBy(Block block);

  Block? getNext();
  Block? getPrevious();
  Widget? getParent();

  bool isArgBlock();
  bool isBranchedBlock(); //returns true if it has substacks

  BlockArg? getArgAtLocation(Offset location);

  // bool isHitting(Offset location);



  double getTotalHeight();
  double substackX();
  double subAY();
  double subBY();



  void setDepth(int depth); //depth increase with increase in branching
  int getDepth();

  void recalculateBlock();
  void refreshBlocks();
}
