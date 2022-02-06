import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';

abstract class BlockMethods {
  void setVisibility(bool visible);
  //parent
  void dropTo(Widget parent);

  Widget? getParent();

  //next
  void next(Block next);
  Block? getNext();

  //previous
  void previous(Block previus);
  Block? getPrevious();

  void substackA(Block subA);
  Block? getSubstackA();

  void substackB(Block subB);
  Block? getSubstackB();

  BlockArg? getArgAtLocation(Offset location);

  // bool isHitting(Offset location);

  bool isArgBlock();

  double getTotalHeight();
  double substackX();
  double subAY();
  double subBY();

  void indicateNext(ArgIndicator indicator);
  void indicateSubA(ArgIndicator indicator);
  void indicateSubB(ArgIndicator indicator);
  void indicatePrevious(ArgIndicator indicator);
  void indicateasParent(ArgIndicator indicator);
}
