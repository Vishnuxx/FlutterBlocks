import 'package:flutter_application_1/Widgets/block.dart';

abstract class ArgIndicatorMethods {
  void indicateNext( Block draggable , Block droppable);
  void indicateSubA( Block droppable);
  void indicateSubB(Block droppable);
  void indicatePrevious(Block draggable , Block droppable);
  void indicateasParent(Block draggable , Block droppable);
}