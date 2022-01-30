import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/block.dart';

class LogicEditor extends StatelessWidget {
  const LogicEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      color: Colors.white,
      child: Stack(children: [
   Block(isDraggable: true, color: Colors.amber , type: "f" , topH: 20 , width: 80, x: 200 , y: 300, subAH: 0, subBH: 100, ) ,
    Block(
          isDraggable: true,
          color: Colors.blueAccent,
          type: "f",
          topH: 20,
          width: 80,
          x: 200,
          y: 300,
          subAH: 0,
          subBH: 100,
        ),        ]),
    );
  }
}
