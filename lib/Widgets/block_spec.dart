import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';

class BlockSpec extends StatelessWidget {
  String? args;
  List<Widget> params = [];
  BlockSpec({Key? key, this.args}) : super(key: key);

  List<Widget> generateParams() {
    for (String token in args!.split(" ")) {
      if (token.length > 1 && token[0] == "%") {
        params.add(
            BlockArg(key: GlobalKey(), type: token[1], height: 20, width: 35));
      } else {
        params.add(Padding(
          
          padding: const EdgeInsets.all(4.0),
          child: Text(
            token,
            style: TextStyle(
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Wrap(
        children: [
          Center(
            child: Row(
              children: generateParams(),
            ),
          )
        ],
      ),
    );
    
  }
}
