import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';
import 'package:flutter_application_1/Widgets/block_size.dart';

// ignore: must_be_immutable
class BlockSpec extends StatefulWidget {
  String? args;
  List<Widget> params = [];
  double width = 40;
  double height = 0;
  void Function(Size)? onSizeChanged;

  BlockSpec({Key? key, this.args, this.onSizeChanged}) : super(key: key);

  @override
  State<BlockSpec> createState() => _BlockSpecState();
}

class _BlockSpecState extends State<BlockSpec> {
  List<Widget> generateParams() {
    widget.params = [];
    for (String token in widget.args!.split(" ")) {
      //if token is param
      if (token.length > 1 && token[0] == "%") {
        widget.params.add(
            BlockArg(key: GlobalKey(), type: token[1], height: 20, width: 35));
      } else {
        widget.params.add(Padding(
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

    return widget.params;
  }

  @override
  void initState() {
    super.initState();
    widget.params = generateParams();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      widget.width = context.size!.width;
      widget.height = context.size!.height;
      widget.onSizeChanged!(context.size!);
    });
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: BlockSize(
        child: Wrap(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.params,
            )
          ],
        ),
        onChange: (size) {
          setState(() {
       
            widget.width = size.width;
            widget.height = size.height;
          });
        },
      ),
    );
  }
}
