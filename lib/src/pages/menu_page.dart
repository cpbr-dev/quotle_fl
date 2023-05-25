import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quotle/src/Widgets/quote_container.dart';

import '../classes/quote.dart';
import '../classes/word.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu>
    with SingleTickerProviderStateMixin {
  bool _isTitle = true;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool overlayActive = false;

  Quote testQuote = Quote(category: 'help');

  @override
  void initState() {
    super.initState();

    testQuote.quoteBody = "You, shall not, pass!";
    testQuote.authorName = "Gandalf";

    _controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _toggleImage() {
    setState(() {
      _isTitle = !_isTitle;
    });

    if (_isTitle) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RotationTransition(
              turns: _animation,
              child: GestureDetector(
                onTap: _toggleImage,
                child: SvgPicture.asset(
                  _isTitle
                      ? 'assets/svg/app_title.svg'
                      : 'assets/svg/app_logo.svg',
                  width: 200,
                  height: 87,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.inverseSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsetsDirectional.only(bottom: 16, top: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/categories');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const FaIcon(FontAwesomeIcons.play),
                        Text(AppLocalizations.of(context)!.playButton),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsetsDirectional.only(bottom: 16, top: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/stats');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.bar_chart),
                        Text(AppLocalizations.of(context)!.statisticTitle)
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsetsDirectional.only(bottom: 16, top: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const FaIcon(FontAwesomeIcons.gears),
                        Text(AppLocalizations.of(context)!.settingsButton),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsetsDirectional.only(bottom: 16, top: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/about');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const FaIcon(FontAwesomeIcons.info),
                        Text(AppLocalizations.of(context)!.aboutButton),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          setState(() {
            showHelpOverlay();
          });
        },
        icon: overlayActive ? const Icon(Icons.close) : const Icon(Icons.help),
        iconSize: 48,
      ),
    );
  }

  Future showHelpOverlay() => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
              alignment: Alignment.center,
              content: FractionallySizedBox(
                heightFactor: 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.helpTitle,
                        style: Theme.of(context).textTheme.headlineMedium),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(AppLocalizations.of(context)!.helpText),
                        QuoteContainer(
                          quote: testQuote,
                        ),
                        Text(
                            '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t - ${testQuote.author}'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ButtonBar(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(AppLocalizations.of(context)!.returnText),
                    ),
                  ],
                ),
              ]),
        );
      });
}
