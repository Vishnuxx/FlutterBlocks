import 'package:flutter/material.dart';

class BlockSpec extends StatelessWidget {
  String? args;
  List<Widget> params = [];
  BlockSpec({Key? key, this.args}) : super(key: key);

  Widget generateParams() {
    for (String token in args!.split(" ")) {
      if (token.length > 0 && token[0] == "%") {
        params.add(Container(width: 30, height: 20, color: Colors.white));
      } else {
        params.add(Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(token , style: TextStyle(color: Colors.white60),),
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
