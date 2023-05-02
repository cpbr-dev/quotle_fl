import 'package:flutter/material.dart';
import 'package:quotle/src/theme/custom_theme.dart';

class SettingsPage extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({Key? key, required this.onThemeChanged})
      : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    widget.onThemeChanged(_isDarkMode);
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
