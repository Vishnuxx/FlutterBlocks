import 'package:flutter_application_1/Widgets/block.dart';

abstract class BlockMethods {
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
}
