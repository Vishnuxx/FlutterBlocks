import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor_state.dart';
import 'package:flutter_application_1/Widgets/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/block.dart';

class EditorPane extends StatefulWidget {
  _EditorPaneState _state = _EditorPaneState();
  double? width = 200;
  double? height = 300;
  LogicEditorState? editor;
 

  EditorPane({Key? key, this.editor, this.width, this.height})
      : super(key: key) {
        
      }
    


  void addBlockToStage(Block block) {
    _state.setState(() {
      editor?.blocks.add(block);
    });
  }

  void addHelper(Widget helper) {
    _state.setState(() {
      editor?.helpers.add(helper);
    });
  }

  @override
  State<EditorPane> createState() => _state;
}

class _EditorPaneState extends State<EditorPane> {

  @override
  void initState() {
    widget.editor!.helpers.add( widget.editor!.indicator!);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(children: [
        
        ...widget.editor!.blocks,
        ...widget.editor!.helpers,
      ]),
    );
  }
}
