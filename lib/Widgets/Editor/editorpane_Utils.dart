import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/Block/Block/block.dart';
import 'package:flutter_application_1/Widgets/Block/block_args.dart';
import 'package:flutter_application_1/Widgets/Block/draw_block.dart';
import 'package:flutter_application_1/Widgets/Editor/editorpane.dart';
import 'package:flutter_application_1/Widgets/Indicator/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/drag_utils.dart';

class EditorPaneUtils {
  EditorPane editorPane;
  double? width = 200;
  double? height = 300;
  List<Block> blocks = [];
  List<Widget> helpers = [];
  late ArgIndicator indicator;
  Widget? currentDropZone; //returns the current drop zone
  String? dropZoneType;

  EditorPaneUtils(this.editorPane) {
    indicator = ArgIndicator();
  }
  String? getDropRegionType(Block? droppable, Block draggable,
      Offset dragLocation, ArgIndicator indicator) {
    Rect draggingPos = Rect.fromLTWH(dragLocation.dx, dragLocation.dy, 20, 10);
    Rect droppingPos;

    //next block
    droppingPos = Rect.fromLTWH(
        droppable!.x!, droppable.y! + droppable.getTotalHeight(), 30, 20);
    if (draggingPos.overlaps(droppingPos)) {
      return "NEXT";
    }

    //Previous
    droppingPos = Rect.fromLTWH(
        droppable.x!,
        droppable.y! - draggable.getTotalHeight(),
        30,
        draggable.getTotalHeight());
    if (draggingPos.overlaps(droppingPos)) {
      return "PREVIOUS";
    }

    //Wrap
    droppingPos = Rect.fromLTWH(droppable.x! - DrawBlock.SUBSTACK_INSET,
        droppable.y! - draggable.topH, 30, 20);
    if (draggingPos.overlaps(droppingPos)) {
      return "WRAP";
    }

    //suba
    droppingPos =
        Rect.fromLTWH(droppable.substackX(), droppable.subAY(), 30, 20);
    if (draggingPos.overlaps(droppingPos)) {
      return "SUBA";
    }

    //SubB
    droppingPos =
        Rect.fromLTWH(droppable.substackX(), droppable.subBY(), 30, 20);
    if (draggingPos.overlaps(droppingPos)) {
      return "SUBB";
    }

    return null;
  }

  //triggers and highlights the dropzone for statement blocks
  void findStatementBlockDropZone(Block draggable, Offset location) {
    for (Block b in blocks) {
      if (b.isVisible) {
        if (draggable.isArgBlock()) {
          if (DragUtils.isHitting(b, location)) {
            BlockArg? arg = b.getArgAtLocation(location);
            if (arg != null &&
                draggable.isArgBlock() &&
                arg.type == draggable.type &&
                arg is! EditorPane) {
              indicator.indicateArg(arg); //shows the indicztor
              currentDropZone = arg;
              return;
            } else {
              indicator.indicateArg(null); //hides the indictor
            }
          }
        } else {
          switch (getDropRegionType(b, draggable, location, indicator)) {
            case "NEXT":
              dropZoneType = "NEXT";
              currentDropZone = b;
              //b.indicateNext(indicator!, draggable);
              indicator.indicateNext(draggable, b);
              break;
            case "PREVIOUS":
              dropZoneType = "PREVIOUS";
              if (!b.hasPrevious()) {
                currentDropZone = b;
                indicator.indicatePrevious(draggable, b);
              }
              //b.indicatePrevious(indicator!, draggable);

              break;
            case "SUBA":
              dropZoneType = "SUBA";
              currentDropZone = b;
              //b.indicateSubA(indicator!);
              indicator.indicateSubA(b);
              break;
            case "SUBB":
              dropZoneType = "SUBB";
              currentDropZone = b;
              // b.indicateSubB(indicator!);
              indicator.indicateSubB(b);
              break;
            case "WRAP":
              dropZoneType = "WRAP";
              currentDropZone = b;
              //b.indicateasParent(indicator!, draggable);
              indicator.indicateasParent(draggable, b);
              break;
            default:
              dropZoneType = null;
              currentDropZone = editorPane;
              indicator.set(() {
                indicator.width = 0;
                indicator.height = 0;
                indicator.isVisible = false;
              });
              break;
          }
        }
      }
    }
    print("current cropzone : " + currentDropZone.runtimeType.toString());
    print("type : " + dropZoneType.toString());
  }
}
