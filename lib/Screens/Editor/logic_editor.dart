import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/editorpane.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor_data.dart';
import 'package:flutter_application_1/Widgets/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/block.dart';

// ignore: must_be_immutable
class LogicEditor extends StatelessWidget {
  late LogicEditorData editorData;

  //temp
  late String type = "s";
  late String label = "";
  late Color colour;
  late double x;
  late double y; //

  EditorPane editorPane = EditorPane();

  LogicEditor({Key? key}) : super(key: key) {
    editorData = LogicEditorData();
    editorPane = EditorPane(
      editor: editorData,
    );

    editorPane.indicator = ArgIndicator(
      key: GlobalKey(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          ElevatedButton(
              onPressed: () {
                editorPane.addBlock(generateBlock(GlobalKey(), x, y));
              },
              child: const Text("ADD")),
          Container(
            width: 250,
            color: const Color(0xffe0e0e0),
            child: ListView(
              children: [
                palletteBlock("r", "regular %s s %b b %n n"),
                palletteBlock("s", "regular %s s %b b %n n", color: Colors.red),
                palletteBlock("b", "regular %s s %b b %n n",
                    color: Colors.cyan),
                palletteBlock("n", "regular %s s %b b %n n",
                    color: Colors.orange),
                palletteBlock("f", "regular %s s %b b %n n",
                    color: Colors.amber),
                palletteBlock("e", "regular %s s %b b %n n",
                    color: Colors.indigo),
                palletteBlock("x", "regular %s s %b b %n n",
                    color: Colors.teal),
              ],
            ),
          ),
          Expanded(flex: 1, child: editorPane),
        ],
      ),
    );
  }

  //generates pallette blocks
  Block palletteBlock(String _type, String _specs,
      {Color color = const Color(0xff3cc002)}) {
    return Block(
      this,
      key: key,
      isFromPallette: true,
      isDraggable: true,
      color: color,
      type: _type,
      specs: _specs,
      x: 0,
      y: 0,
      onDragStart: (b) {
        type = _type;
        label = _specs;
        colour = color;
        startDrag(b);
      },
      onDragMove: (b, location) {
        moveDrag(b, location);
        print("move");
      },
      onDragEnd: (b, details) {
        endDrag(b);
      },
    );
  }

  //generates new block on drop from pallette
  Block generateBlock(GlobalKey key, double _x, double _y) {
    return Block(
      this,
      key: GlobalKey(),
      isFromPallette: false,
      isDraggable: true,
      color: colour,
      type: type,
      specs: label,
      x: _x,
      y: _y,
      onDragStart: (b) {
        startDrag(b);
      },
      onDragMove: (b, location) {
       // moveDrag(b, location);
         editorPane.findBlockArgs(b, Offset(b.x! , b.y!));
        
      },
      onDragEnd: (b, location) {
        endDrag(b);
      },
    );
  }

  void startDrag(Block draggingBlock) {
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

  void moveDrag(Block draggingBlock, Offset location) {
    if (draggingBlock.isFromPallette && !draggingBlock.isArgBlock()) {
      // from pallette but not arg
    } else if (draggingBlock.isFromPallette && draggingBlock.isArgBlock()) {
      // from pallette and it is arg
     
    } else if (!draggingBlock.isFromPallette && !draggingBlock.isArgBlock()) {
      //not from pallette and not arg
       editorPane.findBlockArgs(draggingBlock, location);
    } else if (!draggingBlock.isFromPallette && draggingBlock.isArgBlock()) {
      //not from pallette but is arg

      editorPane.findBlockArgs(draggingBlock, Offset(location.dx, location.dy));
    }
  }

  void endDrag(Block draggingBlock) {
    if (draggingBlock.isFromPallette && !draggingBlock.isArgBlock()) {
      // from pallette but not arg
      editorPane.addBlock(
          generateBlock(GlobalKey(), draggingBlock.x!, draggingBlock.y!));
    } else if (draggingBlock.isFromPallette && draggingBlock.isArgBlock()) {
      // from pallette and it is arg
      print("rjksj");
      editorPane.addBlock(
          generateBlock(GlobalKey(), draggingBlock.x!, draggingBlock.y!));
    } else if (!draggingBlock.isFromPallette && !draggingBlock.isArgBlock()) {
      //not from pallette and not arg

    } else if (!draggingBlock.isFromPallette && draggingBlock.isArgBlock()) {
      //not from pallette but is arg

    }
  }
}
