import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/block_size.dart';
import 'package:flutter_application_1/Widgets/draw_block.dart';

class BlockArg extends StatelessWidget {
  String? type = "r";
  double? width = 30;
  double? height = 20;

  BlockArg({Key? key, this.type, this.width = 30, this.height = 20}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    Widget widget = BlockSize(
      onChange: (size) {
        width = size.width;
      }, 
    child: Container(
      width: width,
      height: height,
      child: Stack(children: [
        CustomPaint(
          painter: DrawBlock(
          blockColor: Colors.white,
          type: "s" ,
          width: width! ,
          topH: height!
         )
        )
        
      ],),
    )
  
  );

    return widget;
  }
}
