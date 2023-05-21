import 'package:flutter/material.dart';
import 'package:quotle/src/theme/theme_colors.g.dart';

class CustomTheme {
  static final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightColorScheme.background,
      fontFamily: 'Montserrat',
      colorScheme: lightColorScheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(lightColorScheme.secondaryContainer),
          foregroundColor:
              MaterialStateProperty.all(lightColorScheme.onSecondaryContainer),
          fixedSize: MaterialStateProperty.all(const Size(180, 48)),
        ),
      ));

  static final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkColorScheme.background,
      fontFamily: 'Montserrat',
      colorScheme: darkColorScheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(darkColorScheme.secondaryContainer),
          foregroundColor:
              MaterialStateProperty.all(darkColorScheme.onSecondaryContainer),
          fixedSize: MaterialStateProperty.all(const Size(180, 48)),
        ),
      ));

  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }
}
