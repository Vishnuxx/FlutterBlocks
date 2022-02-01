import 'package:flutter/material.dart';

class Bounds {
  static BuildContext? _rootcontext;
  static void setRootContext(BuildContext context) {
    Bounds._rootcontext = context;
  }

  double rootX(double x) {
    return x;
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}
