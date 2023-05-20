import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:quotle/src/pages/menu_page.dart';
import 'package:quotle/src/pages/settings_page.dart';
import 'package:quotle/src/pages/category_page.dart';
import 'package:quotle/src/theme/custom_theme.dart';
import 'package:quotle/src/pages/playing_page.dart';
import 'package:quotle/src/pages/about_page.dart';

import 'src/classes/language_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences mainSharedPreferences =
      await SharedPreferences.getInstance();
  await dotenv.load(fileName: ".env");
  runApp(MyApp(mainSharedPreferences: mainSharedPreferences));
}

class MyApp extends StatefulWidget {
  final SharedPreferences mainSharedPreferences;

  const MyApp({Key? key, required this.mainSharedPreferences})
      : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

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
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? CustomTheme.darkTheme : CustomTheme.lightTheme;
    return MaterialApp(
        title: 'Quotle',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _locale,
        theme: theme,
        home: Scaffold(
          appBar: AppBar(),
          body: const MainMenu(),
        ),
        routes: {
          '/categories': (context) => const CategorySelectPage(),
          '/settings': (context) => SettingsPage(
                onThemeChanged: _updateTheme,
                mainSharedPreferences: widget.mainSharedPreferences,
              ),
          '/loading': (context) => PlayingPage(
                category: ModalRoute.of(context)!.settings.arguments as String,
              ),
          '/about': (context) => const AboutPage(),
        });
  }
}
