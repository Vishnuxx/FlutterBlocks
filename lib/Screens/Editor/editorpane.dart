import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor_data.dart';
import 'package:flutter_application_1/Widgets/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';
import 'package:flutter_application_1/Widgets/draw_block.dart';
import 'package:flutter_application_1/Widgets/droppable_regions.dart';

// ignore: must_be_immutable
class EditorPane extends StatefulWidget implements DroppableRegion {
  static BuildContext? editorpanecontext;
  final _EditorPaneState _state = _EditorPaneState();
  double? width = 200;
  double? height = 300;
  LogicEditorData? editor;
  List<Block> blocks = [];
  List<Widget> helpers = [];
  ArgIndicator? indicator;
  Widget? currentDropZone; //returns the current drop zone
  String? dropZoneType;

  EditorPane({Key? key, this.editor, this.width, this.height})
      : super(key: key) {
    currentDropZone = this;
  }

  void addHelper(Widget helper) {
    // ignore: invalid_use_of_protected_member
    _state.setState(() {
      helpers.add(helper);
    });
  }

  @override
  void addBlock(Block block) {
    // ignore: invalid_use_of_protected_member
    _state.setState(() {
      block.isInEditor = true;
      blocks.add(block);
    });
  }

  @override
  void removeBlock(Block block) {
    // ignore: invalid_use_of_protected_member
    _state.setState(() {
      blocks.remove(block);
    });
  }

  static bool onEnterInsideEditor(Offset location) {
    final box = (EditorPane.editorpanecontext?.findRenderObject() as RenderBox);
    final size = box.size;
    final pos = box.localToGlobal(Offset.zero);
    final collide = location.dx > pos.dx &&
        location.dx < (pos.dx + size.width) &&
        location.dy > pos.dy &&
        location.dy < (pos.dy + size.height);
    return collide;
  }

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
    final pos = EditorPane.toRelativeOffset(box2.localToGlobal(Offset.zero));
    final collide = coordinate.dx > pos.dx &&
        coordinate.dx < (pos.dx + size2.width) &&
        coordinate.dy > pos.dy &&
        coordinate.dy < (pos.dy + size2.height);

    return collide;
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

// // used to find block args from editor
//   void findBlockArgs(Block draggable, Offset details) {
//     for (Block b in blocks) {
//       if (b.isVisible) {
//         // if (draggable.isArgBlock()) {
//         if (EditorPane.isHitting(b, details)) {
//           BlockArg? arg = b.getArgAtLocation(details);
//           if (arg != null &&
//               draggable.isArgBlock() &&
//               arg.type == draggable.type &&
//               !(arg is EditorPane)) {
//             indicator?.indicateArg(arg); //shows the indicztor
//             currentDropZone = arg;
//             return;
//           } else {
//             indicator?.indicateArg(null); //hides the indictor
//           }
//         }
//       }
//       // }
//     }
//     currentDropZone = this;
//   }

  //triggers and highlights the dropzone for statement blocks
  void findStatementBlockDropZone(Block draggable, Offset location) {
    for (Block b in blocks) {
      if (b.isVisible) {
        if (draggable.isArgBlock()) {
          if (EditorPane.isHitting(b, location)) {
            BlockArg? arg = b.getArgAtLocation(location);
            if (arg != null &&
                draggable.isArgBlock() &&
                arg.type == draggable.type &&
                !(arg is EditorPane)) {
              indicator?.indicateArg(arg); //shows the indicztor
              currentDropZone = arg;
              return;
            } else {
              indicator?.indicateArg(null); //hides the indictor
            }
          }
        } else {
          String? dropType =
              getDropRegionType(b, draggable, location, indicator!);
          switch (dropType) {
            case "NEXT":
              dropZoneType = "NEXT";
              currentDropZone = b;
              //b.indicateNext(indicator!, draggable);
              indicator?.indicateNext(draggable, b);
              return;
            case "PREVIOUS":
              dropZoneType = "PREVIOUS";
              currentDropZone = b;
              //b.indicatePrevious(indicator!, draggable);
              indicator?.indicatePrevious(draggable, b);
              return;
            case "SUBA":
              dropZoneType = "SUBA";
              currentDropZone = b;
              //b.indicateSubA(indicator!);
              indicator?.indicateSubA(b);
              return;
            case "SUBB":
              dropZoneType = "SUBB";
              currentDropZone = b;
              // b.indicateSubB(indicator!);
              indicator?.indicateSubB(b);
              return;
            case "WRAP":
              dropZoneType = "WRAP";
              currentDropZone = b;
              //b.indicateasParent(indicator!, draggable);
              indicator?.indicateasParent(draggable, b);
              return;
            default:
              dropZoneType = null;
              indicator?.set(() {
                indicator?.width = 0;
                indicator?.height = 0;
                indicator?.isVisible = false;
              });
          }
        }
      }
    }
    currentDropZone = this;
    return;
  }

  @override
  // ignore: no_logic_in_create_state
  State<EditorPane> createState() => _state;
}

class _EditorPaneState extends State<EditorPane> {
  @override
  void initState() {
    widget.helpers.add(widget.indicator!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditorPane.editorpanecontext = context;
    return Stack(children: [
      ...widget.blocks,
      ...widget.helpers,
    ]);
  }
}
