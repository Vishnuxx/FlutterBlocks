import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/logic_editor.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(backgroundColor: Colors.white),
        home: Scaffold(
            // appBar: AppBar(
            //   title: const Text("blocks"),
            // ),
            body: const LogicEditor())
    );
  }
}
