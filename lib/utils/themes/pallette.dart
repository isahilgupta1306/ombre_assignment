//palette.dart
import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor brandColor = MaterialColor(
    0xff6623e7, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff6623e7), //10%
      100: Color(0xff7539e9), //20%
      200: Color(0xff854fec), //30%
      300: Color(0xff9465ee), //40%
      400: Color(0xffb391f3), //50%
      500: Color(0xffc2a7f5), //60%
      600: Color(0xffd1bdf8), //70%
      700: Color(0xffe0d3fa), //80%
      800: Color(0xfff0e9fd), //90%
      900: Color(0xffffffff), //100%
    },
  );
}
