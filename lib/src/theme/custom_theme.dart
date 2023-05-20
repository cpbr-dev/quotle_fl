import 'package:flutter/material.dart';
import 'package:quotle/src/theme/theme_colors.g.dart';

class CustomTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightColorScheme.background,
    fontFamily: 'Montserrat',
    colorScheme: lightColorScheme,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkColorScheme.background,
    fontFamily: 'Montserrat',
    colorScheme: darkColorScheme,
  );

  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }
}
