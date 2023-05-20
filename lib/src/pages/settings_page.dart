import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';
import '../classes/language.dart';
import '../classes/language_constants.dart';

class SettingsPage extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final SharedPreferences mainSharedPreferences;

  const SettingsPage({
    Key? key,
    required this.onThemeChanged,
    required this.mainSharedPreferences,
  }) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  final List<String> list = <String>['Français', 'English'];

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
        title: Text(AppLocalizations.of(context)!.settingsButton),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.darkModeText),
            value: _isDarkMode,
            onChanged: _toggleDarkMode,
          ),
          DropdownButton<Language>(
            iconSize: 30,
            hint: Text(translation(context).changeLanguage),
            onChanged: (Language? language) async {
              if (language != null) {
                Locale locale = await setLocale(language.languageCode);
                // ignore: use_build_context_synchronously
                MyApp.setLocale(context, locale);
              }
            },
            items: Language.languageList()
                .map<DropdownMenuItem<Language>>(
                  (e) => DropdownMenuItem<Language>(
                    value: e,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(e.name),
                      ],
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
