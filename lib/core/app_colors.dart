import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF157DFF);
  static const Color primaryDarker = Color(0xFF022949);

  static const Color surfaceLight = Color(0xFFAEE5FF);

  static const Color accentShadow = Colors.amber;
  static const Color link = Colors.blue;
  static const Color appBarShadow = Colors.cyan;

  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static Color get greyLight => Colors.grey.shade200;
}
