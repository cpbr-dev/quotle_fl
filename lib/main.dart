import 'package:flutter/material.dart';
import 'package:quotle/src/game/playing_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quotle/src/main_menu.dart';
import 'package:quotle/src/settings/settings.dart';
import 'package:quotle/src/game/category_screen.dart';
import 'package:quotle/src/theme/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences mainSharedPreferences =
      await SharedPreferences.getInstance();
  runApp(MyApp(mainSharedPreferences: mainSharedPreferences));
}

class MyApp extends StatefulWidget {
  final SharedPreferences mainSharedPreferences;

  const MyApp({Key? key, required this.mainSharedPreferences})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() {
    setState(() {
      _isDarkMode = widget.mainSharedPreferences.getBool('isDarkMode') ?? false;
    });
  }

  void _updateTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });
    widget.mainSharedPreferences.setBool('isDarkMode', isDarkMode);
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
          '/categories': (context) => CategorySelectPage(),
          '/settings': (context) => SettingsPage(
                onThemeChanged: _updateTheme,
                mainSharedPreferences: widget.mainSharedPreferences,
              ),
          '/playing': (context) => PlayingPage(),
        });
  }
}
