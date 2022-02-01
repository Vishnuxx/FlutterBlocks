import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor_data.dart';
import 'package:flutter_application_1/Widgets/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';

class EditorPane extends StatefulWidget {
  static BuildContext? editorpanecontext;
  _EditorPaneState _state = _EditorPaneState();
  double? width = 200;
  double? height = 300;
  LogicEditorData? editor;

  EditorPane({Key? key, this.editor, this.width, this.height})
      : super(key: key) {}

  static Offset toRelativeOffset(Offset offset) {
    final mOff = (EditorPane.editorpanecontext?.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero);
    return offset.translate(-mOff.dx, -mOff.dy);
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

  // used to find block args from editor
  void findBlockArgs(Block block, Offset details,
      {Offset offset = const Offset(0, 0)}) {
    for (Block b in editor!.blocks) {
      if (b.isVisible) {
        Offset off = details;
        if (b.isHitting(off)) {
         
          BlockArg? arg = b.getArgAtLocation(off);

          if (arg != null && block.isArgBlock()) {
            block.editor.indicator?.indicateArg(arg); //shows the indicztor
          } else {
            block.editor.indicator?.indicateArg(null); //hides the indictor
          }
        }
      }
    }
  }

  @override
  State<EditorPane> createState() => _state;
}

class _EditorPaneState extends State<EditorPane> {
  @override
  void initState() {
    widget.editor!.helpers.add(widget.editor!.indicator!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditorPane.editorpanecontext = context;
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
