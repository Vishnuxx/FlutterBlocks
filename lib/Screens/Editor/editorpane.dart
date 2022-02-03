import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor_data.dart';
import 'package:flutter_application_1/Widgets/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';
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

  EditorPane({Key? key, this.editor, this.width, this.height})
      : super(key: key);

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

  // used to find block args from editor
  void findBlockArgs(Block block, Offset details,
      {Offset offset = const Offset(0, 0)}) {
    for (Block b in blocks) {
      if (b.isVisible) {
        if (EditorPane.isHitting(b, details)) {
          b.setColor(Colors.green);
          BlockArg? arg = b.getArgAtLocation(details);

          if (arg != null && block.isArgBlock()) {
            indicator?.indicateArg(arg); //shows the indicztor
            print("shjdkks");
            currentDropZone = arg;
            return;
          } else {
            indicator?.indicateArg(null); //hides the indictor
          }
        } else {
          b.setColor(Colors.amber);
          print(false);
        }
      }
    }
    print("sjhdk");
    currentDropZone = this;
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
