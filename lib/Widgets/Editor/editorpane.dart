import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/Editor/editorpane_Utils.dart';
import 'package:flutter_application_1/Widgets/Block/Block/block.dart';
import 'package:flutter_application_1/Widgets/BlockUtils/droppable_regions.dart';

// ignore: must_be_immutable
class EditorPane extends StatefulWidget implements DroppableRegion {
  static BuildContext? editorpanecontext;
  final _EditorPaneState _state = _EditorPaneState();
  double? width = 200;
  double? height = 300;

  late EditorPaneUtils paneUtils;

  EditorPane({Key? key, this.width, this.height}) : super(key: key) {
    paneUtils = EditorPaneUtils(this);
    paneUtils.currentDropZone = this;
  }

  void addHelper(Widget helper) {
    // ignore: invalid_use_of_protected_member
    _state.setState(() {
      paneUtils.helpers.add(helper);
    });
  }

  @override
  void addBlock(Block block) {
    print("add Block");
    // ignore: invalid_use_of_protected_member
     paneUtils.blocks.add(block);
    _state.setState(() {
      block.isInEditor = true;
      block.setParent(this);
      paneUtils.blocks;
      
    });
  }

  @override
  void removeBlock(Block block) {
    // ignore: invalid_use_of_protected_member
    _state.setState(() {
      paneUtils.blocks.remove(block);
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

  @override
  // ignore: no_logic_in_create_state
  State<EditorPane> createState() => _state;
}

class _EditorPaneState extends State<EditorPane> {
  @override
  void initState() {
    widget.paneUtils.helpers.add(widget.paneUtils.indicator);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditorPane.editorpanecontext = context;
    return Stack(children: [
      ...widget.paneUtils.blocks,
      ...widget.paneUtils.helpers,
    ]);
  }
}
