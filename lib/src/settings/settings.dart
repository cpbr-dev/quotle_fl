import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final SharedPreferences mainSharedPreferences;

  const SettingsPage({
    Key? key,
    required this.onThemeChanged,
    required this.mainSharedPreferences,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    widget.onThemeChanged(_isDarkMode);
    widget.mainSharedPreferences.setBool('isDarkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Dark mode'),
            value: _isDarkMode,
            onChanged: _toggleDarkMode,
          )
        ],
      ),
    );
  }
}
