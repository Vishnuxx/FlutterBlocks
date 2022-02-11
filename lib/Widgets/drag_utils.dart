import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/Editor/editorpane.dart';

class DragUtils {
   static Offset toRelativeOffset(Offset offset) {
    final mOff = (EditorPane.editorpanecontext?.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero);
    return offset.translate(-mOff.dx, -mOff.dy);
  }

  //returns true when hit happens
  static bool isHitting(Widget view, Offset coordinate) {
    RenderBox box2 =
        (view.key as GlobalKey).currentContext?.findRenderObject() as RenderBox;

    final size2 = box2.size;
    final pos = DragUtils.toRelativeOffset(box2.localToGlobal(Offset.zero));
    final collide = coordinate.dx > pos.dx &&
        coordinate.dx < (pos.dx + size2.width) &&
        coordinate.dy > pos.dy &&
        coordinate.dy < (pos.dy + size2.height);

    return collide;
  }
}