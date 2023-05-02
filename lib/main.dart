import 'package:flutter/material.dart';
import 'package:quotle/src/main_menu.dart';
import 'package:quotle/src/settings/settings.dart';
import 'package:quotle/src/game/game_screen.dart';

import 'package:quotle/src/theme/custom_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _updateTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? CustomTheme.darkTheme : CustomTheme.lightTheme;
    return MaterialApp(
        title: 'My Game',
        theme: theme,
        home: Scaffold(
          appBar: AppBar(),
          body: MainMenu(),
        ),
        routes: {
          '/game': (context) => GamePage(),
          '/settings': (context) => SettingsPage(
                onThemeChanged: _updateTheme,
              ),
        });
  }
}
