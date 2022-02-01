import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Editor/editorpane.dart';
import 'package:flutter_application_1/Widgets/arg_indicatior.dart';
import 'package:flutter_application_1/Widgets/block.dart';

class LogicEditorState {
  List<Block> blocks = [];
  List<Widget> helpers = [];
  late EditorPane editorPane;
   ArgIndicator? indicator;
}
