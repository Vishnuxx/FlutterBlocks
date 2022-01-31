import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/editorpane.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor_state.dart';
import 'package:flutter_application_1/Widgets/block.dart';

class LogicEditor extends StatelessWidget {
  late LogicEditorState editorState;

  LogicEditor({Key? key}) : super(key: key) {
    editorState = LogicEditorState();
    editorState.editorPane = EditorPane(
      editor: editorState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
   
      child: Row(
        children: [
          Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    editorState.editorPane.addBlockToStage(Block(
                      this.editorState,
                      key: GlobalKey(),
                      isDraggable: true,
                      color: Color(0xff3cc002),
                      type: ["f" , "e" , "s" , "b" ,"n" , "m" , "r", "x"][Random().nextInt(8)],
                      specs: "this %b kjshdkjs %n hdj %s ",
                      
                      x: 0,
                      y: 0,
                     
                    ));
                  },
                  child: Text("ADD")),
            ],
          ),
          Expanded(child: InteractiveViewer(child: editorState.editorPane)),
        ],
      ),
    );
  }
}
