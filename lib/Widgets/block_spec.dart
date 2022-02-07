import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/Widgets/block.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';
import 'package:flutter_application_1/Widgets/block_size.dart';

// ignore: must_be_immutable
class BlockSpec extends StatefulWidget {
  String? args;
  List<Widget> params = [];
  double width = 40;
  double height = 0;
  Block? block;
  void Function(Size)? onSizeChanged;

  BlockSpec({Key? key, this.args, this.block, this.onSizeChanged})
      : super(key: key){
         params = generateParams();
      }
List<Widget> generateParams() {
    params = [];
    for (String token in args!.split(" ")) {
      //if token is param
      if (token.length > 1 && token[0] == "%") {
        params.add(BlockArg(
            key: GlobalKey(),
            parentBlock: block,
            type: token[1],
            height: 20,
            width: 35));
      } else {
        params.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            token,
            style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        ));
      }
    }

    return params;
  }
  @override
  State<BlockSpec> createState() => _BlockSpecState();
}

class _BlockSpecState extends State<BlockSpec> {
  

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        widget.width = context.size!.width;
        widget.height = context.size!.height;
        widget.block?.width = context.size!.width;
        widget.block?.topH= context.size!.height;
        widget.block!.recalculateBlock();
      });
    });
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Wrap(
        children: [
          Row(
             mainAxisSize: MainAxisSize.min,
            children: widget.params,
          )
        ],
      ),
    );
  }
}
