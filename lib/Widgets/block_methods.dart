import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';

abstract class BlockMethods {
  void setVisibility(bool visible);
  //parent
  void parent(Block parent);
  Block? getParent();

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
}
