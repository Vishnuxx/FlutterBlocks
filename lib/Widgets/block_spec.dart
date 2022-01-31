import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/block_args.dart';

class BlockSpec extends StatelessWidget {
  String? args;
  List<Widget> params = [];
  BlockSpec({Key? key, this.args}) : super(key: key);

  Widget generateParams() {
    for (String token in args!.split(" ")) {
      if (token.length > 0 && token[0] == "%") {
        params.add(BlockArg(height: 20, width:35));
      } else {
        params.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(token , style: TextStyle(color: Colors.white70 , fontWeight: FontWeight.bold , fontSize: 14),),
        ));
      }
    }

    return Wrap(
        children: [
          Center(
            child: Row(
              children: params,
            ),
          )
        ],
      
    );
  }

  @override
  Widget build(BuildContext context) {
    return generateParams();
  }
}
