import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TODO_themes {
  static final lighttheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  );
  static final darktheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: HexColor('#282828'),
    backgroundColor: HexColor('#282828'),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  );
}
