import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/editorpane.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor_data.dart';
import 'package:flutter_application_1/Widgets/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/block.dart';

class LogicEditor extends StatelessWidget {
  late LogicEditorData editorData;

  LogicEditor({Key? key}) : super(key: key) {
    editorData = LogicEditorData();
    editorData.editorPane = EditorPane(
      editor: editorData,
    );
    editorData.indicator = ArgIndicator(
      key: GlobalKey(),
    );
  }

  void dragStart(Block draggingBlock) {
    if (draggingBlock.isFromPallette && !draggingBlock.isArgBlock()) {
      // from pallette but not arg
    } else if (draggingBlock.isFromPallette && draggingBlock.isArgBlock()) {
      // from pallette and it is arg
    } else if (!draggingBlock.isFromPallette && !draggingBlock.isArgBlock()) {
      //not from pallette and not arg
    } else if (!draggingBlock.isFromPallette && draggingBlock.isArgBlock()) {
      //not from pallette but is arg
    }
  }

  void dragMove(Block draggingBlock) {
    if (draggingBlock.isFromPallette && !draggingBlock.isArgBlock()) {
      // from pallette but not arg
    } else if (draggingBlock.isFromPallette && draggingBlock.isArgBlock()) {
      // from pallette and it is arg
    } else if (!draggingBlock.isFromPallette && !draggingBlock.isArgBlock()) {
      //not from pallette and not arg
    } else if (!draggingBlock.isFromPallette && draggingBlock.isArgBlock()) {
      //not from pallette but is arg
    }
  }

  void dragEnd(Block draggingBlock) {
    if (draggingBlock.isFromPallette && !draggingBlock.isArgBlock()) {
      // from pallette but not arg
    } else if (draggingBlock.isFromPallette && draggingBlock.isArgBlock()) {
      // from pallette and it is arg
    } else if (!draggingBlock.isFromPallette && !draggingBlock.isArgBlock()) {
      //not from pallette and not arg
    } else if (!draggingBlock.isFromPallette && draggingBlock.isArgBlock()) {
      //not from pallette but is arg
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                editorData.editorPane.addBlockToStage(Block(
                  this.editorData,
                  key: GlobalKey(),
                  isDraggable: true,
                  color: Color(0xff3cc002),
                  type: [
                    "f",
                    "e",
                    "s",
                    "b",
                    "n",
                    "m",
                    "r",
                    "x"
                  ][Random().nextInt(8)],
                  specs: "this %b kjshdkjs %n hdj %s ",
                  x: 0,
                  y: 0,
                  onDragStart: (b, isfrompallette) {
                    if (!isfrompallette) {
                      editorData.blocks.remove(b);
                      editorData.editorPane.addBlockToStage(b);
                      b.setVisibility(false);
                    }
                  },
                  onDragMove: (b, details, isFromPallette) {},
                  onDragEnd: (b, details, isFromPallette) {},
                ));
              },
              child: Text("ADD")),
          Expanded(child: editorData.editorPane),
        ],
      ),
    );
  }
}
